import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomestayCreationProvider extends ChangeNotifier {
//for imagepicker

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
  TextEditingController namecontoller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<FormState> formkey4fiealds =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownkey = GlobalKey<FormState>();

  bool isProcessing = false;

  bool areChangesMade = false;

  bool currentSelectedBoolType = false;

  //for dropdowns

  bool autovalidate = false;
  void autovalidation() {
    autovalidate = true;
    notifyListeners();
    //by callling like this we can update like initstate?
  }

  bool ischangedAvailability = false; //on change

  List<String> Flooritems = ['Ground Floor'];
  List<bool> Availability = [true, false];

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
    namecontoller.clear();
    ratecontroller.clear();
  }

//Firebase

  final CollectionReference homestaycollection =
      FirebaseFirestore.instance.collection('homestay');

  Future<void> CreateNewHomestay(
      {required String Rate,
      required String HomestayName,
      required bool isAvailable,
      required String imageURL}) async {
    try {
      // providerstatus = ProviderStatus.LOADING;
      notifyListeners();
      await homestaycollection.add({
        'name': HomestayName,
        'rate': Rate,
        'isAvailable': isAvailable,
        'image': imageURL,
      }).then((value) {
        notifyListeners();
      });

      if (kDebugMode) {
        print('New Homestay document added to Firestore $HomestayName');
      }
    } catch (e) {
      //  providerstatus = ProviderStatus.ERROR;
      notifyListeners();
      if (kDebugMode) {
        print('Error creating new Homestay doc: $e');
      }
    }
  }

//formfiealds
  Widget testFormFieald(
    TextInputType? keyboardType,
    TextEditingController controller,
    String Text,
  ) {
    return TextFormField(
      keyboardType: keyboardType,
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
