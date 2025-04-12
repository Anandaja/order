// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_now_android/view_model/admin/room_edit_list_provider.dart';
// import 'package:jnn_erp/view_model/admin/rooms_page_view_model.dart';
import 'package:provider/provider.dart';
//import 'package:path/path.dart';

class AdminEditRoomsProvider extends ChangeNotifier {
  TextEditingController roomnocontoller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<FormState> formkey4fiealds =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> floordropdown = GlobalKey<FormState>();
  final GlobalKey<FormState> key4TypeAvailbility = GlobalKey<FormState>();

  bool isProcessing = false;

  bool areChangesMade = false;

  String currentSelectedfloor = '';
  String currentSelectedroomType = '';
  bool currentSelectedBoolType = false;

  //for dropdowns
  bool ischangedfloor = false; //on change
  bool ischangedRoomtype = false; //on change
  bool ischangedAvailability = false; //on change

  String InitialFloorValue = '';
  String InitialRoomTypeValue = '';
  late bool AvailablityInitialValue;

  List<String> Flooritems = ['1st', '2nd', '3rd'];
  // List<bool> Availability = [true, false];
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

  //Firebase

  final CollectionReference Roomcollection =
      FirebaseFirestore.instance.collection('rooms');

//Edit the details of a customer of rooms,dormitory,homestay.
  Future<void> UpdateRoomData(
    BuildContext context, {
    required String oldRoomno,
    required String NewRoomno,
    required String roomtype,
    required String floor,
    required String rate,
    required bool isAvailable,
    required String image,
  }) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot =
          await Roomcollection.where('roomno', isEqualTo: oldRoomno).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first (and usually only) matching document
        var docid = querySnapshot.docs[0].id;

        Roomcollection

                // Use the retrieved document ID here
                .doc(docid)
            .update({
              'roomno': NewRoomno,
              'roomtype': roomtype,
              'floor': floor,
              'isAvailable': isAvailable,
              'rate': rate,
              'image': image
            })
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Room Data Edited'),
                    duration:
                        Duration(seconds: 2), // You can adjust the duration
                  ),
                ))
            .then((value) {
              Provider.of<RoomsEditListProvider>(context, listen: false)
                  .NotAvailablecheck = false; //for the not Availble filter
              Navigator.of(context).pop([
                Provider.of<RoomsEditListProvider>(context, listen: false)
                    .DetailssLoader(context)
              ]);
            }); //or resetfilter
      }

      // print('name changed ${name} "s  updated');
    } catch (error) {
      // print('The ${name} "s Address is not updated');
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
