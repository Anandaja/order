// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:jnn_erp/view_model/admin/dormitory_admin_view_model.dart';
import 'package:order_now_android/view_model/admin/dormitory_edit_list_provider.dart';
import 'package:provider/provider.dart';

class AdminDormitoryEditProvider extends ChangeNotifier {
  TextEditingController dormitorynocontoller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<FormState> formkey4fiealds =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> floorkey = GlobalKey<FormState>();
  final GlobalKey<FormState> Availbilitykey = GlobalKey<FormState>();

  bool isProcessing = false;

  bool areChangesMade = false;

  String currentSelectedfloor = '';

  bool currentSelectedBoolType = false;

  //for dropdowns
  bool ischangedfloor = false; //on change

  bool ischangedAvailability = false; //on change

  String InitialFloorValue = '';

  late bool AvailablityInitialValue;

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
// add to an specific file
  /*Future<String> uploadFile(File image) async {
    final fileName = basename(image.path);
    //final destination = 'files/$fileName';
    Reference ref =
        FirebaseStorage.instance.ref().child('DormitoryImages/$fileName');
    // You can customize the file name or extension as needed

    await ref.putFile(image);

    print('Image added');
    downloadURL = await ref.getDownloadURL();
    print('am the thing $downloadURL');
    isimageAdded = true;
    notifyListeners();
    return downloadURL;
  }*/

//roomno&rate form fiealds ui
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

  final CollectionReference Dormitorycollection =
      FirebaseFirestore.instance.collection('dormitory');

//Edit the details of a customer of rooms,dormitory,homestay.
  Future<void> UpdateDormitoryData(
    BuildContext context, {
    required String oldDormitoryno,
    required String NewDormitoryno,
    required String floor,
    required String rate,
    required bool isAvailable,
    required String image,
  }) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot = await Dormitorycollection.where(
              'dormitoryno',
              isEqualTo: oldDormitoryno)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first (and usually only) matching document
        var docid = querySnapshot.docs[0].id;

        Dormitorycollection
                // Use the retrieved document ID here
                .doc(docid)
            .update({
              'dormitoryno': NewDormitoryno,
              'floor': floor,
              'isAvailable': isAvailable,
              'perHeadRate': rate,
              'image': image
            })
            // .then((value) {
            //   Provider.of<DormitoryAdminProvider>(context, listen: false)
            //       .loadDormitorys();
            //   if (kDebugMode) {
            //     print(
            //         'Room data updated on firestore , roomno $NewDormitoryno');
            //   }
            //   notifyListeners();
            // })
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dormitory Data Edited'),
                    duration:
                        Duration(seconds: 2), // You can adjust the duration
                  ),
                ))
            .then((value) => Navigator.of(context).pop([
                  Provider.of<DormitoryEditListProvider>(context, listen: false)
                      .DetailsLoader()
                ]));
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
