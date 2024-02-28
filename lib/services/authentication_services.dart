import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_your_home/services/firestore_services.dart';

class Authentication {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  //common error toast
  void errorToast(String errorString){
    Fluttertoast.showToast(msg: errorString,
        backgroundColor: Colors.red,
        textColor: Colors.white
    );

  }

  //method to create new user
  Future<User?> register(String email, String password,String fName,String lName,String phoneNo) async {
    try {
      await _authInstance
          .createUserWithEmailAndPassword(email: email, password: password).whenComplete(() {
        if(_authInstance.currentUser != null){
          //after creating user save their data
          FirestoreDatabase().createUser(fName, lName, phoneNo, email,_authInstance.currentUser?.uid.toString());
          Fluttertoast.showToast(msg: "Account Created Successfully...");
        }
      });
      return _authInstance.currentUser;
    }on FirebaseAuthException catch(error) {
errorToast(error.message.toString());
    }
    return _authInstance.currentUser;
  }

  //method to login
  Future<User?> login(String email, String password) async {
    User? user;
    try{
      user= await _authInstance.signInWithEmailAndPassword(
          email: email, password: password).then((value) => value.user);
      return user;

    }on FirebaseAuthException catch(error){
      errorToast(error.message.toString());
    }
    return  user;
  }

  //method to log out
  Future<void> logOut() async {
    try{
      await _authInstance.signOut().whenComplete(() => Fluttertoast.showToast(msg: "Logged Our Successfully"));
    }on FirebaseAuthException catch(error){
      errorToast(error.message.toString());
    }
  }


  //method to send password reset link
 Future<void> sendResetLink(String email)async{
    try{
      _authInstance.sendPasswordResetEmail(email: email )
          .onError((error, stackTrace) => errorToast(error.toString()))
          .whenComplete(() =>
          Fluttertoast.showToast(msg: "Reset link sent on your mail id please check",toastLength:Toast.LENGTH_LONG),
      );
    }catch (e){
      errorToast(e.toString());
    }
  }

}
