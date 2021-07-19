import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactmanagerapp/models/user.dart';
import 'package:contactmanagerapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_contact.dart';

class Home extends StatefulWidget {
  static const route = '/first';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  TextEditingController _searchController = TextEditingController();
  List _allContacts = [];
  List _resultsList = [];
  Future resultsLoaded;

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }
  
  @override void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _allContacts = [];
    _resultsList = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getContactsSnapshot();
  }

  _onSearchChanged() {
    searchResultsList();
    print(_searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if(_searchController.text != "") {
      for (var contact in _allContacts) {
        var name = contact['fullName'].toLowerCase();
        var contactNo = contact['contactNo'];
        if(name.contains(_searchController.text.trim().toLowerCase())) {
          showResults.add(contact);
        } else if(contactNo.contains(_searchController.text.trim().toLowerCase())) {
          showResults.add(contact);
        }
      }
    } else {
      showResults = [];
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getContactsSnapshot() async {
    final user = Provider.of<UserModel>(context);
    var contactCollection = await Firestore.instance
        .collection('user')
        .document(user.uid)
        .collection('contact')
        .orderBy('fullName')
        .getDocuments();

    setState(() {
      _allContacts = contactCollection.documents;
    });
    searchResultsList();
    return contactCollection.documents;
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    Query contactCollection = Firestore.instance.collection('user')
        .document(user.uid)
        .collection('contact').orderBy('fullName');

    return Scaffold(
        appBar: AppBar(
          title: Text('Home - Contacts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
          backgroundColor: Colors.blueGrey[400],
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,

        ),
        
        body:  Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.all(8.0),
                child: new TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 20),
                    hintText: 'Search Contacts',
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),

            _resultsList.length == 0
              ? Expanded(
                child: StreamBuilder(
                    stream: contactCollection.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return ListView.builder(
                        reverse: false,
                        itemCount: snapshot.hasData?snapshot.data.documents.length:0,
                        itemBuilder: (_,index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => EditContact(docToEdit: snapshot.data.documents[index],)));
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 65,
                              decoration: new BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              child: ListTile(
                                leading: CircleAvatar(child: Icon(Icons.person), backgroundColor: Colors.blueGrey, foregroundColor: Colors.white,),
                                //leading: CircleAvatar(child: Text(snapshot.data.documents[index].data['fullName'.initials()]),),
                                title: Text(snapshot.data.documents[index].data['fullName'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                subtitle: Text(snapshot.data.documents[index].data['contactNo']),
                                dense: true,
                              ),
                            ),
                          );
                        },
                      );
                    })
            ) : Expanded(
              child: FutureBuilder(
                future: getContactsSnapshot(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                    return CircularProgressIndicator();
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: false,
                      itemCount: _resultsList.length,
                      itemBuilder: (context, index){
                        var result = _resultsList[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => EditContact(docToEdit: _resultsList[index],)));
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 65,
                            decoration: new BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: ListTile(
                              leading: CircleAvatar(child: Icon(Icons.person), backgroundColor: Colors.blueGrey, foregroundColor: Colors.white,),
                              title: Text(_resultsList[index].data['fullName'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                              subtitle: Text(_resultsList[index].data['contactNo']),
                              dense: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              ),
              ],
          ),
        ),
    );
  }
}