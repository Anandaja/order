// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/model/rooms_model.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class RoomReservationListProvider extends ChangeNotifier {
  late AnimationController addToCartPopUpAnimationController;

  bool isFetching = true; //to load the page

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
    // 'Available',
    // 'NotAvailable',
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
      // case 4:
      //   Available(true); //Load Available rooms only
      //   notifyListeners(); //updates the ui
      //   break;
      // case 5:
      //   NotAvailable(false); //not availble rooms only
      //   notifyListeners(); //updates the ui
      //   break;
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

//   //for Checking availbility

//   void Available(bool isAvailble) {
//     if (kDebugMode) {
//       print('Filtering rooms by type: $isAvailble');
//     }
//     for (var room in Floor1List) {
//       if (kDebugMode) {
//         print('Room Type: ${room.isAvailable}');
//       }
//     }

//     // Check if the original data is available
//     if (originalList1stFloor.isEmpty ||
//         originalList2ndFloor.isEmpty ||
//         originalList3rdFloor.isEmpty) {
//       // If not, store the original list before filtering for both floors
//       originalList1stFloor = List.from(Floor1List);
//       originalList2ndFloor = List.from(Floor2List);
//       originalList3rdFloor = List.from(Floor3List);
//     }

//     // Filter  1st floor list
//     List<RoomDetails> filteredList1stFloor =
//         originalList1stFloor.where((room) => room.isAvailable == true).toList();

//     // Filter 2nd floor list
//     List<RoomDetails> filteredList2ndFloor =
//         originalList2ndFloor.where((room) => room.isAvailable == true).toList();
//     // Filter 3rd floor list
//     List<RoomDetails> filteredList3rdFloor =
//         originalList3rdFloor.where((room) => room.isAvailable == true).toList();

//     if (filteredList1stFloor.isNotEmpty ||
//         filteredList2ndFloor.isNotEmpty ||
//         filteredList3rdFloor.isNotEmpty) {
//       Floor1List = filteredList1stFloor;
//       Floor2List = filteredList2ndFloor;
//       Floor3List = filteredList3rdFloor;

//       if (kDebugMode) {
//         print("1st Floor: ${filteredList1stFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("2nd Floor: ${filteredList2ndFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("3rd Floor ${filteredList3rdFloor.length} rooms");
//       }
//       notifyListeners();
//     }
//   }

//   bool NotAvailablecheck = false;

// //not Aavailble
//   void NotAvailable(bool isAvailble) {
//     if (kDebugMode) {
//       print('Filtering rooms by type: $isAvailble');
//     }
//     for (var room in Floor1List) {
//       if (kDebugMode) {
//         print('Room Type: ${room.isAvailable}');
//       }
//     }

//     // Check if the original data is available
//     if (originalList1stFloor.isEmpty ||
//         originalList2ndFloor.isEmpty ||
//         originalList3rdFloor.isEmpty) {
//       // If not, store the original list before filtering for both floors
//       originalList1stFloor = List.from(Floor1List);
//       originalList2ndFloor = List.from(Floor2List);
//       originalList3rdFloor = List.from(Floor3List);
//     }

//     // Filter  1st floor list
//     List<RoomDetails> filteredList1stFloor = originalList1stFloor
//         .where((room) => room.isAvailable == false)
//         .toList();

//     // Filter  2nd floor list
//     List<RoomDetails> filteredList2ndFloor = originalList2ndFloor
//         .where((room) => room.isAvailable == false)
//         .toList();

//     // Filter  2nd floor list
//     List<RoomDetails> filteredList3rdFloor = originalList3rdFloor
//         .where((room) => room.isAvailable == false)
//         .toList();

//     if (filteredList1stFloor.isNotEmpty ||
//         filteredList2ndFloor.isNotEmpty ||
//         filteredList3rdFloor.isNotEmpty) {
//       Floor1List = filteredList1stFloor;
//       Floor2List = filteredList2ndFloor;
//       Floor3List = filteredList3rdFloor;

//       if (kDebugMode) {
//         print("1st Floor: ${filteredList1stFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("2nd Floor: ${filteredList2ndFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("3rd Floor ${filteredList3rdFloor.length} rooms");
//       }

//       notifyListeners();
//     } else if (filteredList1stFloor.isEmpty &&
//         filteredList2ndFloor.isEmpty &&
//         filteredList3rdFloor.isEmpty) {
//       Floor1List = filteredList1stFloor;
//       Floor2List = filteredList2ndFloor;
//       Floor3List = filteredList3rdFloor;

//       NotAvailablecheck = true;
//       if (kDebugMode) {
//         print("1st Floor: ${filteredList1stFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("2nd Floor: ${filteredList2ndFloor.length} rooms");
//       }
//       if (kDebugMode) {
//         print("3rd Floor ${filteredList3rdFloor.length} rooms");
//       }

//       print('No data on not available');
//       //   notifyListeners();
//     }
//   }

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
            //  backgroundColor:
            //
            title: const Text(
              'Tap To Filter',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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

//make this function as load always to  get updated data.
  // void DetailsLoader(DateTime currentdate) {
  //   // NotAvailablecheck
  //   //     ? Icon(
  //   //         Icons.ac_unit_outlined,
  //   //         color: Colors.black,
  //   //         size: 50,
  //   //       )
  //   //     :
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     if (Floor1List.isEmpty && Floor2List.isEmpty && Floor3List.isEmpty) {
  //       // If detailedList is empty, load all details it useful for filtering otherwise we need to click on thae All chip
  //       await loaddetails(); //1 flor
  //       await floor2(); //2 flor
  //       await floor3(); //3 flor
  //       await getReservedDocs(currentDate: currentdate);
  //       isFetching = false;
  //     }

  //     // if (GeneralList.isEmpty) {
  //     //   await LoadFullRooms();
  //     //   isFetching = false;
  //     // }
  //     notifyListeners();
  //   });
  // }

  void DetailssLoader(DateTime currentdate) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isFetching = true;
        notifyListeners();

        await loaddetails(); //1 flor
        await floor2(); //2 flor
        await floor3(); //3 flor
        await getReservedDocs(currentDate: currentdate);

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

//just for testing
  List<RoomDetails> GeneralList =
      []; //to load all list  if that fllor seperated list not works

  Future<void> LoadFullRooms() async {
    try {
      notifyListeners();
      // final snapshot = dataRetriver.get(); is it works??
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      // print('check here${snapshot.docs.length}');
      final roomDetails =
          snapshot.docs.map((doc) => RoomDetails.fromJson(doc.data())).toList();
      //print('noobtest${userDetails[0]}');
      // Floor1List = roomDetails.where((room) => room.floor == '1st').toList();
      // print('boomerang ${detailedList[0]}');
      GeneralList = roomDetails;
      // print('jobb ${userDetails.length}');
      GeneralList.sort((a, b) => a.roomno.compareTo(
          b.roomno)); //filtering rooms on the ascending order of room no
      if (GeneralList.isEmpty) {
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

  //Reserving room,
  //the user can add the rooms to reserve this list is that (Below)

  List ReserveRoomList = [];

  void AddingRoomToList(Map<String, dynamic> mapofuserdetails) {
    //
    Map<String, dynamic> RoomDetails = {};

    // String roomnoORname = mapofuserdetails['roomno'];
    // String roomtype = mapofuserdetails['roomtype'];
    // String image = mapofuserdetails['image'];
    // String rate = mapofuserdetails['rate'];
    // String floor = mapofuserdetails['floor'];
    // bool isAvailable = mapofuserdetails['isAvailable'];
    RoomDetails.addAll({
      'roomnoORname': mapofuserdetails['roomno'],
      'roomtype': mapofuserdetails['roomtype'],
      'image': mapofuserdetails['image'],
      'rate': mapofuserdetails['rate'],
      'floor': mapofuserdetails['floor'],
      'isAvailable': mapofuserdetails['isAvailable']
    });
    print("RoomDatas map $RoomDetails");

    ReserveRoomList.add(RoomDetails);
    notifyListeners();
    print("Resereve room list $ReserveRoomList");
  }

  int? testIndex;

  //int indexfind()
  //return bool if there is any addition on CartList(That made First time)
  bool checkIfAddedToCartList(Map<String, dynamic> mapofuserdetails) {
    // Replace this with your logic to check if the food item is in the cart
    // You might need to compare the 'fooddetails' with items in 'OrderCartList'
    // and return true if it's already present.
    // Example assuming 'OrderCartList' is a List<Map<String, dynamic>>:

    for (dynamic item in ReserveRoomList) {
      if (item['roomnoORname'] == mapofuserdetails['roomno']) {
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
    isAddedToReserveRoom = checkIfAddedToCartList(mapofuserdetails);
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
                  RoomNoList.contains(mapofuserdetails['roomno'])
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
                                  AddingRoomToList(mapofuserdetails);
                                  addToCartPopUpAnimationController
                                      .forward(); //playing animation
                                  // ReserveRoomList.add(mapofuserdetails);
                                  notifyListeners();
                                  print(
                                      "Length of the list ${ReserveRoomList.length}");
                                  // print(ReserveRoomList);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(41, 105, 52, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                  child: const Icon(
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

//
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
          .where('catogary', isEqualTo: 'rooms')
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
            String roomno = TestReservation[index]['roomnoORname'];

            print("Hi from reservation doc $roomno");
            //here i is the index
            // for (dynamic room in TestReservation) {
            //   String roomno = room['roomno'];
            //   print
            // }
            // RoomNoList.add(roomno);
            addingtolist(roomno);
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

//some Ui parts
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
