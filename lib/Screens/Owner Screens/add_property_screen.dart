import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_your_home/services/firestore_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {

  //current logged in users instance
  User? user=FirebaseAuth.instance.currentUser;
  //submit clicked or not.. to show progress indicator
  bool _isUploading=false;
  //form key to access and validate the form
  final _propertyUploadFormKey = GlobalKey<FormState>();


  //text controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _nearByStationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _builtAreaController = TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _localAreaController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  //common validator for text form fields input
  validateFunction(String value){
    if(value.isEmpty){
      return 'Please Enter Valid Input';
    }
    return null;
  }


  //current date
  String date =  DateFormat('dd-MMMM-yyyy').format(DateTime.now());


  //variables to store data from the text input fields
  String? title,type,builtArea,carpetArea,amount,address,pinCode,station,landmark,localArea,description;

  //default listing type || variable that hold the selected value
  String listingTypeValue = 'Sale';
  //options for dropdown
  List<String> propertyListingType = ['Sale', 'Rent','PG'];

  //default room type || variable that hold the selected value
  String roomTypeValue="1 RK";
  //options for dropdown
  List<String> roomTypeList=['1 RK',"1 BHK","2 BHK","3 BHK","4 BHK","Others"];


  //instance of image picker
  final ImagePicker _picker = ImagePicker();
  //file variable that will store the selected image
  File? file;
  //variable that will store the download url after image upload
  String? imgDownloadUrl;
  //String? profilePicUrl;

  //method to pick image
  pickImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    //check image selected or not
    if(pickedFile?.path==null){
      //if not selected then show toast
      Fluttertoast.showToast(msg: "Please select image once again..");
    }else{
      //if image selected then store the selected image in the file variable
      setState(() {
        file = File(pickedFile!.path);
      });

    }

  }

  //method to upload the selected image
  uploadPropertyPic() async{
    try{
      Fluttertoast.showToast(msg: "Image Uploading Please Wait..");
      //get the path where to store image
      var imageFile=FirebaseStorage.instance.ref().child("properties").child(user!.email.toString()).child(file!.path);
      //create task to upload
      UploadTask task=imageFile.putFile(file!);
      //execute the task
      TaskSnapshot snapshot=await task;
      //get the download url of the uploaded image
      await snapshot.ref.getDownloadURL().
      whenComplete(() => Fluttertoast.showToast(msg: "Image Uploaded")).
      then((value) => uploading(value)).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));
    }on FirebaseException catch (e){
      Fluttertoast.showToast(msg: e.message.toString(),textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("List Your Property"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xffFFFFFF),
            child: Form(
              key: _propertyUploadFormKey,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                             Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                 Text(
                                  "Property Details",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                     Padding(
                        padding:const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                      child: Stack(
                          children: [
                            Material(
                              //color: Colors.green,
                              child:file==null?
                                  Image.asset(
                                      'assets/imageSelectPlaceHolder.jpg',
                                    height: MediaQuery.of(context).size.height*0.25,
                                    width: MediaQuery.of(context).size.width*0.45,
                                  )

                                  :Image(
                                  image: FileImage(file!),
                                height: MediaQuery.of(context).size.height*0.25,
                                width: MediaQuery.of(context).size.width*0.45,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 3,
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
                                          Icons.add_photo_alternate,
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
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child:  Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                             Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Title*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child:  Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                             Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _titleController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  hintText: "Enter Full title",
                                ),
                                enabled: true,
                                //autofocus: !_status,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Type*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _typeController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: const InputDecoration(
                                    hintText: "Ex shops, room, flat, plot etc."),
                                enabled: true,
                              ),
                            ),
                          ],
                        )),


                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'Super BuiltUp Area*',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Text(
                                'Carpet Area*',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,

                                  controller: _builtAreaController,
                                  validator: (value)=>validateFunction(value.toString()),

                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: "Square ft."),
                                  enabled: true,
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _carpetAreaController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Square ft."),
                                enabled: true,
                              ),
                              flex: 2,
                            ),
                          ],
                        )),

                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'Listing for*',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Text(
                              'Rooms*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget> [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 90.0),
                                child: listingTypeDropDown()
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: roomTypeDropDown(),
                              flex: 2,
                            ),

                          ],
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Amount*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _amountController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Enter amount on which u wanna sell/rent"),
                                enabled: true,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Address*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _fullAddressController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: const InputDecoration(
                                    hintText: "Enter full address of your property"),
                                enabled: true,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                'Pin Code*',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Text(
                                'NearBy Station*',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,

                                  controller: _pinCodeController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Please Enter Valid Input';
                                    }else if(value.length!=6){
                                      return 'Please Enter Valid Pin Code';
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Pin Code"),
                                  enabled: true,
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _nearByStationController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: const InputDecoration(
                                    hintText: "Enter Station"),
                                enabled: true,
                              ),
                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                  'Landmark*',
                                  style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),

                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child:Text(
                                  'Local Area*',
                                  style:  TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),

                              flex: 2,
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,

                                  controller: _landmarkController,
                                  validator: (value)=>validateFunction(value.toString()),

                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                                  decoration: const InputDecoration(
                                      hintText: "Enter landmark"),
                                  enabled: true,
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.next,

                                controller: _localAreaController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: const InputDecoration(
                                    hintText: "Enter local area"),
                                enabled: true,
                              ),
                              flex: 2,
                            ),
                          ],
                        )),

                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Text(
                                  'Description*',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                textInputAction: TextInputAction.done,

                                controller: _descriptionController,
                                validator: (value)=>validateFunction(value.toString()),

                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                decoration: const InputDecoration(
                                    hintText: "Other information of your property"),
                                enabled: true,
                              ),
                            ),
                          ],
                        )),
                    _getActionButtons()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


Widget listingTypeDropDown(){
    return DropdownButton(
      // Initial Value
      value: listingTypeValue,
      iconSize: 24.0,
      elevation: 16,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: propertyListingType.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          listingTypeValue = newValue!;
        });
      },
    );
}

Widget roomTypeDropDown(){
    return DropdownButton(
      // Initial Value
      value: roomTypeValue,
      iconSize: 24.0,
      elevation: 16,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: roomTypeList.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          roomTypeValue = newValue!;
        });
      },
    );
}


  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child:
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape:const StadiumBorder(),
                      onPrimary: Colors.white,
                      primary: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                  ),
                  child:  _isUploading==true?const CircularProgressIndicator(color: Colors.white,):const Text("Submit"),
                  onPressed: () async {
                    if(file!=null){
                      if(_propertyUploadFormKey.currentState!.validate()){
                        setState(() {
                          _isUploading=true;
                        });
                        uploadPropertyPic();
                      }
                    }else{
                      Fluttertoast.showToast(msg: "Please pic the image");
                    }

                    }),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape:const StadiumBorder(),
                    onPrimary: Colors.white,
                    primary: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                ),
                child: const Text("Cancel"),
                onPressed: () {
                  setState(() {
                    //_status = true;
                    Navigator.pop(context);
                    //FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },

              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  uploading(String value){



    Fluttertoast.showToast(msg: "Data Uploading....");
    title = _titleController.text.trim().toString();
    type = _typeController.text.trim().toString();
    builtArea = _builtAreaController.text.trim().toString();
    carpetArea = _carpetAreaController.text.trim().toString();
    listingTypeValue;
    roomTypeValue;
    amount = _amountController.text.trim().toString();
    address = _fullAddressController.text.trim().toString();
    pinCode = _pinCodeController.text.trim().toString();
    station = _nearByStationController.text.trim().toString();
    landmark = _landmarkController.text.trim().toString();
    localArea = _localAreaController.text.trim().toString();
    description = _descriptionController.text.trim().toString();

    FirestoreDatabase().uploadProperty(user!.uid.toString(),
        user!.email.toString(), title!, type!, builtArea!, carpetArea!,
        listingTypeValue, roomTypeValue, amount!, address!, pinCode!, station!, landmark!, localArea!, description!,value,date.toString())
        .whenComplete(() => Navigator.pop(context));

    setState(() {
      _isUploading=false;
    });
  }


}
