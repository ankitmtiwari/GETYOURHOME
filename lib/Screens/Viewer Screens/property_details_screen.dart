import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_your_home/Screens/Viewer%20Screens/selected_users_all_properties.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


 class PropertyDetails extends StatefulWidget {
   final String propertyId;
   final bool isOwner;
   const PropertyDetails({Key? key, required  this.propertyId, required this.isOwner}) : super(key: key);

 
   @override
   _PropertyDetailsState createState() => _PropertyDetailsState();
 }
 
 class _PropertyDetailsState extends State<PropertyDetails> {


   //Property ID
   String? id;

   bool? _isOwner;

   //Property details variables
   String? propertyPicUrl, title, type, builtArea, carpetArea, listingType,
       roomsNo,
       amount, address, pinCode, station, landmark, localArea, description;

   //Owner Details variables
   String? ownerPhone, ownerFirstName, ownerLastName, ownerEmail,ownerProfilePic;
   String? date;

   //Details heading style
  TextStyle headTextStyle =  const TextStyle(
       fontWeight: FontWeight.w500
  );


   @override
   void initState() {
     // TODO: implement initState
     super.initState();

     //on page load first get the property id from previous screen and get bool for the owner is the viewer or not
     setState(() {
       id = widget.propertyId;
       _isOwner=widget.isOwner;

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

       //assign the fetched values to the variables declared
       setState(() {
         title = fetchProfile['title'];
         type = fetchProfile['type'];
         builtArea = fetchProfile['builtArea'];
         carpetArea = fetchProfile['carpetArea'];
         listingType = fetchProfile['listingType'];
         roomsNo = fetchProfile['rooms'];
         amount = fetchProfile['amount'];
         address = fetchProfile['address'];
         pinCode = fetchProfile['pinCode'];
         station = fetchProfile['nearStation'];
         landmark = fetchProfile['landmark'];
         localArea = fetchProfile['localArea'];
         description = fetchProfile['description'];
         propertyPicUrl = fetchProfile['propertyPicUrl'];
         date=fetchProfile['date'];

         //owners email
         ownerEmail = fetchProfile['email'];
         //after getting owners email get owners profile details
         getOwnersDetail(ownerEmail!);
       });
     }
   }

   //function to fetch the owners propfile details from firestore
   Future getOwnersDetail(String email) async {
     DocumentSnapshot ds = await FirebaseFirestore.instance.collection("users")
         .doc(email)
         .get();
     if (ds.exists) {
       Map<String, dynamic>? fetchProfile = ds.data() as Map<String, dynamic>;

       //assign the fetched values to the variables declared
       setState(() {
         ownerFirstName = fetchProfile['First Name'];
         ownerLastName = fetchProfile['Last Name'];
         ownerPhone = fetchProfile['Phone Number'];
         ownerProfilePic=fetchProfile['Profile Pic'];
       });
     }
   }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(

          // backgroundColor: Colors.transparent,
          // foregroundColor: Colors.blue,
           elevation: 0.0,
           title: const Text(
               "Details",
             style: TextStyle(
               //color: Colors.blue
             ),
           ),
           actions: [

             //check if the viewer is the owner of property
             !_isOwner!?
                 //if not then give the option to contact the owner
             Row(
               children: [
                 IconButton(
                   tooltip: "Call The Owner",
                     onPressed: ()async{
                       await FlutterPhoneDirectCaller.callNumber(ownerPhone!);
                     },
                     icon:const Icon(
                         Icons.call,
                      // color: Colors.blue,
                       size: 30.0,
                     )),
                 IconButton(
                   tooltip: "Chat with Owner",
                   onPressed: ()async{
                     var url="https://wa.me/+91$ownerPhone?text=Hello $ownerFirstName, I cam across your "
                         "property which you have listed on *Get Your Home* App with title as *$title* "
                         "located in *$station* available for *$listingType* in *$localArea* for *\u{20B9}$amount*  ";
                     await launch(url);
                   },
                   icon: const FaIcon(
                     FontAwesomeIcons.whatsapp,
                     //color: Colors.green,
                     size: 30.0,
                   ),
                 ),
               ],
             )

             //if the owner and viewer of the property are the same give the delete property option
             :IconButton(
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

             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: propertyPicUrl!=null?propertyPicUrl!:'https://i1.sndcdn.com/artworks-000175930618-pg6ffe-t500x500.jpg',
                      progressIndicatorBuilder: (context, profilePicUrl, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      repeat: ImageRepeat.noRepeat,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                 const SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(

                     decoration: const BoxDecoration(
                       border: Border.symmetric(
                         horizontal: BorderSide(color: Colors.black12)
                       )
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           amount!=null?"\u{20B9} "+amount!:"Loading..",
                           style: const TextStyle(
                               fontSize: 24.0,
                               fontWeight: FontWeight.bold
                           ),
                         ),
                         const SizedBox(height: 10,),
                         AutoSizeText(
                           title!=null?title!:"loading...",
                           maxLines: 3,
                           minFontSize: 16,
                           maxFontSize: 20,
                         ),
                         const SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 const Icon(
                                     Icons.location_on_rounded ,
                                   color: Colors.blue,
                                 ),
                                 Text(
                                   station!=null?station!:"Loading..",
                                   style: const TextStyle(
                                     fontSize: 17.0,
                                   ),
                                 ),
                               ],
                             ),
                             Text(date!=null?date!:"Loading..",style: const TextStyle(
                               fontSize: 17.0,
                             ),),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),

                 const SizedBox(height: 10,),
                 const Padding(
                   padding: EdgeInsets.all(8.0),
                   child:  Text(
                       "Details :",
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.w400,
                     ),
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Type :",style: headTextStyle,),
                     ),
                     Text(type!=null?type!:"loading..")
                   ],
                 ),const SizedBox(height: 10,),
                 Row(
                   children: [
                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rooms :",style: headTextStyle,),
                      ),
                     Text(roomsNo!=null?roomsNo!:"loading..")
                   ],
                 ),const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Super BuiltUp Area :",style: headTextStyle,),
                     ),
                     Text(builtArea!=null?builtArea!+"Square Ft.":"loading..")
                   ],
                 ),const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Carpet Area :",style: headTextStyle,),
                     ),
                     Text(carpetArea!=null?carpetArea!+"Square Ft.":"loading..")
                   ],
                 ),const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Available For :",style: headTextStyle,),
                     ),
                     Text(listingType!=null?listingType!:"loading..")
                   ],
                 ),const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Nearby Station :",style: headTextStyle,),
                     ),
                     Text(station!=null?station!:"loading..")
                   ],
                 ),
                 const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Local Area :",style: headTextStyle,),
                     ),
                     Text(localArea!=null?localArea!:"loading..")
                   ],
                 ),const SizedBox(height: 10,),Row(
                   children: [
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text("Landmark :",style: headTextStyle,),
                     ),
                     Text(landmark!=null?landmark!:"loading..")
                   ],
                 ),
                 const Divider(
                   color: Colors.black12,
                   thickness: 1.0,
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text("Address: ",
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.w400,
                         ),),
                       AutoSizeText(
                           address!=null?address!:"Loading..",
                         minFontSize: 16,
                           maxFontSize: 24,
                       ),
                     ],
                   ),
                 ),
                  const Divider(
                    color: Colors.black12,
                    thickness: 1.0,
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description: ",
                          style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),),
                        AutoSizeText(
                          description!=null?description!:"Loading..",
                          minFontSize: 16,
                            maxFontSize: 24,

                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 5.0,),
                 const Divider(
                   color: Colors.black12,
                   thickness: 1.0,
                 ),

                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                       SelectedUsersAllProperties(
                        email: ownerEmail!,
                        phone: ownerPhone!,
                        profilePicUrl: ownerProfilePic!,
                        fName: ownerFirstName!,
                        lName: ownerLastName!,
                      ) ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        // decoration:  BoxDecoration(
                        //     borderRadius: const BorderRadius.all(Radius.circular(5.0)) ,
                        //     border:  Border.all(color: Colors.black)
                        //   // border: Border.symmetric(
                        //   //     horizontal: BorderSide(color: Colors.black)
                        //   // )
                        // ),
                       child: Row(
                         children: [
                           ClipOval(
                             child:
                             CachedNetworkImage(
                               imageUrl: ownerProfilePic!=null?ownerProfilePic!:'https://i1.sndcdn.com/artworks-000175930618-pg6ffe-t500x500.jpg',
                               progressIndicatorBuilder: (context, profilePicUrl, downloadProgress) =>
                                   CircularProgressIndicator(value: downloadProgress.progress),
                               errorWidget: (context, url, error) => const Icon(Icons.error),
                                 fit: BoxFit.fill,
                                 height: MediaQuery.of(context).size.height*0.15,
                                 width: MediaQuery.of(context).size.width*0.3
                       ),


                           ),
                           Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(ownerFirstName!=null?ownerFirstName! :"Loading..",
                                     style: const TextStyle(
                                       fontSize: 20.0,

                                     ),
                                     ),
                                   ),
                                   Text(ownerLastName!=null?ownerLastName!:"Loading..",
                                     style: const TextStyle(
                                       fontSize: 20.0,
                                     ),)
                                 ],
                               ),

                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(ownerPhone!=null?ownerPhone!:"Loading.."),
                               ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(ownerEmail!=null?ownerEmail!:"Loading.."),
                               ),
                              // Text(ownerProfilePic!=null?ownerProfilePic!:"loading..")
                             ],
                           )
                         ],
                       ),
                 ),
                    ),
                  ),
                 const Divider(
                   color: Colors.black12,
                   thickness: 1.0,
                 ),
               ],
             ),
           ),
         ),
       );
     }
   }
