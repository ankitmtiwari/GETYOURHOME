

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreDatabase{
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;

  Future<void> createUser(firstname,lastname,phone,email,uid)async {
    await firebaseFirestore.collection("users").doc(email).set({
      'First Name': firstname,
      'Last Name': lastname,
      'Email': email,
      'Phone Number': phone,
      'uid':uid
    }).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future<void> updateUser(firstname,lastname,phone,email)async {
    Fluttertoast.showToast(msg: "update started");
    await firebaseFirestore.collection("users").doc(email).update({
      'First Name': firstname,
      'Last Name': lastname,
      //'Email': email,
      'Phone Number': phone,
      //'uid':uid
    });
  }




  Future<void> uploadProperty (
      String currentUserUid,
    String currentUserEmail,
    String title,
    String type,
    String builtArea,
    String carpetArea,
    String listingType,
    String rooms,
    String amount,
    String address,
    String pinCode,
    String nearByStation,
    String landmark,
    String localArea,
      String description,
      String propertyPicUrl,
      String date

      ) async {
    try {
      await FirebaseFirestore.instance.collection("properties").add({
        'uid': currentUserUid ,
        'email': currentUserEmail ,
        'title':title,
        'type':type,
        'builtArea':builtArea,
        'carpetArea':carpetArea,
        'listingType':listingType,
        'rooms':rooms,
        'amount':amount,
        'address':address,
        'pinCode':pinCode,
        'nearStation':nearByStation,
        'landmark':landmark,
        'localArea':localArea,
        'description':description,
        'propertyPicUrl':propertyPicUrl,
        'date':date
      }).whenComplete(() => Fluttertoast.showToast(msg: "Uploaded Successfully"));
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }




  Future<void> updateProperty (
      String propertyId,
      String currentUserUid,
      String currentUserEmail,
      String title,
      String type,
      String builtArea,
      String carpetArea,
      String listingType,
      String rooms,
      String amount,
      String address,
      String pinCode,
      String nearByStation,
      String landmark,
      String localArea,
      String description,
      String propertyPicUrl,
      String date

      ) async {
    try {
      await FirebaseFirestore.instance.collection("properties").doc(propertyId).update({
        'uid': currentUserUid ,
        'email': currentUserEmail ,
        'title':title,
        'type':type,
        'builtArea':builtArea,
        'carpetArea':carpetArea,
        'listingType':listingType,
        'rooms':rooms,
        'amount':amount,
        'address':address,
        'pinCode':pinCode,
        'nearStation':nearByStation,
        'landmark':landmark,
        'localArea':localArea,
        'description':description,
        'propertyPicUrl':propertyPicUrl,
        'date':date
      }).whenComplete(() => Fluttertoast.showToast(msg: "Uploaded Successfully"));
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    }
  }



  }

