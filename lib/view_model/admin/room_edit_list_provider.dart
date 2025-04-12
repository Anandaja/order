// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/customers_model.dart';
import 'package:order_now_android/model/rooms_model.dart';
import 'package:order_now_android/view/admin/current_customer.dart';
import 'package:order_now_android/view/admin/rooms_edit_page.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class RoomsEditListProvider extends ChangeNotifier {
  bool isFetching = true;

  bool iscolor = true;
  late bool availble; // to check the availbility of room
  List<RoomDetails> Floor1List = []; //firstfloor
  List<RoomDetails> Floor2List = []; //secondfloor
  List<RoomDetails> Floor3List = []; //third floor

  //Flter button on pressed
  // this makes the correct filter
  List<RoomDetails> originalList1stFloor = [];
  List<RoomDetails> originalList2ndFloor = [];
  List<RoomDetails> originalList3rdFloor = [];

  final CollectionReference dataRetriver =
      FirebaseFirestore.instance.collection('rooms');

  //name of chips given as list
  final List<String> _chipLabel = [
    'All',
    'DoubleCot',
    'FourBed',
    'SixCot',
    'Available',
    'NotAvailable',
  ];

  int _selectedChip = 0;

  int get selectedChip => _selectedChip;

  void setSelectedChip(int chip) {
    _selectedChip = chip;
    notifyListeners();
  }

  void getFilterdata(int currentchip) {
    switch (currentchip) {
      case 0:
        // Load all rooms

        resetFilter(); //load full list

        notifyListeners(); //updates the ui
        break;
      case 1:
        filterRoomsByType(
            'Double Coat'); // Load specific type of rooms (Double Coat)

        notifyListeners(); //updates the ui
        break;
      case 2:
        filterRoomsByType('Four bed'); // Load specific type of rooms (FourBed)

        notifyListeners(); //updates the ui
        break;
      case 3:
        filterRoomsByType('Six cot'); // Load specific type of rooms (sixcot)
        notifyListeners(); //updates the ui
        break;
      case 4:
        Available(true); //Load Available rooms only
        notifyListeners(); //updates the ui
        break;
      case 5:
        NotAvailable(false); //not availble rooms only
        notifyListeners(); //updates the ui
        break;
    }
  }

// for room types

  void filterRoomsByType(String roomType) {
    if (kDebugMode) {
      print('Filtering rooms by type: $roomType');
    }
    for (var room in Floor1List) {
      if (kDebugMode) {
        print('Room Type: ${room.roomtype}');
      }
    }

    // Check if the original data is available
    if (originalList1stFloor.isEmpty ||
        originalList2ndFloor.isEmpty ||
        originalList3rdFloor.isEmpty) {
      // If not, store the original list before filtering for both floors
      originalList1stFloor = List.from(Floor1List);
      originalList2ndFloor = List.from(Floor2List);
      originalList3rdFloor = List.from(Floor3List);
    }

    // Filter  the 1st floor list
    List<RoomDetails> filteredList1stFloor = originalList1stFloor
        .where((room) => room.roomtype == roomType)
        .toList();

    // Filter  2nd floor list
    List<RoomDetails> filteredList2ndFloor = originalList2ndFloor
        .where((room) => room.roomtype == roomType)
        .toList();
    //filter  3rd floor list

    List<RoomDetails> filteredList3rdFloor = originalList3rdFloor
        .where((room) => room.roomtype == roomType)
        .toList();

    if (filteredList1stFloor.isNotEmpty ||
        filteredList2ndFloor.isNotEmpty ||
        filteredList3rdFloor.isNotEmpty) {
      Floor1List = originalList1stFloor
          .where((room) => room.roomtype == roomType)
          .toList();
      Floor2List = originalList2ndFloor
          .where((room) => room.roomtype == roomType)
          .toList();
      Floor3List = originalList3rdFloor
          .where((room) => room.roomtype == roomType)
          .toList();

      if (kDebugMode) {
        print("1st Floor: ${filteredList1stFloor.length} rooms");
      }
      if (kDebugMode) {
        print("2nd Floor: ${filteredList2ndFloor.length} rooms");
      }
      if (kDebugMode) {
        print("3rd Floor ${filteredList3rdFloor.length} rooms");
      }
      notifyListeners();
    }
  }

  //for Checking availbility

  void Available(bool isAvailble) {
    if (kDebugMode) {
      print('Filtering rooms by type: $isAvailble');
    }
    for (var room in Floor1List) {
      if (kDebugMode) {
        print('Room Type: ${room.isAvailable}');
      }
    }

    // Check if the original data is available
    if (originalList1stFloor.isEmpty ||
        originalList2ndFloor.isEmpty ||
        originalList3rdFloor.isEmpty) {
      // If not, store the original list before filtering for both floors
      originalList1stFloor = List.from(Floor1List);
      originalList2ndFloor = List.from(Floor2List);
      originalList3rdFloor = List.from(Floor3List);
    }

    // Filter  1st floor list
    List<RoomDetails> filteredList1stFloor =
        originalList1stFloor.where((room) => room.isAvailable == true).toList();

    // Filter 2nd floor list
    List<RoomDetails> filteredList2ndFloor =
        originalList2ndFloor.where((room) => room.isAvailable == true).toList();
    // Filter 3rd floor list
    List<RoomDetails> filteredList3rdFloor =
        originalList3rdFloor.where((room) => room.isAvailable == true).toList();

    if (filteredList1stFloor.isNotEmpty ||
        filteredList2ndFloor.isNotEmpty ||
        filteredList3rdFloor.isNotEmpty) {
      Floor1List = filteredList1stFloor;
      Floor2List = filteredList2ndFloor;
      Floor3List = filteredList3rdFloor;

      if (kDebugMode) {
        print("1st Floor: ${filteredList1stFloor.length} rooms");
      }
      if (kDebugMode) {
        print("2nd Floor: ${filteredList2ndFloor.length} rooms");
      }
      if (kDebugMode) {
        print("3rd Floor ${filteredList3rdFloor.length} rooms");
      }
      notifyListeners();
    }
  }

  bool NotAvailablecheck = false;

//not Aavailble
  void NotAvailable(bool isAvailble) {
    if (kDebugMode) {
      print('Filtering rooms by type: $isAvailble');
    }
    for (var room in Floor1List) {
      if (kDebugMode) {
        print('Room Type: ${room.isAvailable}');
      }
    }

    // Check if the original data is available
    if (originalList1stFloor.isEmpty ||
        originalList2ndFloor.isEmpty ||
        originalList3rdFloor.isEmpty) {
      // If not, store the original list before filtering for both floors
      originalList1stFloor = List.from(Floor1List);
      originalList2ndFloor = List.from(Floor2List);
      originalList3rdFloor = List.from(Floor3List);
    }

    // Filter  1st floor list
    List<RoomDetails> filteredList1stFloor = originalList1stFloor
        .where((room) => room.isAvailable == false)
        .toList();

    // Filter  2nd floor list
    List<RoomDetails> filteredList2ndFloor = originalList2ndFloor
        .where((room) => room.isAvailable == false)
        .toList();

    // Filter  2nd floor list
    List<RoomDetails> filteredList3rdFloor = originalList3rdFloor
        .where((room) => room.isAvailable == false)
        .toList();

    if (filteredList1stFloor.isNotEmpty ||
        filteredList2ndFloor.isNotEmpty ||
        filteredList3rdFloor.isNotEmpty) {
      Floor1List = filteredList1stFloor;
      Floor2List = filteredList2ndFloor;
      Floor3List = filteredList3rdFloor;

      if (kDebugMode) {
        print("1st Floor: ${filteredList1stFloor.length} rooms");
      }
      if (kDebugMode) {
        print("2nd Floor: ${filteredList2ndFloor.length} rooms");
      }
      if (kDebugMode) {
        print("3rd Floor ${filteredList3rdFloor.length} rooms");
      }

      notifyListeners();
    } else if (filteredList1stFloor.isEmpty &&
        filteredList2ndFloor.isEmpty &&
        filteredList3rdFloor.isEmpty) {
      Floor1List = filteredList1stFloor;
      Floor2List = filteredList2ndFloor;
      Floor3List = filteredList3rdFloor;

      NotAvailablecheck = true;
      if (kDebugMode) {
        print("1st Floor: ${filteredList1stFloor.length} rooms");
      }
      if (kDebugMode) {
        print("2nd Floor: ${filteredList2ndFloor.length} rooms");
      }
      if (kDebugMode) {
        print("3rd Floor ${filteredList3rdFloor.length} rooms");
      }

      print('No data on not available');
      //   notifyListeners();
    }
  }

  void resetFilter() {
    originalList1stFloor = []; // check it last
    originalList2ndFloor = [];
    originalList3rdFloor = [];
    // originalList = [];
    loaddetails();
    floor2();
    floor3();
    notifyListeners();
  }

  //chip displaying on this dialog

  Future<void> filterDialog(BuildContext context) async {
    return showDialog(
      context: context,
      //    barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            //  backgroundColor: Colors.white,
            //
            title: const Text(
              'Tap To Filter',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List<Widget>.generate(
                    _chipLabel.length,
                    (int index) {
                      return ChoiceChip(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: const StadiumBorder(),
                        pressElevation: 8,
                        checkmarkColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        showCheckmark: true,
                        label: Text(
                          _chipLabel[index],
                          style: TextStyle(
                              color: _selectedChip == index
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w600),
                        ),
                        selected: _selectedChip == index,
                        selectedColor: const Color.fromRGBO(68, 142, 74, 1),
                        onSelected: (bool selected) {
                          // _selectedChip= selected?;
                          notifyListeners();
                          _selectedChip = (selected ? index : null)!;

                          // print(selectedChip);
                          getFilterdata(selectedChip);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  )),
            ),
          ),
        );
      },
    );
  }

//old details loader
/* void DetailsLoader(BuildContext context) {
    NotAvailablecheck
        ? Icon(
            Icons.ac_unit_outlined,
            color: Colors.black,
            size: 50,
          )
        : WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (Floor1List.isEmpty &&
                Floor2List.isEmpty &&
                Floor3List.isEmpty) {
              //must add three list to get the currect updated details mainly not avilable one
              // If detailedList is empty, load all details it useful for filtering otherwise we need to click on thae All chip
              await loaddetails(); //1 flor
              await floor2(); //2 flor
              await floor3(); //3 flor
              isFetching = false;
            }
            notifyListeners();
          });
  }*/

  void DetailssLoader(BuildContext context) {
    NotAvailablecheck
        ? Icon(
            Icons.ac_unit_outlined,
            color: Colors.black,
            size: 50,
          )
        : WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              // Set loading state to true
              isFetching = true;
              notifyListeners();

              await loaddetails(); //1 flor
              await floor2(); //2 flor
              await floor3(); //3 flor

              // Set loading state to false
              isFetching = false;
              notifyListeners();
            } catch (e) {
              // Handle errors
              if (kDebugMode) {
                print('Error loading  details: $e');
              }
              // Set loading state to false in case of an error
              isFetching = false;
              notifyListeners();
            }
          });
  }

// fetching firebase room details datas.
//fetch the floor 1
  Future<void> loaddetails() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      // print('check here${snapshot.docs.length}');
      final roomDetails =
          snapshot.docs.map((doc) => RoomDetails.fromJson(doc.data())).toList();
      //print('noobtest${userDetails[0]}');
      Floor1List = roomDetails.where((room) => room.floor == '1st').toList();
      // print('boomerang ${detailedList[0]}');

      // print('jobb ${userDetails.length}');
      Floor1List.sort((a, b) => a.roomno.compareTo(
          b.roomno)); //filtering rooms on the ascending order of room no
      if (Floor1List.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
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

  //floor 2
  Future<void> floor2() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      // print('check here${snapshot.docs.length}');
      final roomDetails =
          snapshot.docs.map((doc) => RoomDetails.fromJson(doc.data())).toList();
      //print('noobtest${userDetails[0]}');
      Floor2List = roomDetails.where((room) => room.floor == '2nd').toList();
      // print('boomerang ${detailedList[0]}');

      // print('jobb ${userDetails.length}');
      Floor2List.sort((a, b) => a.roomno.compareTo(
          b.roomno)); //filtering rooms on the ascending order of room no
      if (Floor2List.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
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

  //floor 3
  Future<void> floor3() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      // print('check here${snapshot.docs.length}');
      final roomDetails =
          snapshot.docs.map((doc) => RoomDetails.fromJson(doc.data())).toList();
      //print('noobtest${userDetails[0]}');
      Floor3List = roomDetails.where((room) => room.floor == '3rd').toList();
      // print('boomerang ${detailedList[0]}');

      // print('jobb ${userDetails.length}');
      Floor3List.sort((a, b) => a.roomno.compareTo(
          b.roomno)); //filtering rooms on the ascending order of room no
      if (Floor3List.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
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
                // Room is available, navigate to the booking page
                if (kDebugMode) {
                  print("availblity $test");
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        RoomEditPage(currentRoomData: mapofuserdetails),
                  ),
                );
              } else {
                // Room is not available, show a SnackBar
                loadCustomer(
                    context, mapofuserdetails['roomno'], mapofuserdetails);
                /* ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Room is Currently occupied'),
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
                          mapofuserdetails['roomno'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          mapofuserdetails['roomtype'],
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

  Widget buildFloorListView(
    BuildContext context,
    String floorTitle,
    List<RoomDetails> floorList,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              floorTitle,
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8.5,
        ),
        floorList.isEmpty
            ? const Text(
                'No Rooms On this Floor',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: floorList.length,
                itemBuilder: ((context, index) {
                  //use a bool if All chip is selected then automatically load the data on this page
                  Map<String, dynamic> detailsList = {
                    'roomtype': floorList[index].roomtype,
                    'roomno': floorList[index].roomno,
                    'rate': floorList[index].rate,
                    'image': floorList[index].image,
                    'isAvailable': floorList[index].isAvailable,
                    'floor': floorList[index].floor,
                  };

                  return ListCreator(context, detailsList, index);
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

  //finding customer
  List<CustomerDetails> RoomCustomers = [];
  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

  Future<void> loadCustomer(BuildContext context, String roomno4,
      Map<String, dynamic> currentRoomData) async {
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('roomnoORname', isEqualTo: roomno4)
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
                  RoomEditPage(currentRoomData: currentRoomData)),
        );
      }
      //  print('The ${name} "s Address is updated');
    } catch (error) {
      //   print('The ${name} "s Address is not updated');
      print(error);
    }
  }

  //shimmer loading shapes
  Widget buildShimmerItems(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Set explicit height
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 17,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade400,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Your filter button logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: Color.fromARGB(0, 224, 224, 224),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.filter_list,
                          color: Color.fromARGB(0, 224, 224, 224),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            buildShimmerFloorListView(4),
            buildShimmerFloorListView(9),
            buildShimmerFloorListView(9),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerFloorListView(
    int count,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 17,
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
        ListView.separated(
          shrinkWrap: true, // Use shrinkWrap to avoid conflicts
          physics: NeverScrollableScrollPhysics(), // Disable scrolling
          // padding: const EdgeInsets.all(8),
          itemCount: count,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) {
            return const ShimmerWidget();
          },
        ),
      ],
    );
  }
}
