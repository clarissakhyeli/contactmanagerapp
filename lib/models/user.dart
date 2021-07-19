class UserModel {

  final String uid;
  UserModel({ this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String email;
  final String contactNo;
  final String cName;
  final String cContactNo;
  final String cAddress;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.contactNo,
    this.cName,
    this.cContactNo,
    this.cAddress
});
}