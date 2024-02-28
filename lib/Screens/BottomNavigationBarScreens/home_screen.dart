import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_your_home/Widgets/property_shimmer_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_your_home/Screens/Owner%20Screens/add_property_screen.dart';
import 'package:get_your_home/Screens/Viewer%20Screens/property_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User? user=FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //get the instance of the available device height and width
    double deviceHeight=MediaQuery.of(context).size.height;
    double deviceWidth=MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text(
          "Get Your Home",
          //style: TextStyle(color: Colors.black),
        ),
        actions:  [
          IconButton(
            iconSize: 34.0,
            onPressed:(){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const AddPropertyScreen()));
            } ,
            icon:const Icon(
              Icons.upload,
              color: Colors.white,
              semanticLabel: "Add Property",
            ),
            color: Colors.white,
            hoverColor: Colors.black54,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child:StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("properties")
              .where('email',isNotEqualTo:user?.email)
              //.orderBy('date',descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
               // final docs = snapshot.data?.docs;
              return ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                final snap = snapshot.data?.docs[index];
                //String title=snap?.get('title');
                return InkWell(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        PropertyDetails(propertyId:snap!.id,
                            isOwner: snap.get('email').toString()==user?.email.toString()? true:false)));
                   // Fluttertoast.showToast(msg: snap!.id);
                  } ,
                  child://main container for the card
                  Container(
                    //Size of the Card

                    //it will have full device width 100%
                      width: deviceWidth * 1,
                      //it will have 25% of the device height for each card
                      height: deviceHeight * 0.25,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        //border style
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //First Element of the Row as Property Image

                          //container that will show image of the property
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              //Size for the property image
                              //40% of the device width
                              width: deviceWidth * 0.4,
                              //25% of the device height
                              height: deviceHeight * 0.25,
                              //cached network image for loading and error showing
                              child: CachedNetworkImage(
                                imageUrl: snap?.get('propertyPicUrl'),
                                progressIndicatorBuilder: (context, profilePicUrl, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                repeat: ImageRepeat.noRepeat,
                                fit: BoxFit.cover,
                              )
                          ),

                          //Second Element of the row will contain all other details
                          //Padding to all the details that
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            //The Box That will Contain all the details
                            child: SizedBox(
                              //56% of the available device width
                              width: deviceWidth * 0.56,
                              height: deviceHeight*0.25,
                              //Column
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //First Element of the column
                                  //amount
                                  SizedBox(
                                    //height:deviceHeight*0.05,
                                    child: AutoSizeText(
                                      "\u{20B9} ${snap?.get('amount')}",
                                      minFontSize: 12,
                                      maxFontSize: 20,
                                      maxLines: 1,
                                      //overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  //2nd element of the column
                                  //title
                                  SizedBox(
                                   //height: deviceHeight*0.05,
                                    child: AutoSizeText(
                                      snap?.get('title'),
                                      minFontSize: 16,
                                      maxFontSize: 20,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),

                                  //3rd element will be row of rooms and built area
                                  //rooms and built area
                                  SizedBox(
                                    height: deviceHeight*0.03,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        //first element in the row
                                        //rooms
                                        AutoSizeText(snap?.get('rooms')),
                                        //second element in the row
                                        //Built Area
                                        AutoSizeText(snap?.get('builtArea')+"Sq.Ft.")
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),

                                  //4th element of the Column will be row of Station and List type
                                  //station and listing type
                                  SizedBox(
                                    height: deviceHeight*0.03,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        //1st element of the row
                                        //Station
                                        AutoSizeText(snap?.get('nearStation')),
                                        //2nd element of the row
                                        //Listing Type
                                        AutoSizeText(
                                            "For-"+snap?.get('listingType'),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),

                                  //5th element of the Column will be row of Listing Date
                                  SizedBox(
                                    height: deviceHeight*0.03,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        //First the text
                                        const AutoSizeText("Listed on - "),
                                        //then the fetched value
                                        AutoSizeText(snap?.get('date')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  );
                });
            }
              else
                {
              return  //PropertyCardShimmer().propertyCard(context);
              ListView.separated(
                  shrinkWrap: true,
                itemBuilder: (context, index) => PropertyCardShimmer().propertyCard(context),
                separatorBuilder: (context,index)=>const SizedBox(height: 1.0,),
                itemCount: 6
            );


          //
            }
        }
        ),
        ),
      )
    );
  }



}
