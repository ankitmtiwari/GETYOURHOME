
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../services/firestore_services.dart';


class UpdateProperty extends StatefulWidget {

  //Selected property id from previous screen
  final String propertyId;
  const UpdateProperty({Key? key,required this.propertyId}) : super(key: key);

  @override
  _UpdatePropertyState createState() => _UpdatePropertyState();
}

class _UpdatePropertyState extends State<UpdateProperty> {


  //Property ID
  String? id;


  //Property details variables
  String? propertyPicUrl, title, type, builtArea, carpetArea, listingType,
      roomsNo,
      amount, address, pinCode, station, landmark, localArea, description;


  //current user
  User? user=FirebaseAuth.instance.currentUser;

  //uploading bool value for showing progress bar while uploading
  bool _isUploading=false;

  //form key to validate
  final _uploadFormKey = GlobalKey<FormState>();

  //choose to edit or not & default value will be false
  bool _editable=false;


  //all the text controllers
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


  //common validator for textform feilds input
  validateFunction(String value){
    if(value.isEmpty){
      return 'Please Enter Valid Input';
    }
    return null;
  }







  //on screen loaded
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //on page load first get the property id from previous screen and get bool for the owner is the viewer or not
    setState(() {
      id = widget.propertyId;

    });
    //fetch all the property details with the help of property id
    getPropertyDetails(id!);
  }


  //function to get property details from firestore
  Future getPropertyDetails(String id) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection(
        "properties").doc(id).get();
    if (ds.exists) {
      Map<String, dynamic>? fetchProfile = ds.data() as Map<String, dynamic>;

      //assign the fetched values to the text input fields
      setState(() {
        _titleController.text = fetchProfile['title'];
        _typeController.text = fetchProfile['type'];
        _builtAreaController.text = fetchProfile['builtArea'];
        _carpetAreaController.text = fetchProfile['carpetArea'];
        listingTypeValue = fetchProfile['listingType'];
        roomTypeValue = fetchProfile['rooms'];
        _amountController.text = fetchProfile['amount'];
        _fullAddressController.text = fetchProfile['address'];
        _pinCodeController.text = fetchProfile['pinCode'];
        _nearByStationController.text = fetchProfile['nearStation'];
        _landmarkController.text = fetchProfile['landmark'];
        _localAreaController.text = fetchProfile['localArea'];
        _descriptionController.text = fetchProfile['description'];
        propertyPicUrl = fetchProfile['propertyPicUrl'];
        date=fetchProfile['date'];
      });
    }
  }


  //current date
  String date =  DateFormat('dd-MMMM-yyyy').format(DateTime.now());

  //default value of the listing type dropdown list
  String listingTypeValue = 'Sale';

  //list of options in the dropdown
  List<String> propertyListingType = ['Sale', 'Rent','PG'];

  //default value of the dropdown
  String roomTypeValue="1 RK";

  //list of options in dropdown
  List<String> roomTypeList=['1 RK',"1 BHK","2 BHK","3 BHK","4 BHK","Others"];


  //image picker declare
  final ImagePicker _picker = ImagePicker();

  //file that will store selected image
  File? file;

  String? imgDownloadUrl;


  //function to pick image from gallery
  pickImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    //check if image selected or not with the image path
    if(pickedFile?.path==null){
      Fluttertoast.showToast(msg: "Please select image once again..");
    }else{
      //if image is selected successfully
      setState(() {
        //store selected image in the file variable
        file = File(pickedFile!.path);
      });
    }

  }

  //function to upload the selected file to firebase storage
  uploadPropertyPic() async{
    try{
      Fluttertoast.showToast(msg: "Image Uploading Please Wait..");
      var imageFile=FirebaseStorage.instance.ref().child("properties").child(user!.email.toString()).child(file!.path);
      UploadTask task=imageFile.putFile(file!);
      TaskSnapshot snapshot=await task;
      await snapshot.ref.getDownloadURL().whenComplete(() => Fluttertoast.showToast(msg: "Image Uploaded")).then((value) => uploading(value)).onError((error, stackTrace) => Fluttertoast.showToast(msg: error.toString()));

    }on FirebaseException catch (e){
      Fluttertoast.showToast(msg: e.message.toString(),textColor: Colors.red);
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Edit Property"),
        actions: [
          IconButton(
              tooltip: "Delete",
              onPressed: (){
                final delete=FirebaseFirestore.instance.collection("properties").doc(id);
                delete.delete().then((value) => Fluttertoast.showToast(msg: "Deleted Successfully"))
                    .whenComplete(() => Navigator.pop(context));

              },
              icon: const Icon(
                Icons.delete,
                //  color: Colors.blue,
                size: 30.0,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xffFFFFFF),
            child: Form(
              key: _uploadFormKey,
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
                                  "Property Information",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Center(
                      child: Padding(
                        padding:const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child: Stack(
                            children: [
                              Material(
                                //color: Colors.green,
                                child:file==null?
                                CachedNetworkImage(
                                  imageUrl: propertyPicUrl.toString(),
                                  progressIndicatorBuilder: (context, profilePicUrl, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  height: MediaQuery.of(context).size.height*0.30,
                                  width: MediaQuery.of(context).size.width*0.50,
                                ):Image(
                                  image: FileImage(file!),
                                  height: MediaQuery.of(context).size.height*0.30,
                                  width: MediaQuery.of(context).size.width*0.50,
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
                    ),

                    Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 25.0),
                        child:  Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                            _editable?
                            IconButton(
                                onPressed: (){
                                  setState(() {
                                    _editable=!_editable;
                                  });
                                },
                                tooltip: "Back",
                                color: Colors.blue,
                                icon: const Icon(
                                    Icons.arrow_back_outlined
                                )
                            ):
                            IconButton(
                                onPressed: (){
                                  setState(() {
                                    _editable=!_editable;
                                  });

                                },
                                tooltip: "Click To Edit",
                                color: Colors.blue,
                                icon: const Icon(
                                    Icons.edit
                                )
                            )
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
                                enabled: _editable,
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
                                enabled:  _editable,
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
                                  enabled:  _editable,
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
                                enabled:  _editable,
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
                                enabled:  _editable,
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
                                enabled:  _editable,
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
                                  enabled:  _editable,
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
                                enabled:  _editable,
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
                                  enabled:  _editable,
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
                                enabled:  _editable,
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
                                enabled:  _editable,
                              ),
                            ),
                          ],
                        )),
                    _editable?
                    _getActionButtons():
                    Center(
                      child: ElevatedButton(
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
    return IgnorePointer(
      ignoring: !_editable,
      child: DropdownButton(
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
      ),
    );
  }

  Widget roomTypeDropDown(){
    return IgnorePointer(
      ignoring: !_editable,
      child: DropdownButton(
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
      ),
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
              IgnorePointer(
                ignoring: !_editable,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape:const StadiumBorder(),
                        onPrimary: Colors.white,
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0,vertical: 12.0)
                    ),
                    child:  _isUploading==true?const CircularProgressIndicator(color: Colors.white,):const Text("Submit"),
                    onPressed: () async {

                      //Fluttertoast.showToast(msg: _titleController.text);

                      if(file!=null){
                        if(_uploadFormKey.currentState!.validate()){
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
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child:  IgnorePointer(
                ignoring: !_editable,
                child: ElevatedButton(
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

   // Fluttertoast.showToast(msg: title.toString());

    FirestoreDatabase().updateProperty(
      id!,
        user!.uid.toString(),
        user!.email.toString(), title!, type!, builtArea!, carpetArea!,
        listingTypeValue, roomTypeValue, amount!, address!, pinCode!, station!, landmark!, localArea!, description!,value,date.toString())
        .whenComplete(() => Navigator.pop(context));

    setState(() {
      _isUploading=false;
    });
  }


}

