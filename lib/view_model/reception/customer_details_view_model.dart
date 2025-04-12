// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/model/customers_model.dart';
import 'package:order_now_android/view/reseptionist/customer_edit_page.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view_model/reception/dormitory_book_view_model.dart';
import 'package:order_now_android/view_model/reception/homestay_book_view_model.dart';
import 'package:provider/provider.dart';

import 'room_book_view_model.dart';

class CustomerProvider extends ChangeNotifier {
  List<CustomerDetails> RoomCustomers = [];
  List<CustomerDetails> DormitoryCustomers = [];
  List<CustomerDetails> HomestayCustomers = [];
  bool isLoading = true;

//creates the List
//i think we should create an different List creator for Homestay to display the Homestay name or We should use the bool as a parameter and then change it with room no
//Tour package is also connected with the rooms so we dont want to seperte it.
  Widget ListCreator(BuildContext context,
      Map<String, dynamic> mapofuserdetails, int index, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Bounceable(
            onTap: () {
              if (kDebugMode) {
                print(mapofuserdetails['roomnoORname']);
                print(mapofuserdetails['name']);
                print(mapofuserdetails['rate']);
                print(mapofuserdetails['uniqueID']);
              }

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      CustomerEditPage(currentCustomerData: mapofuserdetails),
                ),
              );
              //navigate to currosponding customer details page
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
                      color: Color.fromRGBO(68, 142, 74, 1),
                    ),
                    width: MediaQuery.of(context).size.width / 26,
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  const SizedBox(
                    width: 15,
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
                          '$text${mapofuserdetails['roomnoORname']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //firebase
  void DetailsLoader(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        await loadRoomCustomers(context);
        await loadDormitoryCustomers(context);
        await loadHomestayCustomers(context);

        // Set loading state to false
        isLoading = false;
        notifyListeners();
      } catch (e) {
        // Handle errors
        if (kDebugMode) {
          print('Error loading customer details: $e');
        }
        // Set loading state to false in case of an error
        isLoading = false;
        notifyListeners();
      }
    });
  }

  bool isCheckoutTimePassed(String checkoutDate, String checkoutTime) {
    try {
      // Combine date and time strings
      String dateTimeString = '$checkoutDate $checkoutTime';

      // Parse the combined string using a specific format
      DateTime checkoutDateTime =
          DateFormat('yyyy-MM-dd hh:mm a').parse(dateTimeString);

      // Compare checkout time with current time
      DateTime currentDateTime = DateTime.now();
      bool isTimePassed = checkoutDateTime.isBefore(currentDateTime);

      return isTimePassed;
    } catch (e) {
      if (kDebugMode) {
        print('Error on time parsing: $e');
      }
      return false; // Assuming false if there's an error
    }
  }

  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

  //to update the availability of customer in room
  Future<void> automaticCustomerupdateForRoom(BuildContext context,
      {required String name, required String uniqueID}) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot = await customercollection
          .where('uniqueID', isEqualTo: uniqueID)
          .where('name', isEqualTo: name)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var docid = querySnapshot.docs[0].id;

        // Use the retrieved document ID here
        await customercollection.doc(docid).update({'isCustomerinRoom': false});
        // Use await to wait for the Firestore update to complete before proceeding
        await loadRoomCustomers(
            context); // Refresh the data to reflect the changes
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

//load custmoer rooms(normal room bookings)
  Future<void> loadRoomCustomers(BuildContext context) async {
    try {
      notifyListeners();
      List<CustomerDetails> updatedRoomCustomers =
          []; //added this when compared to old code
      final snapshot =
          await FirebaseFirestore.instance.collection('customers').get();
      final customerDetails = snapshot.docs
          .map((doc) => CustomerDetails.fromJson(doc.data()))
          .toList();

      for (var room in customerDetails) {
        if (room.catogary == 'rooms' && room.isCustomerinRoom == true) {
          if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
            updatedRoomCustomers.add(room);
          } else {
            // The checkout time has passed, update availability
            await automaticCustomerupdateForRoom(
              context,
              name: room.name,
              uniqueID: room.uniqueID,
            );
            await Provider.of<RoomBookProvider>(context, listen: false)
                .UpdateAvailbility(
              context,
              roomno: room.roomnoORname,
              Availbility: true,
            );
            if (kDebugMode) {
              print('Availability of customer ${room.name} changed');
            }
          }
        }
      }

      RoomCustomers
        ..clear()
        ..addAll(updatedRoomCustomers);

      RoomCustomers.sort((a, b) => a.roomnoORname.compareTo(b.roomnoORname));

      if (RoomCustomers.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      notifyListeners();
    }
  }
//old code
  // Future<void> loadRoomCustomers(BuildContext context) async {
  //   try {
  //     notifyListeners();
  //     RoomCustomers
  //         .clear(); // Clear the list before populating//it  avoid the duplication of tiles
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('customers').get();
  //     final customerDetails = snapshot.docs
  //         .map((doc) => CustomerDetails.fromJson(doc.data()))
  //         .toList();

  //     for (var room in customerDetails) {
  //       if (room.catogary == 'rooms' && room.isCustomerinRoom == true) {
  //         if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
  //           RoomCustomers.add(room);
  //         } else {
  //           // The checkout time has passed, update availability
  //           await automaticCustomerupdateForRoom(context,
  //               name: room.name, uniqueID: room.uniqueID);
  //           await Provider.of<RoomBookProvider>(context, listen: false)
  //               .UpdateAvailbility(context,
  //                   roomno: room.roomnoORname, Availbility: true);
  //           if (kDebugMode) {
  //             print('Availability of customer ${room.name} changed');
  //           }
  //         }
  //       }
  //     }

  //     RoomCustomers.sort((a, b) => a.roomnoORname.compareTo(b.roomnoORname));

  //     if (RoomCustomers.isEmpty) {
  //       if (kDebugMode) {
  //         print('List is empty');
  //       }
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     notifyListeners();
  //   }
  // }

  //to update the availability of customer in room
  Future<void> automaticCustomerupdateForDormitory(BuildContext context,
      {required String name, required String uniqueID}) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot = await customercollection
          .where('uniqueID', isEqualTo: uniqueID)
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docid = querySnapshot.docs[0].id;

        // Use the retrieved document ID here
        await customercollection.doc(docid).update({'isCustomerinRoom': false});
        // Use await to wait for the Firestore update to complete before proceeding
        await loadDormitoryCustomers(
            context); // Refresh the data to reflect the changes
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  //load custmoer dormmitory(normal room bookings)
  Future<void> loadDormitoryCustomers(BuildContext context) async {
    try {
      notifyListeners();
      List<CustomerDetails> updatedDormitoryCustomers =
          []; //added this when compared to old code
      final snapshot =
          await FirebaseFirestore.instance.collection('customers').get();
      final customerDetails = snapshot.docs
          .map((doc) => CustomerDetails.fromJson(doc.data()))
          .toList();

      for (var room in customerDetails) {
        if (room.catogary == 'dormitory' && room.isCustomerinRoom == true) {
          if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
            updatedDormitoryCustomers.add(room);
          } else {
            // The checkout time has passed, update availability
            await automaticCustomerupdateForDormitory(
              context,
              name: room.name,
              uniqueID: room.uniqueID,
            );
            await Provider.of<dormitoryBookProvider>(context, listen: false)
                .UpdateAvailbility(
              context,
              Availbility: true,
              dormitoryno: room.roomnoORname,
            );
            if (kDebugMode) {
              print('Availability of customer ${room.name} changed');
            }
          }
        }
      }

      DormitoryCustomers
        ..clear()
        ..addAll(updatedDormitoryCustomers);

      DormitoryCustomers.sort((a, b) =>
          a.roomnoORname.compareTo(b.roomnoORname)); //sorting by room number

      if (DormitoryCustomers.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
          //add a network error or something here to load if the list is empty
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      notifyListeners();
    }
  }
//old code
  // //load custmoer dormmitory(normal room bookings)
  // Future<void> loadDormitoryCustomers(BuildContext context) async {
  //   try {
  //     notifyListeners();
  //     DormitoryCustomers
  //         .clear(); // Clear the list before populating//it  avoid the duplication of tiles
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('customers').get();
  //     // print('check here${snapshot.docs.length}');
  //     final customerDetails = snapshot.docs
  //         .map((doc) => CustomerDetails.fromJson(doc.data()))
  //         .toList();
  //     for (var room in customerDetails) {
  //       if (room.catogary == 'dormitory' && room.isCustomerinRoom == true) {
  //         if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
  //           DormitoryCustomers.add(room);
  //         } else {
  //           // The checkout time has passed, update availability
  //           await automaticCustomerupdateForDormitory(context,
  //               name: room.name, uniqueID: room.uniqueID);
  //           await Provider.of<dormitoryBookProvider>(context, listen: false)
  //               .UpdateAvailbility(context,
  //                   Availbility: true, dormitoryno: room.roomnoORname);
  //           if (kDebugMode) {
  //             print('Availability of customer ${room.name} changed');
  //           }
  //         }
  //       }
  //     }

  //     // print('jobb ${userDetails.length}');
  //     DormitoryCustomers.sort((a, b) => a.roomnoORname.compareTo(
  //         b.roomnoORname)); //filtering rooms on the ascending order of room no
  //     if (DormitoryCustomers.isEmpty) {
  //       if (kDebugMode) {
  //         print('List is empty');
  //         //add an Network error or something here to load if the list is empty
  //       }
  //       //     const Text('data');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   notifyListeners();
  // }

  //to update the availability of customer in room
  Future<void> automaticCustomerupdateForHomestay(BuildContext context,
      {required String name, required String uniqueID}) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot = await customercollection
          .where('uniqueID', isEqualTo: uniqueID)
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docid = querySnapshot.docs[0].id;

        // Use the retrieved document ID here
        await customercollection.doc(docid).update({'isCustomerinRoom': false});
        // Use await to wait for the Firestore update to complete before proceeding
        await loadHomestayCustomers(
            context); // Refresh the data to reflect the changes
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  //load homestay customers
  //new homestay load code

  Future<void> loadHomestayCustomers(BuildContext context) async {
    try {
      notifyListeners();
      List<CustomerDetails> updatedHomestayCustomers =
          []; //added this when compared to old code
      // HomestayCustomers
      //     .clear(); // Clear the list before populating//it  avoid the duplication of tiles
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('customers').get();
      // print('check here${snapshot.docs.length}');
      final customerDetails = snapshot.docs
          .map((doc) => CustomerDetails.fromJson(doc.data()))
          .toList();
      for (var room in customerDetails) {
        if (room.catogary == 'homestay' && room.isCustomerinRoom == true) {
          if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
            // HomestayCustomers.add(room);
            updatedHomestayCustomers.add(room);
          } else {
            // The checkout time has passed, update availability
            await automaticCustomerupdateForHomestay(context,
                name: room.name, uniqueID: room.uniqueID);
            await Provider.of<HomestayBookProvider>(context, listen: false)
                .UpdateAvailbility(context,
                    Availbility: true, Homestayname: room.roomnoORname);
            if (kDebugMode) {
              print('Availability of customer ${room.name} changed');
            }
          }
        }
      }
      HomestayCustomers
        ..clear()
        ..addAll(updatedHomestayCustomers);
      // print('jobb ${userDetails.length}');

      if (HomestayCustomers.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
          //add an Network error or something here to load if the list is empty
        }
        const Text('data');
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

//old code
  // Future<void> loadHomestayCustomers(BuildContext context) async {
  //   try {
  //     notifyListeners();
  //     HomestayCustomers
  //         .clear(); // Clear the list before populating//it  avoid the duplication of tiles
  //     // final snapshot = dataRetriver.get(); is it works??
  //     final snapshot =
  //         await FirebaseFirestore.instance.collection('customers').get();
  //     // print('check here${snapshot.docs.length}');
  //     final customerDetails = snapshot.docs
  //         .map((doc) => CustomerDetails.fromJson(doc.data()))
  //         .toList();
  //     for (var room in customerDetails) {
  //       if (room.catogary == 'homestay' && room.isCustomerinRoom == true) {
  //         if (!isCheckoutTimePassed(room.checkoutdate, room.checkouttime)) {
  //           HomestayCustomers.add(room);
  //         } else {
  //           // The checkout time has passed, update availability
  //           await automaticCustomerupdateForHomestay(context,
  //               name: room.name, uniqueID: room.uniqueID);
  //           await Provider.of<HomestayBookProvider>(context, listen: false)
  //               .UpdateAvailbility(context,
  //                   Availbility: true, Homestayname: room.roomnoORname);
  //           if (kDebugMode) {
  //             print('Availability of customer ${room.name} changed');
  //           }
  //         }
  //       }
  //     }
  //     // print('jobb ${userDetails.length}');

  //     if (HomestayCustomers.isEmpty) {
  //       if (kDebugMode) {
  //         print('List is empty');
  //         //add an Network error or something here to load if the list is empty
  //       }
  //       const Text('data');
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   notifyListeners();
  // }

  Widget buildcustomerTiles(BuildContext context, String CatogaryName,
      List<CustomerDetails> CatogaryList, String text) {
    return Column(
      children: [
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  CatogaryName,
                  style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8.5,
        ),
        CatogaryList.isEmpty
            ? const Text(
                'No customers on this Catogary', //after add the currosponding catogary
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CatogaryList.length,
                itemBuilder: ((context, index) {
                  //use a bool if All chip is selected then automatically load the data on this page
                  Map<String, dynamic> detailsList = {
                    'uniqueID': CatogaryList[index].uniqueID,
                    'roomtype': CatogaryList[index].roomtype,
                    'roomnoORname': CatogaryList[index].roomnoORname,
                    'rate': CatogaryList[index].rate,
                    'mobileNumber': CatogaryList[index].mobileNumber,
                    'address': CatogaryList[index].address,
                    'floor': CatogaryList[index].floor,
                    'proof': CatogaryList[index].proof,
                    'purpose': CatogaryList[index].purpose,
                    'name': CatogaryList[index].name,
                    'Noofpeople': CatogaryList[index].Noofpeople,
                    'checkindate': CatogaryList[index].checkindate,
                    'checkintime': CatogaryList[index].checkintime,
                    'checkoutdate': CatogaryList[index].checkoutdate,
                    'checkouttime': CatogaryList[index].checkouttime,
                    'catogary': CatogaryList[index].catogary,
                    'isCustomerinRoom': CatogaryList[index].isCustomerinRoom
                  };

                  return ListCreator(context, detailsList, index, text);
                }),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
