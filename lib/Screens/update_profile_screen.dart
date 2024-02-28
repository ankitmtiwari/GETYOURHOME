import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_your_home/services/firestore_services.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {



  //clicked on submit or not ...  for showing progress indicator
  bool _isUploading=false;

  //current logged in users instance
  User? user=FirebaseAuth.instance.currentUser;
  //variables to store current users detais
  String? fName,lName,profilePicUrl,email,phone;


  //text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //reg exp for validation
  final RegExp emailRegex = RegExp(r"""
^[r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]""");
  final RegExp nameRegex = RegExp(r"^[a-zA-z]{3}");
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');


  //instance of image picker
  final ImagePicker _picker = ImagePicker();
  //file variable that will store the selected image file
  File? file;

  //method to pick image
  pickImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedFile?.path==null){
      Fluttertoast.showToast(msg: "Please select image once again..");

    }else{
      setState(() {
        file = File(pickedFile!.path);
      });

      //if file is selected successfully then upload it to storage
      if(file!=null){
        uploadProfilePic();
      }
    }

  }

  //method to upload the selected file
  uploadProfilePic() async{
    try{
      Fluttertoast.showToast(msg: "Updating Please Wait...");
      var imageFile=FirebaseStorage.instance.ref().child("Users").child(email!);
      UploadTask task=imageFile.putFile(file!);
      TaskSnapshot snapshot=await task.whenComplete(() => Fluttertoast.showToast(msg: "Processing.."));
      String url =await snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance.collection("users").doc(email).update({
        "Profile Pic":url
      }).whenComplete(() => Fluttertoast.showToast(msg: "Upload Done.."));
      getUserDetails();
    }on FirebaseException catch (e){
      Fluttertoast.showToast(msg: e.message.toString(),textColor: Colors.red);
    }
  }

  //method to get the current logged in users details
  Future getUserDetails()async{
    DocumentSnapshot ds= await FirebaseFirestore.instance.collection("users").doc(user?.email.toString()).get();
    if(ds.exists){
      Map<String, dynamic>? fetchProfile = ds.data() as Map<String, dynamic>?;
      setState(() {
        // store the fetched values to the text feild and variables
        _firstNameController.text=fetchProfile?['First Name'];
        _lastNameController.text=fetchProfile?['Last Name'];
        _emailController.text=fetchProfile?['Email'];
        _phoneController.text=fetchProfile?['Phone Number'];
        profilePicUrl=fetchProfile?['Profile Pic'];
        email=user?.email.toString();
      });
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get the users details first when screen is loaded
    getUserDetails();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo
                Center(
                    child: Stack(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child:CachedNetworkImage(
                              imageUrl: profilePicUrl.toString(),
                              progressIndicatorBuilder: (context, profilePicUrl, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              height: MediaQuery.of(context).size.height*0.40,
                              width: MediaQuery.of(context).size.width*0.50,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child:  InkWell(
                              onTap: pickImage,
                              child: ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.blue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                //First name Text Feild
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (!nameRegex.hasMatch(value!)) {
                        return 'Please Enter Valid Name';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "First Name",
                      prefixIcon: const Icon(Icons.account_box),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),

                //Last name Text Feild
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (!nameRegex.hasMatch(value!)) {
                        return 'Pleas Enter Valid Name';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      prefixIcon: const Icon(Icons.account_box),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                //Phone Number Text Field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextFormField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (!phoneRegex.hasMatch(value!)) {
                        return 'Please enter valid phone number';
                      }
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      hintText: "Phone no.",
                      prefixIcon: const Icon(Icons.call),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.001,
                ),
                //E-mail Text Field
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextFormField(
                    enabled: false,
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!emailRegex.hasMatch(value!)) {
                        return 'Please enter valid email';
                      }
                    },
                    decoration: InputDecoration(
                      // labelText: "Email",
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                Center(
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape:const StadiumBorder(),
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                    ),
                    autofocus: true,
                    clipBehavior: Clip.none,
                    child:_isUploading==true?const CircularProgressIndicator(color: Colors.white,):const Text("Update"),
                    onPressed:(){
                      setState(() {
                        _isUploading=true;
                      });
                      FirestoreDatabase().updateUser(_firstNameController.text,
                          _lastNameController.text, _phoneController.text, _emailController.text)
                          .then((value) => Fluttertoast.showToast(msg: "Updating...."))
                      .then((value) => Fluttertoast.showToast(msg: "Successful"))
                          .whenComplete(() => Navigator.pop(context));
                     
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
