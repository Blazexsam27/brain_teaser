import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future signUpUserByEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if( userCredential != null ){
        return userCredential;
      }
    }catch(e){
      return null;
    }
  }

  Future signInUser(String email, String password) async {
    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if( userCredential != null ){
        return userCredential;
      }
    }catch(e){
      return null;
    }
  }

  Future signOut() async {
    return await firebaseAuth.signOut();
  }
}
