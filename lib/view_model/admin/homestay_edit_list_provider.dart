// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:order_now_android/model/customers_model.dart';
import 'package:order_now_android/model/homestay_model.dart';
import 'package:order_now_android/view/admin/current_customer.dart';
import 'package:order_now_android/view/admin/homestay_edit_admin.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';

class HomestayEditListProvider extends ChangeNotifier {
  List<HomestayDetails> HomestayList = [];
  late bool availble;
  bool isLoading = true;
  //Firebase

  final CollectionReference homestaycollection =
      FirebaseFirestore.instance.collection('homestay');

  void DetailsLoader() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        await loadHomestays(); //1 flor

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
                print('name ${mapofuserdetails['name']}');
              }
              if (kDebugMode) {
                print('rate ${mapofuserdetails['rate']}');
              }
              if (kDebugMode) {
                print('availability ${mapofuserdetails['isAvailable']}');
              }

              //on tap current room details/book page will load
              bool test = mapofuserdetails['isAvailable'];
              if (test == true) {
                //homestay edit
                //navigate to hostay book page
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => HomestayEditPage(
                          currentHomestayData: mapofuserdetails)),
                );
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //       builder: (context) => AdminHomestayBookPage(
                //             currentHomestayData: mapofuserdetails,
                //           )),
                // );
              } else {
                // Room is not available, show a SnackBar
                loadCustomer(
                    context, mapofuserdetails['name'], mapofuserdetails);
                /* ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Homestay is Already Booked'),
                    duration:
                        Duration(seconds: 3), // You can adjust the duration
                  ),
                );*/
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
                borderRadius: BorderRadius.circular(6),
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
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                      //    color: Color.fromRGBO(68, 142, 74, 1),
                    ),
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
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

  //finding customer
  List<CustomerDetails> HomestayCustomers = [];
  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

  Future<void> loadCustomer(BuildContext context, String HomestayName,
      Map<String, dynamic> currentRoomData) async {
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('roomnoORname', isEqualTo: HomestayName)
          .where('isCustomerinRoom', isEqualTo: true)
          .get();
      final customerDetails = snapshot.docs
          .map((doc) => CustomerDetails.fromJson(doc.data()))
          .toList();
      if (customerDetails.isNotEmpty) {
        for (var room in customerDetails) {
          print('customer name ${room.name}');
          print('customer purpose ${room.purpose}');
          print('cusomer no of people ${room.Noofpeople}');
          Map<String, dynamic> detailsList = {
            'uniqueID': room.uniqueID,
            'roomtype': room.roomtype,
            'roomnoORname': room.roomnoORname,
            'rate': room.rate,
            'mobileNumber': room.mobileNumber,
            'address': room.address,
            'floor': room.floor,
            'proof': room.proof,
            'purpose': room.purpose,
            'name': room.name,
            'Noofpeople': room.Noofpeople,
            'checkindate': room.checkindate,
            'checkintime': room.checkintime,
            'checkoutdate': room.checkoutdate,
            'checkouttime': room.checkouttime,
            'catogary': room.catogary,
            'isCustomerinRoom': room.isCustomerinRoom
          };

          print('from map ${detailsList['name']}');

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  CurrentCustomerData(currentCustomerData: detailsList),
            ),
          );
          //need to change this into map
        }
      } else {
        print("no customer on this room");
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  HomestayEditPage(currentHomestayData: currentRoomData)),
        );
      }
      //  print('The ${name} "s Address is updated');
    } catch (error) {
      //   print('The ${name} "s Address is not updated');
      print(error);
    }
  }
}
