// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/customers_model.dart';
import 'package:order_now_android/model/dormitory_model.dart';
import 'package:order_now_android/view/admin/current_customer.dart';
import 'package:order_now_android/view/admin/dormitory_edit_page.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/animations/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class DormitoryEditListProvider extends ChangeNotifier {
  List<DormitoryDetails> dormitoryList = [];
  late bool availble;
  bool isLoading = true;
  //Firebase

  final CollectionReference dataRetriver =
      FirebaseFirestore.instance.collection('dormitory');

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
                print('room no ${mapofuserdetails['dormitoryno']}');
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
                    builder: (context) => DormitoryEditPage(
                      currentDormitoryData: mapofuserdetails,
                    ),
                  ),
                );

                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //       builder: (context) => AdminDormitoryBookPage(
                //             currentDormitoryData: mapofuserdetails,
                //           )),
                // );
              } else {
                // Room is not available, show a SnackBar

                loadCustomer(
                    context, mapofuserdetails['dormitoryno'], mapofuserdetails);

                /// ScaffoldMessenger.of(context).showSnackBar(
                //const SnackBar(
                //content: Text('Dormitory is Not Availble'),
                //duration:
                //  Duration(seconds: 3), // You can adjust the duration
                //),
                //);
                if (kDebugMode) {
                  print("availblity $test");
                }
                notifyListeners();
              }
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

  // creating New Room
  TextEditingController roomnocontoller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<FormState> formkey4fiealds =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownkey = GlobalKey<FormState>();

  bool isProcessing = false;

  bool areChangesMade = false;

  String currentSelectedfloor = '';

  bool currentSelectedBoolType = false;

  //for dropdowns
  bool ischangedfloor = false; //on change

  List<String> Flooritems = ['Ground Floor'];
  List<bool> Availability = [true, false];

  void FloorFinder(
    selectedValue,
  ) {
    currentSelectedfloor = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedfloor');
    } // getting the current value
  }

//boool check
  void AvalablityFinder(
    selectedValue,
  ) {
    currentSelectedBoolType = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedBoolType');
    } // getting the current value
  }

  void clearingfiealds() {
    roomnocontoller.clear();
    ratecontroller.clear();
  }

//Firebase

  //createing new room
  Future<void> CreateNewDormitory(
      {required String Rate,
      required String Floor,
      required String DormitoryNo,
      required bool isAvailable,
      required String imageURL}) async {
    try {
      // providerstatus = ProviderStatus.LOADING;
      notifyListeners();
      await dataRetriver.add({
        'dormitoryno': DormitoryNo,
        'perHeadRate': Rate,
        'floor': Floor,
        'isAvailable': isAvailable,
        'image': imageURL,
      }).then((value) {
        loadDormitorys();
        //    resetFilter();
        notifyListeners();
      });

      if (kDebugMode) {
        print('New dormitory document added to Firestore $DormitoryNo');
      }
    } catch (e) {
      //  providerstatus = ProviderStatus.ERROR;
      notifyListeners();
      if (kDebugMode) {
        print('Error creating new customer doc: $e');
      }
    }
  }

  //floating action on pressed //dialog ui
  Future<void> showAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      //  barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(canvasColor: Colors.white),
          child: AlertDialog(
              //  backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              title: Text(
                'Create New Dormitory',
                style: GoogleFonts.oswald(
                  fontSize: 20, //20 or 24?
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(41, 105, 52, 1),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formkey4fiealds,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room-No
                          const Text(
                            'Dormitory-No',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: testFormFieald(
                              roomnocontoller,
                              'Enter Dormitory-No',
                            ),
                          ),
                          const SizedBox(height: 13),
                          Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              key: dropdownkey,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Available',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null) {
                                              return "*required";
                                            }
                                            return null; // no error
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          onChanged: (value) {
                                            AvalablityFinder(value);

                                            if (kDebugMode) {
                                              print(value);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 18.0,
                                                    horizontal: 10.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color(0xFF7EC679),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color(0xFF7EC679),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            labelStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w800,
                                            ),
                                            hintText: 'Availblity',
                                            hintStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            fillColor: Colors.transparent,
                                          ),
                                          items: Availability.map((bool item) {
                                            return DropdownMenuItem<bool>(
                                              value: item,
                                              child: Text(item.toString()),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Floor',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.7,
                                        child: DropdownButtonFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "*required";
                                            }
                                            return null; // no error
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          onChanged: (value) {
                                            FloorFinder(value);

                                            if (kDebugMode) {
                                              print(value);
                                            }
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 18.0,
                                                    horizontal: 10.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color(0xFF7EC679),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Color(0xFF7EC679),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 2,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            labelStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w800,
                                            ),
                                            hintText: 'Floor',
                                            hintStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            fillColor: Colors.transparent,
                                          ),
                                          items: Flooritems.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(height: 13),
                          // Rate
                          const Text(
                            'Rate',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.9,
                            child: testFormFieald(
                              ratecontroller,
                              'Enter Rate',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 11),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              clearingfiealds();
                              notifyListeners();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 17, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                            ),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3.2,
                            child: ElevatedButton(
                              onPressed: isProcessing
                                  ? null
                                  : () async {
                                      if (formkey4fiealds.currentState!
                                              .validate() &&
                                          dropdownkey.currentState!
                                              .validate()) {
                                        try {
                                          isProcessing = true;

                                          if (kDebugMode) {
                                            print(roomnocontoller.text);

                                            print(
                                                'floor $currentSelectedfloor');
                                            print(
                                                'Avaialability$currentSelectedBoolType');
                                            print(ratecontroller.text);
                                          }

                                          // create the room
                                          await CreateNewDormitory(
                                                  Rate: ratecontroller.text,
                                                  Floor: currentSelectedfloor,
                                                  DormitoryNo:
                                                      roomnocontoller.text,
                                                  isAvailable:
                                                      currentSelectedBoolType,
                                                  imageURL: 'imageURL')
                                              .then(
                                                  (value) => clearingfiealds())
                                              .then((value) =>
                                                  Navigator.of(context).pop());
                                        } finally {
                                          isProcessing = false;
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(41, 105, 52, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                              child: Center(
                                child: isProcessing
                                    ? const SizedBox(
                                        height: 17,
                                        width: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color:
                                              Color.fromRGBO(253, 186, 63, 1),
                                        ),
                                      )
                                    : const Text(
                                        'Create',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget testFormFieald(
    TextEditingController controller,
    String Text,
  ) {
    return TextFormField(
      onChanged: (value) {
        areChangesMade = true;
        if (kDebugMode) {
          print(controller.text);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "*required";
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFF7EC679)),
          borderRadius: BorderRadius.circular(8.0),
        ), //its enables the outline border of textfieald
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFF7EC679)),
          borderRadius: BorderRadius.circular(8.0),
        ), //its maintain 's the same outline when we clicked it
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2,
              color: Colors.red), // its creates an red border around it
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2, color: Colors.red), //it maintain the red border
          borderRadius: BorderRadius.circular(8.0),
        ),

        filled: true,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w800),
        // labelText: 'Username',
        hintText: Text,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500),

        fillColor: Colors.transparent,
      ),
    );
  }

  //finding customer
  List<CustomerDetails> DormitoryCustomers = [];
  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

  Future<void> loadCustomer(BuildContext context, String DormitoryNo,
      Map<String, dynamic> currentRoomData) async {
    try {
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('roomnoORname', isEqualTo: DormitoryNo)
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
                  DormitoryEditPage(currentDormitoryData: currentRoomData)),
        );
      }
      //  print('The ${name} "s Address is updated');
    } catch (error) {
      //   print('The ${name} "s Address is not updated');
      print(error);
    }
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
