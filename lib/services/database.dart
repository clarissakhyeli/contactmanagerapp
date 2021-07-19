import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contactmanagerapp/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('user');

  Future<void> updateUserData(
      String name,
      String email,
      String contactNo,
      String cName,
      String cContactNo,
      String cAddress) async {
    return await userCollection.document(uid).setData({
      'Name' : name,
      'Email' : email,
      'ContactNo' : contactNo,
      'CName' : cName,
      'CContactNo' : cContactNo,
      'CAddress' :cAddress
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['Name'],
      email: snapshot.data['Email'],
      contactNo: snapshot.data['ContactNo'],
      cName: snapshot.data['CName'],
      cContactNo: snapshot.data['CContactNo'],
      cAddress: snapshot.data['CAddress']
    );
  }

  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}