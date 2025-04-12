import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RoomCreationProvider extends ChangeNotifier {
// for the image picker

  late File _image;

  Future imgFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await uploadFile(_image); // Wait for the upload to complete
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  String downloadURL = '';

  
  bool isimageAdded = false;
  bool _imageloading = false; //to load the image
  bool get isImageLoading =>
      _imageloading; //to update the bool value inside same function

  bool TestChangesMade = false;

  // Function to set image loading state
  void setImageLoading(bool loading) {
    _imageloading = loading;
    notifyListeners();
  }

  Future<String> uploadFile(File image) async {
    setImageLoading(true);
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    await ref.putFile(image);

    if (kDebugMode) {
      print('Image added');
    }
    downloadURL = await ref.getDownloadURL();
    if (kDebugMode) {
      print('am the thing $downloadURL');
    }

    isimageAdded = true;
    areChangesMade = true;
    // TestChangesMade = true;
    setImageLoading(false); //to stop the indicator
    notifyListeners();
    return downloadURL;
  }

  /*Future<String> uploadFile(File image) async {
    final fileName = basename(image.path);
    //final destination = 'files/$fileName';
    Reference ref =
        FirebaseStorage.instance.ref().child('AddedByAdmin/$fileName');
    // You can customize the file name or extension as needed

    await ref.putFile(image);

    print('Image added');
    downloadURL = await ref.getDownloadURL();
    print('am the thing $downloadURL');
    isimageAdded = true;
    notifyListeners();
    return downloadURL;
  }*/

  // creating New Room
  TextEditingController roomnocontoller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<FormState> formkey4fiealds =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownkey = GlobalKey<FormState>();

  bool isProcessing = false;

  bool areChangesMade = false;

  String currentSelectedfloor = '';
  String currentSelectedroomType = '';
  bool currentSelectedBoolType = false;

  //for dropdowns

  bool autovalidate = false;
  void autovalidation() {
    autovalidate = true;
    notifyListeners();
    //by callling like this we can update like initstate?
  }

  bool ischangedfloor = false; //on change
  bool ischangedRoomtype = false; //on change
  bool ischangedAvailability = false; //on change

  List<String> Flooritems = ['1st', '2nd', '3rd'];
  List<bool> Availability = [true, false];
  List<String> Roomtype = ['Double Coat', 'Four bed', 'Six cot'];

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

  void TypeFinder(
    selectedValue,
  ) {
    currentSelectedroomType = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedroomType');
    } // getting the current value
  }

  void clearingfiealds() {
    roomnocontoller.clear();
    ratecontroller.clear();
  }

//Firebase

  final CollectionReference Roomcollection =
      FirebaseFirestore.instance.collection('rooms');

  //createing new room
  Future<void> CreateNewRoom(
      {required String Rate,
      required String roomtype,
      required String Floor,
      required String Roomno,
      required bool isAvailable,
      required String imageURL}) async {
    try {
      // providerstatus = ProviderStatus.LOADING;
      notifyListeners();
      await Roomcollection.add({
        'roomtype': roomtype,
        'roomno': Roomno,
        'rate': Rate,
        'floor': Floor,
        'isAvailable': isAvailable,
        'image': imageURL,
      }).then((value) {
        //  resetFilter();
        notifyListeners();
      });

      if (kDebugMode) {
        print('New Room document added to Firestore $Roomno');
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
                'Create New ROOM',
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
                            'Room-No',
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
                              'Enter Room-No',
                            ),
                          ),
                          const SizedBox(height: 13),
                          Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              key: dropdownkey,
                              child: Column(
                                children: [
                                  //roomtype
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Room-Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      child: DropdownButtonFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "*required";
                                          }
                                          return null; // no error
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_sharp),
                                        onChanged: (value) {
                                          TypeFinder(value);
                                          ischangedRoomtype = true;
                                          areChangesMade = true;
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
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w800,
                                          ),
                                          hintText: 'Select Room Type',
                                          hintStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          fillColor: Colors.transparent,
                                        ),
                                        items: Roomtype.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  //Availbility
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  Row(
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.3,
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (value == null) {
                                                  return "*required";
                                                }
                                                return null; // no error
                                              },
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              onChanged: (value) {
                                                AvalablityFinder(value);
                                                ischangedAvailability = true;
                                                areChangesMade = true;
                                                if (kDebugMode) {
                                                  print(value);
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 18.0,
                                                        horizontal: 10.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                hintText: 'Availblity',
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                fillColor: Colors.transparent,
                                              ),
                                              items:
                                                  Availability.map((bool item) {
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.3,
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "*required";
                                                }
                                                return null; // no error
                                              },
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              onChanged: (value) {
                                                FloorFinder(value);
                                                ischangedfloor = true;
                                                areChangesMade = true;
                                                if (kDebugMode) {
                                                  print(value);
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 18.0,
                                                        horizontal: 10.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                hintText: 'Floor',
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                fillColor: Colors.transparent,
                                              ),
                                              items:
                                                  Flooritems.map((String item) {
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
                                  )
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
                                                'Type $currentSelectedroomType');
                                            print(
                                                'floor $currentSelectedfloor');
                                            print(
                                                'Avaialability$currentSelectedBoolType');
                                            print(ratecontroller.text);
                                          }

                                          // create the room
                                          await CreateNewRoom(
                                                  Rate: ratecontroller.text,
                                                  roomtype:
                                                      currentSelectedroomType,
                                                  Floor: currentSelectedfloor,
                                                  Roomno: roomnocontoller.text,
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
      keyboardType: TextInputType.number,
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
}
