
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';



class PropertyCardShimmer{
  Widget propertyCard(BuildContext context){
    Color cardColor= Colors.black.withOpacity(0.08);
    return  Shimmer.fromColors(
      baseColor: Colors.red,
      highlightColor: Colors.white,
      child: Container(
          margin: const EdgeInsets.all(4.0),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: cardColor,
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.56,
                  //color: Colors.blueAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: cardColor,
                            height: MediaQuery.of(context).size.height*0.02,
                            width: MediaQuery.of(context).size.width*0.4,
                          ),
                          SizedBox(

                              child: Container(
                                color: Colors.black.withOpacity(0.04),
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.width*0.06,
                              )
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.width*0.4,
                        color: cardColor,
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Container(
                            height: MediaQuery.of(context).size.height*0.02,
                            width: MediaQuery.of(context).size.width*0.2,
                            color: cardColor,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.02,
                            width: MediaQuery.of(context).size.width*0.1,
                            color: cardColor,
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Container(
                            height: MediaQuery.of(context).size.height*0.02,
                            width: MediaQuery.of(context).size.width*0.2,
                            color: cardColor,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.02,
                            width: MediaQuery.of(context).size.width*0.1,
                            color:cardColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.width*0.1,
                        color:cardColor,
                      ),
                      const SizedBox(height: 10.0,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.02,
                        width: MediaQuery.of(context).size.width*0.1,
                        color:cardColor,
                      ),

                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
