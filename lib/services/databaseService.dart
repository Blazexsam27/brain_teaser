import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  FirebaseFirestore db = FirebaseFirestore.instance;
  QuerySnapshot snapshot;

  Future getUserByEmail(String email) async{
    snapshot = await db.collection('users').where('email', isEqualTo: email).get();
    return snapshot;
  }

  getUserByUsername(String username) async{
    return await db.collection('users').where('name', isEqualTo: username).get();
  }

  uploadUserInf(Map<String, String> userInfo){
    db.collection('users').add(userInfo).catchError((e){ print(e.toString());});
  }

}