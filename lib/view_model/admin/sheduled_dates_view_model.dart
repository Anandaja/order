import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/model/reservation_model.dart';
import 'package:order_now_android/view/admin/reserve_customer_edit_page.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class SheduledDateProvider extends ChangeNotifier {
  //
  bool isLoading = false;
  //firebase
  void DetailsLoader(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        // await loadRoomCustomers(context);
        // await loadDormitoryCustomers(context);
        // await loadHomestayCustomers(context);
        await loadRoomCustomers();
        await loadDormitoryCustomers();
        await loadHomestayCustomers();

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

  final CollectionReference Reservationcollection =
      FirebaseFirestore.instance.collection('reservation');
  // Future<void> getReservedRoomData() async {
  //   try {
  //     await Reservationcollection.where('isReserved', isEqualTo: true)
  //         .where('catogary', isEqualTo: 'rooms');
  //   } catch (e) {
  //     print("Eroor on reserve room data load $e");
  //   }
  // }

  //just for testing
  List<DataBaseDetails> ReserveRoomsList =
      []; //to load all list  if that fllor seperated list not works

  List<DataBaseDetails> ReserveDormitoryList =
      []; //to load all list  if that fllor seperated list not works

  List<DataBaseDetails> HomestayReserveList = [];
  bool isReserevdTimePassed(DateTime Reserveddate) {
    try {
      DateTime currentDateTime = DateTime.now();
      bool isTimePassed = Reserveddate.isAfter(
          currentDateTime); //returns true if  the reserved date is passed when compare to todays date

      return isTimePassed;
    } catch (e) {
      if (kDebugMode) {
        print('Error on time parsing: $e');
      }
      return false; // Assuming false if there's an error
    }
  }

  Future<void> automaticReservationpdateForRoom(
      {required String Customername,
      required String uniqueID,
      required String Catogary}) async {
    try {
      QuerySnapshot querySnapshot =
          await Reservationcollection.where('catogary', isEqualTo: Catogary)
              .where('name', isEqualTo: Customername)
              .where('uniqueId', isEqualTo: uniqueID)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docid = querySnapshot.docs[0].id;

        // Use the retrieved document ID here
        await Reservationcollection.doc(docid).update({'isReserved': false});
        //this will add this customer reserved data to history reservation page.
        notifyListeners();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> loadRoomCustomers() async {
    try {
      List<DataBaseDetails> updatedRoomCustomers =
          []; //added this when compared to old code
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot = await Reservationcollection.get();
      // print('check here${snapshot.docs.length}');
      final roomDetails = snapshot.docs
          .map((doc) => DataBaseDetails.fromJson(doc.data()))
          .toList();
      print('noobtest${roomDetails[0]}');
      // Floor1List = roomDetails.where((room) => room.floor == '1st').toList();
      // print('boomerang ${detailedList[0]}');
      for (var customer in roomDetails) {
        if (customer.catogary == 'rooms' && customer.isReserved == true) {
          if (isReserevdTimePassed(customer.date!)) {
            updatedRoomCustomers.add(customer);
          } else {
            // The checkout time has passed, update availability
            await automaticReservationpdateForRoom(
                Customername: customer.name,
                uniqueID: customer.uniqueId,
                Catogary: customer.catogary);

            if (kDebugMode) {
              print(
                  'this reserved customer name ${customer.name} his date ${customer.date}.this customer added to past details');
            }
          }
        }
      }

      ReserveRoomsList
        ..clear()
        ..addAll(updatedRoomCustomers);

      // RoomCustomers.sort((a, b) => a.roomnoORname.compareTo(b.roomnoORname));

      // ReserveRoomsList = roomDetails
      //     .where((room) => room.isReserved == true)
      //     .where((room) => room.catogary == 'rooms')
      //     .toList();

      print('jobb ${ReserveRoomsList.length}');
      ReserveRoomsList.sort((a, b) => a.date!.compareTo(
          b.date!)); //filtering rooms on the ascending order of room no
      if (ReserveRoomsList.isEmpty) {
        if (kDebugMode) {
          print('Generel List is empty');
        }
        // const Text('data');
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('on generel list loader $e');
      }
    }
    notifyListeners();
  }

  //test dormitory reservation load

  Future<void> loadDormitoryCustomers() async {
    try {
      List<DataBaseDetails> updatedDormitoryCustomers =
          []; //added this when compared to old code
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot = await Reservationcollection.get();
      // print('check here${snapshot.docs.length}');
      final roomDetails = snapshot.docs
          .map((doc) => DataBaseDetails.fromJson(doc.data()))
          .toList();
      print('noobtest${roomDetails[0]}');
      // Floor1List = roomDetails.where((room) => room.floor == '1st').toList();
      // print('boomerang ${detailedList[0]}');
      for (var customer in roomDetails) {
        if (customer.catogary == 'dormitory' && customer.isReserved == true) {
          if (isReserevdTimePassed(customer.date!)) {
            updatedDormitoryCustomers.add(customer);
          } else {
            // The checkout time has passed, update availability
            await automaticReservationpdateForRoom(
                Customername: customer.name,
                uniqueID: customer.uniqueId,
                Catogary: customer.catogary);

            if (kDebugMode) {
              print(
                  'this reserved customer name ${customer.name} his date ${customer.date}.this customer added to past details');
            }
          }
        }
      }

      ReserveDormitoryList
        ..clear()
        ..addAll(updatedDormitoryCustomers);

      // RoomCustomers.sort((a, b) => a.roomnoORname.compareTo(b.roomnoORname));

      // ReserveRoomsList = roomDetails
      //     .where((room) => room.isReserved == true)
      //     .where((room) => room.catogary == 'rooms')
      //     .toList();

      print('dormitory length ${ReserveDormitoryList.length}');
      ReserveDormitoryList.sort((a, b) => a.date!.compareTo(
          b.date!)); //filtering rooms on the ascending order of room no
      if (ReserveDormitoryList.isEmpty) {
        if (kDebugMode) {
          print('Generel List is empty');
        }
        // const Text('data');
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('on generel list loader $e');
      }
    }
    notifyListeners();
  }

  //homestay reservation load
  Future<void> loadHomestayCustomers() async {
    try {
      List<DataBaseDetails> updatedRoomCustomers =
          []; //added this when compared to old code
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot = await Reservationcollection.get();
      // print('check here${snapshot.docs.length}');
      final roomDetails = snapshot.docs
          .map((doc) => DataBaseDetails.fromJson(doc.data()))
          .toList();
      print('noobtest${roomDetails[0]}');
      // Floor1List = roomDetails.where((room) => room.floor == '1st').toList();
      // print('boomerang ${detailedList[0]}');
      for (var customer in roomDetails) {
        if (customer.catogary == 'homestay' && customer.isReserved == true) {
          if (isReserevdTimePassed(customer.date!)) {
            updatedRoomCustomers.add(customer);
          } else {
            // The checkout time has passed, update availability
            await automaticReservationpdateForRoom(
                Customername: customer.name,
                uniqueID: customer.uniqueId,
                Catogary: customer.catogary);

            if (kDebugMode) {
              print(
                  'this reserved customer name ${customer.name} his date ${customer.date}.this customer added to past details');
            }
          }
        }
      }

      HomestayReserveList
        ..clear()
        ..addAll(updatedRoomCustomers);

      // RoomCustomers.sort((a, b) => a.roomnoORname.compareTo(b.roomnoORname));

      // ReserveRoomsList = roomDetails
      //     .where((room) => room.isReserved == true)
      //     .where((room) => room.catogary == 'rooms')
      //     .toList();

      print('jobb ${HomestayReserveList.length}');
      HomestayReserveList.sort((a, b) => a.date!.compareTo(
          b.date!)); //filtering rooms on the ascending order of room no
      if (HomestayReserveList.isEmpty) {
        if (kDebugMode) {
          print('HomestayReserveList is empty');
        }
        // const Text('data');
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('on generel list loader $e');
      }
    }
    notifyListeners();
  }

  String? formattedDate;
  // void initState() {
  //   super.initState();
  //   formattedDate = DateFormat('dd-MM-yyyy').format(widget.CurrentDate);
  // }
  Widget ListCreator(BuildContext context,
      Map<String, dynamic> mapofuserdetails, int index, String text) {
    //formattedDate = DateFormat('dd-MM-yyyy').format(mapofuserdetails['date']);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Bounceable(
            onTap: () {
              if (kDebugMode) {
                print('Advance ${mapofuserdetails['AdvanceAmount']}');
                print('Name ${mapofuserdetails['name']}');
                print('date ${mapofuserdetails['date']}');
                print('Totalrate ${mapofuserdetails['Totalrate']}');
                print('catogary ${mapofuserdetails['catogary']}');
                print('isReserved ${mapofuserdetails['isReserved']}');
                print('phonenumber ${mapofuserdetails['phonenumber']}');
                print('proof ${mapofuserdetails['proof']}');
                print('reserveList ${mapofuserdetails['reserveList']}');
                print(
                    "Formatted Date ${DateFormat('dd-MM-yyyy').format(mapofuserdetails['date'])}");
                print(
                    "Unnnnnnnnnnnnnnnnniq id ${mapofuserdetails['uniqueId']}");
              }

              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ReserveCustomerEditPage(
                          CurrentDate: mapofuserdetails['date'],
                          ReservedRoomList: mapofuserdetails['reserveList'],
                          CustomerDetails: mapofuserdetails,
                          formattedDate: DateFormat('dd-MM-yyyy')
                              .format(mapofuserdetails['date']),
                          catogary: mapofuserdetails['catogary'],
                        )),
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
                          '$text${DateFormat('dd-MM-yyyy').format(mapofuserdetails['date'])}',
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

  Widget buildcustomerTiles(BuildContext context, String CatogaryName,
      List<DataBaseDetails> CatogaryList, String text) {
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
                    'name': CatogaryList[index].name,
                    'date': CatogaryList[index].date,
                    'AdvanceAmount': CatogaryList[index].AdvanceAmount,
                    'Totalrate': CatogaryList[index].Totalrate,
                    'catogary': CatogaryList[index].catogary,
                    'isReserved': CatogaryList[index].isReserved,
                    'phonenumber': CatogaryList[index].phonenumber,
                    'proof': CatogaryList[index].proof,
                    'reserveList': CatogaryList[index].reserveList,
                    'uniqueId': CatogaryList[index].uniqueId,
                    'address': CatogaryList[index].address,
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
