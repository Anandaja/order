// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/model/dormitory_model.dart';
import 'package:order_now_android/view/reseptionist/dormitory_book.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class DormitoryProvider extends ChangeNotifier {
  List<DormitoryDetails> dormitoryList = [];
  late bool availble;
  bool isLoading = true;
  //Firebase

  final CollectionReference dataRetriver =
      FirebaseFirestore.instance.collection('dormitory');

//old code
  // void DetailsLoader() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (dormitoryList.isEmpty) {
  //       await loadDormitorys();
  //       isLoading = false;
  //       //   isFetching = false;
  //     }
  //     notifyListeners();
  //   });
  // }
  void DetailsLoader() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        await loadDormitorys(); //1 flor

        // Set loading state to false
        isLoading = false;
        notifyListeners();
      } catch (e) {
        // Handle errors
        if (kDebugMode) {
          print('Error loading  details: $e');
        }
        // Set loading state to false in case of an error
        isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadDormitorys() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('dormitory').get();
      // print('check here${snapshot.docs.length}');
      final dormitoryDetails = snapshot.docs
          .map((doc) => DormitoryDetails.fromJson(doc.data()))
          .toList();
      //print('noobtest${userDetails[0]}');
      dormitoryList = dormitoryDetails
          .where((dormitory) => dormitory.floor == 'Ground Floor')
          .toList();
      // print('boomerang ${detailedList[0]}');

      // print('jobb ${userDetails.length}');
      dormitoryList.sort((a, b) => a.dormitoryno.compareTo(
          b.dormitoryno)); //filtering rooms on the ascending order of room no
      if (dormitoryList.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
        }

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  //creates the List
  Widget ListCreator(
      BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
    availble = mapofuserdetails['isAvailable'];
    //   print("is availble $availble");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Bounceable(
            onTap: () {
              //on tap to navigate to corresponding room details page
              if (kDebugMode) {
                print('room no ${mapofuserdetails['roomno']}');
              }
              if (kDebugMode) {
                print('roomtype ${mapofuserdetails['roomtype']}');
              }
              if (kDebugMode) {
                print('availability ${mapofuserdetails['isAvailable']}');
              }
              if (kDebugMode) {
                print('Floor ${mapofuserdetails['floor']}');
              }
              //on tap current room details/book page will load
              bool test = mapofuserdetails['isAvailable'];
              if (test == true) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => DormitoryBookPage(
                      currentDormitoryData: mapofuserdetails,
                    ),
                  ),
                );
              } else {
                // Room is not available, show a SnackBar

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dormitory is Already Booked'),
                    duration:
                        Duration(seconds: 3), // You can adjust the duration
                  ),
                );
                if (kDebugMode) {
                  print("availblity $test");
                }
                notifyListeners();
              }
              // RoomBookPage(currentRoomData: mapofuserdetails);
              // set print roomno print('tapped roomn');
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.27),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(9),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                      //    color: Color.fromRGBO(68, 142, 74, 1),
                    ),
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                      child: Stack(
                        children: [
                          // Placeholder Image
                          Center(
                            child: Image.asset('assets/images/img.png',
                                width: MediaQuery.of(context).size.width / 9.5,
                                height:
                                    MediaQuery.of(context).size.height / 9.5),
                          ),
                          // Actual Image with Fade Transition
                          Positioned.fill(
                            child: Image.network(
                              mapofuserdetails['image'],
                              fit: BoxFit.cover,
                              // loadingBuilder: (BuildContext context,
                              //     Widget child,
                              //     ImageChunkEvent? loadingProgress) {
                              //   if (loadingProgress == null) return child;
                              //   return Center(
                              //     child: CircularProgressIndicator(
                              //       color:
                              //           const Color.fromRGBO(253, 186, 63, 1),
                              //       value: loadingProgress.expectedTotalBytes !=
                              //               null
                              //           ? loadingProgress
                              //                   .cumulativeBytesLoaded /
                              //               loadingProgress.expectedTotalBytes!
                              //           : null,
                              //     ),
                              //   );
                              // },
                            ),
                            /*     CachedNetworkImage(
                        filterQuality: FilterQuality.medium,
                        fit: BoxFit.cover,
                        imageUrl: mapofuserdetails['image'],
                        placeholder: (context, url) => imageLoading(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),*/
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  //used expanded to align elements correctly
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mapofuserdetails['dormitoryno'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Per head Rate ${mapofuserdetails['perHeadRate']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: availble
                            ? const Color.fromRGBO(41, 105, 52, 1)
                            : const Color.fromRGBO(255, 0, 0, 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//shimmer shapes
  Widget buildShimmerFloorListView(
    int count,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 37,
        ),
        //floortitlr
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.only(left: 29),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 100,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8.5,
        ),
        //tiles
        ListView.builder(
          shrinkWrap: true, // Use shrinkWrap to avoid conflicts
          physics: NeverScrollableScrollPhysics(), // Disable scrolling
          // padding: const EdgeInsets.all(8),
          itemCount: count,

          itemBuilder: (BuildContext context, int index) {
            return const ShimmerWidget();
          },
        ),
        SizedBox(
          height: 25,
        )
      ],
    );
  }
}
