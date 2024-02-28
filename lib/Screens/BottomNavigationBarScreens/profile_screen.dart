
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_your_home/Screens/Owner%20Screens/add_property_screen.dart';
import 'package:get_your_home/Screens/forget_password_screen.dart';
import 'package:get_your_home/Screens/Owner%20Screens/my_properties_screen.dart';
import 'package:get_your_home/services/authentication_services.dart';
import 'package:image_picker/image_picker.dart';
import '../update_profile_screen.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //current user
  User? user=FirebaseAuth.instance.currentUser;


  //imgDownloadUrl used when new profile pic will be uploaded
  //profilePicUrl used when showing the existing profile pic
  String? name,phone,imgDownloadUrl,profilePicUrl,email;



  //get all the details of the logged in user
  Future getUserDetails()async{
    DocumentSnapshot ds= await FirebaseFirestore.instance.collection("users").doc(user?.email.toString()).get();
    if(ds.exists){
      Map<String, dynamic>? fetchProfile = ds.data() as Map<String, dynamic>?;
      setState(() {
        //store the fetched values in the variables
        name=fetchProfile?['First Name']+" "+fetchProfile?['Last Name'].toString();
        profilePicUrl=fetchProfile?['Profile Pic'];
        email=user?.email.toString();
        phone=fetchProfile?['Phone Number'];
      });
    }

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }



  //instance of the image picker
   final ImagePicker _picker = ImagePicker();
  //file that will store the selected image
    File? file;

 // var profilePic=  const NetworkImage('https://i1.sndcdn.com/artworks-000175930618-pg6ffe-t500x500.jpg');

   pickImage() async {
     var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if(pickedFile?.path==null){
       Fluttertoast.showToast(msg: "Try Again..");
      }else{
        setState(() {
          file = File(pickedFile!.path);
        });
        //if file is selected successfully then upload the file
        if(file!=null){
          uploadProfilePic();
        }
      }

  }

  //upload the selected file
  uploadProfilePic() async{
     try{
       Fluttertoast.showToast(msg: "Updating Please Wait...");
       var imageFile=FirebaseStorage.instance.ref().child("Users").child(email!);
       UploadTask task=imageFile.putFile(file!);
       TaskSnapshot snapshot=await task;
       String url =await snapshot.ref.getDownloadURL();
         FirebaseFirestore.instance.collection("users").doc(email).update({
           "Profile Pic":url
         }).whenComplete(() => Fluttertoast.showToast(msg: "Upload Done.."));
         getUserDetails();

     }on FirebaseException catch (e){
       Fluttertoast.showToast(msg: e.message.toString(),textColor: Colors.red);
     }
  }

  @override
  Widget build(BuildContext context) {
    var borderRadius = const BorderRadius.only(topRight: Radius.circular(32), bottomRight: Radius.circular(32));
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0.0,
        actions:  [
           IconButton(
           icon: const Icon(Icons.logout),
             tooltip: "LogOut",
             color: Colors.white,
             onPressed: () {
             Fluttertoast.showToast(msg: "Logging Out Please Wait...");
             Authentication().logOut();
             },)
        ],
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
                    ]
                  )),
                const SizedBox(height: 20.0,),
                 Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                          Icons.person,
                      color: Colors.black,
                      ),
                      Text(name??"loading..",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                      ),),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.call,
                        color: Colors.grey,
                      ),
                      Text(phone ?? "loading",
                        style:  const TextStyle(
                            color: Colors.grey
                        ),),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0,),
                  Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email,
                        color: Colors.grey,
                      ),
                      Text(email ?? "loading",
                        style:  const TextStyle(
                            color: Colors.grey
                        ),),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0,),
                 Row(
                   children: [
                     Center(
                      child:ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape:const StadiumBorder(),
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                        ),
                        autofocus: true,
                          clipBehavior: Clip.none,
                          child: const Text("Edit Profile"),
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateProfile()));
                        },
                      ),
                ),
                     SizedBox(width: 10,),
                     Center(
                       child:ElevatedButton(
                         style: ElevatedButton.styleFrom(
                             shape:const StadiumBorder(),
                             onPrimary: Colors.white,
                             padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                         ),
                         autofocus: true,
                         clipBehavior: Clip.none,
                         child: const Text("Reset Password"),
                         onPressed:(){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgetPassword()));
                         },
                       ),
                     ),
                   ],
                 ),

                 ListTile(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyProperties()));
                   },
                  shape: ContinuousRectangleBorder(
                      borderRadius: borderRadius,
                  side: const BorderSide(
                    color: Colors.black12
                  )
                  ),


                 trailing: const Icon(
                   Icons.arrow_forward_ios_sharp,
                   color: Colors.blue,
                 ),
                 // tileColor: Colors.red,
                  leading:const FaIcon(
                      FontAwesomeIcons.home,
                      size: 30.0,
                    color: Colors.blue,
                  ),
                  title: const Text("My Properties"),
                  subtitle: const Text("View All your listed properties"),

                ),
                const SizedBox(
                  height: 5.0,
                ),
                ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPropertyScreen()));
                  },
                  shape: ContinuousRectangleBorder(
                      borderRadius: borderRadius,
                      side: const BorderSide(
                          color: Colors.black12
                      )
                  ),

                  trailing: const Icon(
                      Icons.arrow_forward_ios_sharp,
                    color: Colors.blue,
                  ),
                  // tileColor: Colors.red,
                  leading:const FaIcon(
                    FontAwesomeIcons.upload,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  title: const Text("Add Property"),
                  subtitle: const Text("List Your Property for Sale/Rent"),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}