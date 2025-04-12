// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/model/homestay_model.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';

class HomestayListReservationProvider extends ChangeNotifier {
  late AnimationController addToCartPopUpAnimationController;
  List<HomestayDetails> HomestayList = [];
  late bool availble;
  bool isLoading = true;
  //Firebase

  final CollectionReference homestaycollection =
      FirebaseFirestore.instance.collection('homestay');

  void DetailsLoader(DateTime currentDate) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        await loadHomestays(); //1 flor
        await getReservedDocs(currentDate: currentDate);

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

  Future<void> loadHomestays() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('homestay').get();
      // print('check here${snapshot.docs.length}');
      final homestayDetails = snapshot.docs
          .map((doc) => HomestayDetails.fromJson(doc.data()))
          .toList();
      //print('noobtest${userDetails[0]}');
      HomestayList = homestayDetails;

      if (HomestayList.isEmpty) {
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

  //fetching the current date  doc , its a test to display the reserevd tex on the tile

  List RoomNoList = [];

  void addingtolist(String roomno) {
    if (RoomNoList.contains(roomno)) {
      print("i will not add this $roomno because it already  in there");
    } else {
      RoomNoList.add(roomno);
      notifyListeners();
    }
  }

  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservation');

  Future<void> getReservedDocs({required DateTime currentDate}) async {
    try {
      //set  if currentdate is not in the database it means no need to check this.
      notifyListeners();
      RoomNoList.clear();
      // final snapshot = dataRetriver.get(); is it works??
      var docid;
      await reservationCollection
          .where('catogary', isEqualTo: 'homestay')
          .where('date', isEqualTo: currentDate)
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          print(element.id);
          docid = element.id;
          print("doc id $docid");
          // notifyListeners();

          final snapshot = await reservationCollection.doc(docid).get();
          //  print(" DATE ${snapshot['reserveList']}");

          List TestReservation = snapshot['reserveList'];
          print("Test Reservation List $TestReservation");
          // print('check here${snapshot.docs.length}');
          // final roomDetails = snapshot.docs
          //     .map((doc) => RoomDetails.fromJson(doc.data()))
          //     .toList();
          for (int index = 0; index < TestReservation.length; index++) {
            String Homestayno = TestReservation[index]['roomnoORname'];

            print("Hi from reservation doc $Homestayno");
            //here i is the index
            // for (dynamic room in TestReservation) {
            //   String roomno = room['roomno'];
            //   print
            // }
            // RoomNoList.add(roomno);
            addingtolist(Homestayno);
          }
          print("Room no list $RoomNoList");
          notifyListeners();
        });
      });

      //    print("Am the doc id $docid");

      // final roomDetails =
      //     snapshot.docs.map((doc) => RoomDetails.fromJson(doc.data())).toList();
      // Map tableData = snapshot.docs as Map<dynamic, dynamic>;
      // print("testt ${tableData['date']}");

      // print('boomerang ${detailedList[0]}');

      // print('jobb ${userDetails.length}');

      // if (Floor3List.isEmpty) {
      //   if (kDebugMode) {
      //     print('List is empty');
      //   }
      //   const Text('data');
      //   notifyListeners();
      // }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  //Reserving room,
  //the user can add the rooms to reserve this list is that (Below)

  List ReserveHomestayList = [];

  void AddingHomestayToList(Map<String, dynamic> mapofuserdetails) {
    //
    Map<String, dynamic> HomesDetails = {};

    // String roomnoORname = mapofuserdetails['roomno'];
    // String roomtype = mapofuserdetails['roomtype'];
    // String image = mapofuserdetails['image'];
    // String rate = mapofuserdetails['rate'];
    // String floor = mapofuserdetails['floor'];
    // bool isAvailable = mapofuserdetails['isAvailable'];
    HomesDetails.addAll({
      'roomnoORname': mapofuserdetails['name'],
      'image': mapofuserdetails['image'],
      'rate': mapofuserdetails['rate'],
      'floor': mapofuserdetails['floor'],
      'isAvailable': mapofuserdetails['isAvailable']
    });
    print("Dormi Datas map $HomesDetails");

    ReserveHomestayList.add(HomesDetails);
    notifyListeners();
    print("Resereve room list $ReserveHomestayList");
  }

  int? testIndex;

  //int indexfind()
  //return bool if there is any addition on CartList(That made First time)
  bool checkIfAddedToReservation(Map<String, dynamic> mapofuserdetails) {
    // Replace this with your logic to check if the food item is in the cart
    // You might need to compare the 'fooddetails' with items in 'OrderCartList'
    // and return true if it's already present.
    // Example assuming 'OrderCartList' is a List<Map<String, dynamic>>:

    for (dynamic item in ReserveHomestayList) {
      if (item['roomnoORname'] == mapofuserdetails['name']) {
        return true;
      }
    }

    return false;
  }

  bool isAddedToReserveRoom =
      false; //to check the room is already added to the list or not

//creates the List
  Widget ListCreator(
      BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
    availble = mapofuserdetails['isAvailable'];
    //   print("is availble $availble");
    // print("INDEXX $index");
    isAddedToReserveRoom = checkIfAddedToReservation(mapofuserdetails);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Bounceable(
            onTap: () {
              //on tap to navigate to corresponding room details page
              // if (kDebugMode) {
              //   print('room no ${mapofuserdetails['roomno']}');
              // }
              // if (kDebugMode) {
              //   print('roomtype ${mapofuserdetails['roomtype']}');
              // }
              // if (kDebugMode) {
              //   print('availability ${mapofuserdetails['isAvailable']}');
              // }
              // if (kDebugMode) {
              //   print('Floor ${mapofuserdetails['floor']}');
              // }
              // //on tap current room details/book page will load
              // bool test = mapofuserdetails['isAvailable'];
              // if (test == true) {
              //   // Room is available, navigate to the booking page
              //   if (kDebugMode) {
              //     print("availblity $test");
              //   }
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) =>
              //         RoomBookPage(currentRoomData: mapofuserdetails),
              //   ),
              // );
              // } else {
              //   // Room is not available, show a SnackBar

              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text('Room is Already Booked'),
              //       duration:
              //           Duration(seconds: 3), // You can adjust the duration
              //     ),
              //   );
              //   if (kDebugMode) {
              //     print("availblity $test");
              //   }
              //   notifyListeners();
              // }
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
                            ),
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
                          mapofuserdetails['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Rate ${mapofuserdetails['rate']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RoomNoList.contains(mapofuserdetails['name'])
                      ? Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Bounceable(
                            onTap: () {
                              //
                            },
                            child: Container(
                              height: 28,
                              width: 28,
                              child: Icon(
                                Icons.done_all_sharp,
                                color: Color.fromARGB(255, 245, 0, 0),
                              ),
                            ),
                          ),
                        )
                      // Text(
                      //     'Reserved',
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w700, color: Colors.red),
                      //   )
                      : isAddedToReserveRoom
                          ? mapofuserdetails[index] == testIndex
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Bounceable(
                                    onTap: () {
                                      //
                                    },
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      child: Icon(
                                        Icons.done,
                                        color: const Color.fromRGBO(
                                            41, 105, 52, 1),
                                      ),
                                    ),
                                  ),
                                )
                          // Text('Added'),
                          : Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Bounceable(
                                onTap: () {
                                  print("Index $index");
                                  //adding it to the List
                                  testIndex = index;
                                  AddingHomestayToList(mapofuserdetails);
                                  addToCartPopUpAnimationController
                                      .forward(); //playing animation
                                  // ReserveDormitoryList.add(mapofuserdetails);
                                  notifyListeners();
                                  print(
                                      "Length of the list ${ReserveHomestayList.length}");
                                  // print(ReserveDormitoryList);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(41, 105, 52, 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(3)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
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

  // //creates the List
  // Widget ListCreator(
  //     BuildContext context, Map<String, dynamic> mapofuserdetails, int index) {
  //   availble = mapofuserdetails['isAvailable'];
  //   //   print("is availble $availble");
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: SizedBox(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 25),
  //         child: Bounceable(
  //           onTap: () {
  //             //on tap to navigate to corresponding room details page
  //             if (kDebugMode) {
  //               print('name ${mapofuserdetails['name']}');
  //             }
  //             if (kDebugMode) {
  //               print('rate ${mapofuserdetails['rate']}');
  //             }
  //             if (kDebugMode) {
  //               print('availability ${mapofuserdetails['isAvailable']}');
  //             }

  //             //on tap current room details/book page will load
  //             bool test = mapofuserdetails['isAvailable'];
  //             if (test == true) {
  //               //homestay edit
  //               //navigate to hostay book page
  //               Navigator.push(
  //                 context,
  //                 CupertinoPageRoute(
  //                     builder: (context) => HomestayEditPage(
  //                         currentHomestayData: mapofuserdetails)),
  //               );
  //             } else {
  //               // Room is not available, show a SnackBar
  //               // loadCustomer(
  //               //     context, mapofuserdetails['name'], mapofuserdetails);
  //               // /* ScaffoldMessenger.of(context).showSnackBar(
  //               //   const SnackBar(
  //               //     content: Text('Homestay is Already Booked'),
  //               //     duration:
  //               //         Duration(seconds: 3), // You can adjust the duration
  //               //   ),
  //               // );*/
  //               // if (kDebugMode) {
  //               //   print("availblity $test");
  //               // }
  //               // notifyListeners();
  //             }
  //             // RoomBookPage(currentRoomData: mapofuserdetails);
  //             // set print roomno print('tapped roomn');
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               boxShadow: const [
  //                 BoxShadow(
  //                   color: Color.fromRGBO(0, 0, 0, 0.27),
  //                   blurRadius: 4,
  //                   offset: Offset(0, 4),
  //                 ),
  //               ],
  //               borderRadius: BorderRadius.circular(6),
  //               color: const Color.fromARGB(255, 255, 255, 255),
  //             ),
  //             height: MediaQuery.of(context).size.height / 10,
  //             child: Row(
  //               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               //crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   decoration: const BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(6),
  //                       bottomLeft: Radius.circular(6),
  //                     ),
  //                     //    color: Color.fromRGBO(68, 142, 74, 1),
  //                   ),
  //                   width: MediaQuery.of(context).size.width / 6,
  //                   height: MediaQuery.of(context).size.height / 10,
  //                   child: ClipRRect(
  //                     borderRadius: const BorderRadius.only(
  //                       topLeft: Radius.circular(6),
  //                       bottomLeft: Radius.circular(6),
  //                     ),
  //                     child: Stack(
  //                       children: [
  //                         // Placeholder Image
  //                         Center(
  //                           child: Image.asset('assets/images/img.png',
  //                               width: MediaQuery.of(context).size.width / 9.5,
  //                               height:
  //                                   MediaQuery.of(context).size.height / 9.5),
  //                         ),
  //                         // Actual Image with Fade Transition
  //                         Positioned.fill(
  //                           child: Image.network(
  //                             mapofuserdetails['image'],
  //                             fit: BoxFit.cover,
  //                             // loadingBuilder: (BuildContext context,
  //                             //     Widget child,
  //                             //     ImageChunkEvent? loadingProgress) {
  //                             //   if (loadingProgress == null) return child;
  //                             //   return Center(
  //                             //     child: CircularProgressIndicator(
  //                             //       color:
  //                             //           const Color.fromRGBO(253, 186, 63, 1),
  //                             //       value: loadingProgress.expectedTotalBytes !=
  //                             //               null
  //                             //           ? loadingProgress
  //                             //                   .cumulativeBytesLoaded /
  //                             //               loadingProgress.expectedTotalBytes!
  //                             //           : null,
  //                             //     ),
  //                             //   );
  //                             // },
  //                           ),
  //                           /*     CachedNetworkImage(
  //                       filterQuality: FilterQuality.medium,
  //                       fit: BoxFit.cover,
  //                       imageUrl: mapofuserdetails['image'],
  //                       placeholder: (context, url) => imageLoading(),
  //                       errorWidget: (context, url, error) =>
  //                           new Icon(Icons.error),
  //                     ),*/
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 5,
  //                 ),
  //                 //used expanded to align elements correctly
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         mapofuserdetails['name'],
  //                         style: const TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 19,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       Text(
  //                         'Rate ${mapofuserdetails['rate']}',
  //                         style: const TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(right: 10),
  //                   child: Container(
  //                     height: 24,
  //                     width: 24,
  //                     decoration: BoxDecoration(
  //                       color: availble
  //                           ? const Color.fromRGBO(41, 105, 52, 1)
  //                           : const Color.fromRGBO(255, 0, 0, 1),
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(3)),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //shimmer shapes
  Widget buildShimmerFloorListView(
    int count,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 17,
        ),
        //tiles
        ListView.builder(
          shrinkWrap: true, // Use shrinkWrap to avoid conflicts
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          // padding: const EdgeInsets.all(8),
          itemCount: count,

          itemBuilder: (BuildContext context, int index) {
            return const ShimmerWidget();
          },
        ),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
