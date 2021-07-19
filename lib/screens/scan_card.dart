import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commons/commons.dart';
import 'package:contactmanagerapp/models/user.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ScanBusinessCardScreen extends StatefulWidget {
  static const route = '/second';
  ScanBusinessCardScreen({Key key}) : super(key: key);

  @override
  _ScanBusinessCardState createState() => _ScanBusinessCardState();
}

class _ScanBusinessCardState extends State<ScanBusinessCardScreen> {
  CameraController _controller;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      _controller = new CameraController(cameras[0], ResolutionPreset.high);
      await _controller.initialize();
    } on CameraException catch (_) {
      debugPrint("Camera initialization failed");
    }
    if (!mounted) {
      return;
    }
    setState(() {
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    if(!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    if(_controller.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      await _controller.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: null_aware_in_condition
      body: _controller?.value?.isInitialized
         ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ButtonTheme(
                minWidth: 30.0,
                height: 50.0,
                buttonColor: Colors.white60,
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  icon: Icon(Icons.camera),

                  label: Text("cam"),
                  onPressed: () async {
                    await _takePicture().then((String path) {
                      if(path != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConfirmDataScreen(imagePath: path),
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          )
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ConfirmDataScreen extends StatefulWidget {
  final String imagePath;
  ConfirmDataScreen({Key key,
    @required this.imagePath,
  }) : super(key: key);

  @override
  _ConfirmDataScreenState createState() => _ConfirmDataScreenState(imagePath);
}

class _ConfirmDataScreenState extends State<ConfirmDataScreen> {
  _ConfirmDataScreenState(this.path);
  GlobalKey<FormState> _formKey;

  final String path;
  Size _imageSize;
  List<TextElement> _elements = [];
  String result_name = "";
  String result_email = "Loading...";
  String result_phone = "Loading...";
  String result_cPhone = "Loading...";
  String result_cName = "Loading...";
  String result_cAddress = "Loading...";
  String result_website = "Loading...";
  String _result = "Loading";
  String error = '';

  @override
  void initState() {
    _initializeVision();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void _initializeVision() async {
    final File imageFile = File(path);
    String result = "";

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String namePattern =
        r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)$";
    RegExp regExName = RegExp(namePattern);

    String emailPattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(emailPattern);

    String phonePattern =
        r"^(\+?[0-9]*)?\(?\d{3,4}\)?[\s,-]\d{3,4}[\s,-]\d{4,5}$";
    RegExp regExPhone = RegExp(phonePattern);

    String cPhonePattern =
        r"^(\+?[0-9]*)?\(?\d{2,3}\)?[\s,-]\d{3,4}[\s,-]\d{3,4}$";
    RegExp regExCPhone = RegExp(cPhonePattern);

    String companyNamePattern =
        r'^(?=.*?[A-Z])';
    RegExp regExCName = RegExp(companyNamePattern);

    String firstAddress =
        r"^(((No\.)?(Lot)?(No)?(NO.)?(NO)?(LOT)?\s)([-a-zA-Z0-9:%.\+~#=]{2,256}?\,?)\s?)((([-a-zA-Z0-9:%.\/+~#=]{2,256}\s?\d?\,?\s?){1,4}))$";
    RegExp regExFA = RegExp(firstAddress);

    String lastAddress =
        r"^(\d{5}\s?\,?)(((Malaysia)?(MALAYSIA)([-a-zA-Z0-9:%.\+~#=]{2,256}\s?\,?\.?)*)\s?)?((([-a-zA-Z0-9:%.\+~#=]{2,256}\s?\,?\.?){1,4}))$";
    RegExp regExLA = RegExp(lastAddress);

    String website =
        r"^[a-z ,.'-]+$";
    RegExp regExW = RegExp(website);

    String fullName = "";
    String mailAddress = "";
    String phoneNum = "";
    String cPhoneNum = "";
    String cName = "";
    String locationAddress = "";
    String cWebsite = "";

    if(_result !=null) {
      for (TextBlock block in visionText.blocks) {
        if (regExFA.hasMatch(block.text) && regExLA.hasMatch(block.text)
            || block.text.contains(", Malaysia")){
          locationAddress += block.text + '\n';
          break;
        } else{
          for (TextLine line in block.lines) {
            result += line.text +'\n';
            if (regExName.hasMatch(line.text)
                || line.text.contains("Name: ")){
              fullName.replaceAll("Name: ", "");
              fullName += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            } else if (regEx.hasMatch(line.text)
                || line.text.contains("Email")
                || line.text.contains("@")){
              mailAddress += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            }  else if (regExPhone.hasMatch(line.text)
                || line.text.contains("Mobile")
                || line.text.contains("+")
                || line.text.contains("+60 1")) {
              phoneNum.replaceAll("HP:", "");
              phoneNum += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            } else if (regExCPhone.hasMatch(line.text)
                || line.text.contains("Tell")
                || line.text.contains("+60")
                || line.text.contains("603")) {
              cPhoneNum += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            } else if (regExCName.hasMatch(line.text)
                || line.text.contains("Berhad")
                || line.text.contains("Sdn") && line.text.contains("Bhd")
                || line.text.contains("SDN") && line.text.contains("BHD")) {
              cName += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            } else if (regExW.hasMatch(line.text)
                || line.text.contains("www.")){
              cWebsite += line.text + '\n';
              for (TextElement element in line.elements) {
                _elements.add(element);
              }
              break;
            }
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {
        result_name = fullName;
        result_email = mailAddress;
        result_phone = phoneNum;
        result_cPhone = cPhoneNum;
        result_cName = cName;
        result_cAddress = locationAddress;
        result_website = cWebsite;
        _result = result;
        debugPrint(_result);
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);

    image.image
        .resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    CollectionReference contactCollection = Firestore.instance
          .collection('user')
          .document(user.uid)
          .collection('contact');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, size: 17,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text ('Scanned Details',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.done_rounded),
              onPressed: () {
                confirmationDialog(
                    context,
                    "Create contacts?",
                    positiveText: "Create",
                    positiveAction: () {
                      if(_formKey.currentState.validate()) {
                        contactCollection.add({
                          'fullName': result_name,
                          'email': result_email,
                          'contactNo': result_phone,
                          'cPhoneNo': result_cPhone,
                          'cName': result_cName,
                          'cAddress': result_cAddress,
                          'website': result_website

                        }).whenComplete(() => Navigator.pop(context));
                            print('saved!!');

                      }  else {
                        print('not saved');

                      }
                    }
                );
              }),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
            child: new ListView(
              children: <Widget>[
                SizedBox(height:20.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_name),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Full Name",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.email_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_email),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_phone),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Contact No.",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Contact Number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.work_outline_rounded),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_cAddress),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Company Name",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Company Name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_cPhone),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Company Phone No.",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Company Phone Number';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.place_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_cName),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Company Address",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please Enter Company Address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:12.0),
                new ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  minLeadingWidth: 3.0,
                  title: new TextFormField(
                    controller: TextEditingController(text: result_website),
                    maxLines: 1,
                    decoration: new InputDecoration(
                      labelText: "Website",
                      fillColor: Colors.white,
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
