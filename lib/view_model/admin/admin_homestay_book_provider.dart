// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view/utilitie/text_to_image.dart';
// import 'package:jnn_erp/view_model/reception/customer_details_view_model.dart';
// import 'package:jnn_erp/view_model/reception/homestay_view_model.dart';
// import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminHomestayBookProvider extends ChangeNotifier {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController peoplecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController checkINTimecontroller = TextEditingController();
  TextEditingController checkOUTTimecontroller = TextEditingController();
  TextEditingController CheckIndatecontroller = TextEditingController();
  TextEditingController Checkoutdatecontroller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //for scaffold

  String generateUniqueID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  late bool avilable;
  final GlobalKey<FormState> textformkey =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownformkey = GlobalKey<FormState>();

  bool isProcessing = false;
  bool onchanged = false;

  void clearingfiealds() {
    namecontroller.clear();
    peoplecontroller.clear();
    phonenumbercontroller.clear();
    addresscontroller.clear();
    checkINTimecontroller.clear();
    CheckIndatecontroller.clear();
    checkOUTTimecontroller.clear();
    Checkoutdatecontroller.clear();
    ratecontroller.clear();
    if (kDebugMode) {
      print('Textfiealds cleared');
    }
  }

  //date &Time Picker
  String initialCheckinDate = '';
  String initialCheckinTime = '';
  String initiaCheckoutDate = '';
  String initialCheckoutTime = '';

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2023);
  DateTime last = DateTime(2050);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now(); //for check in &check out
  // final TimeOfDay fixedTime = TimeOfDay(hour: 1, minute: 0);
//date picker
  Future CheckinDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      String Date = date.toLocal().toString().split(" ")[0];
      CheckIndatecontroller.text = Date;
      if (kDebugMode) {
        print('check in date $Date');
      }
      notifyListeners();
    }
  }
  //check out date picker

  Future CheckoutDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      String Date = date.toLocal().toString().split(" ")[0];
      Checkoutdatecontroller.text = Date;
      if (kDebugMode) {
        print('checkout date $Date');
      }
      notifyListeners();
    }
  }

//time picker for check in
  Future CheckinTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      // Format the time using 12-hour format with AM/PM
      String formattedTime = DateFormat('hh:mm a')
          .format(DateTime(2021, 1, 1, time.hour, time.minute));

      checkINTimecontroller.text = formattedTime;
      if (kDebugMode) {
        print("check in time $formattedTime");
      }
      notifyListeners();
    }
  }

//for testing the auto disppear
  Future CheckoutTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      // Format the time using 12-hour format with AM/PM
      String formattedTime = DateFormat('hh:mm a')
          .format(DateTime(2021, 1, 1, time.hour, time.minute));

      checkOUTTimecontroller.text = formattedTime;
      if (kDebugMode) {
        print("check in time $formattedTime");
      }
      notifyListeners();
    }
  }

//for check out
  Future CheckoutFixedTimePicker(BuildContext context) async {
    // Set fixed time to 1:00 PM //can we use from data base?
    var fixedTime = const TimeOfDay(hour: 13, minute: 0);

    // Show the time picker
    var time = await showTimePicker(context: context, initialTime: fixedTime);

    if (time != null) {
      // Use the fixed time (1:00 PM) and format it

      String formattedTime = DateFormat('hh:mm a')
          .format(DateTime(2021, 1, 1, fixedTime.hour, fixedTime.minute));

      checkOUTTimecontroller.text = formattedTime;
      // Handle the selected time (if needed)
      if (kDebugMode) {
        print('check out Time: $formattedTime');
      }
      notifyListeners();
    }
  }

  //test
  late String currentSelectedproof;
  late String currentSelectedPurpose;
  //For the on change() of DropdownFomFieald;
  void ProofFinder(
    selectedValue,
  ) {
    currentSelectedproof = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedproof');
    } // getting the current value
  }

  //for the on change of dropdownfrom fieald purpose

  void PurposeFinder(
    selectedValue,
  ) {
    currentSelectedPurpose = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedPurpose');
    } // getting the current value
  }

  final CollectionReference Homestaycollection =
      FirebaseFirestore.instance.collection('homestay');

  //Update the Availability of rooms
  Future<void> UpdateAvailbility(BuildContext context,
      {required String Homestayname, required bool Availbility}) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot =
          await Homestaycollection.where('name', isEqualTo: Homestayname).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first (and usually only) matching document
        var docid = querySnapshot.docs[0].id;

        Homestaycollection
                // Use the retrieved document ID here
                .doc(docid)
            .update({'isAvailable': Availbility}).then((value) {
          // Provider.of<HomestayProvider>(context, listen: false)
          //     .loadHomestays(); // To refresh the page to get the realtime homestay data data on all homestay page
          // Provider.of<CustomerProvider>(context, listen: false)
          //     .loadHomestayCustomers(
          //         context); //for the refresh of customerdetails page Homestay section
          if (kDebugMode) {
            print('Homestay availability changed to $Availbility');
          }
        });
      }

      //  print('availbility set to ${Availbility} "s Address is updated');
    } catch (error) {
      // print('The ${name} "s Address is not updated');
      if (kDebugMode) {
        print(error);
      }
    }
  }

  //bo0k homestay

  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

  Future<void> BookHomestay(
    String uniqueID,
    String Rate,
    String roomnoORname,
    String name,
    String address,
    String mobilenumber,
    String purpose,
    String checkInTime,
    String checkInDate,
    String checkOutTime,
    String checkOutDate,
    String proof,
    String noofpeople,
    String catogary,
    bool isCustomerinRoom,
  ) async {
    try {
      //here no roomtype
      notifyListeners();
      await customercollection.add({
        'uniqueID': uniqueID,
        'rate': Rate,
        'roomnoORname': roomnoORname,
        'name': name,
        'address': address,
        'mobileNumber': mobilenumber,
        'proof': proof,
        'purpose': purpose,
        'checkindate': checkInDate,
        'checkintime': checkInTime,
        'checkoutdate': checkOutDate,
        'checkouttime': checkOutTime,
        'Noofpeople': noofpeople,
        'catogary': catogary,
        'isCustomerinRoom': isCustomerinRoom,
      }).then((value) {
        notifyListeners();
      });

      if (kDebugMode) {
        print('New costomer document added to Firestore');
      }
      if (kDebugMode) {
        print(' customer id $uniqueID');
      }
    } catch (e) {
      //  providerstatus = ProviderStatus.ERROR;
      notifyListeners();
      if (kDebugMode) {
        print('Error creating new customer doc: $e');
      }
    }
  }

  bool autovalidate = false;

  void autovalidation() {
    autovalidate = true;
    notifyListeners();
    //by callling like this we can update like initstate?
  }

  Widget testFormFieald(
      BuildContext? context,
      TextEditingController controller,
      String HintText,
      TextInputType? KeyboardType,
      bool onTap,
      void Function()? onTapFunction,
      bool isAddress,
      bool isPhone) {
    return TextFormField(
      keyboardType: KeyboardType,
      onTap: onTap
          ? () {
              onchanged = true; //here
              Future.delayed(Duration.zero, onTapFunction);
            }
          : null,
      validator: (value) {
        if (value!.isEmpty) {
          return "*required";
        }
        return null;
      },
      maxLines: isAddress ? 5 : 1, // if address tile adjusting the heigt
      minLines: isAddress ? 1 : null, // <-- SEE HERE,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: isPhone
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "+91",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500),
                ),
              )
            : null,

        prefixIconConstraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        suffixIcon: isAddress
            ? Tooltip(
                message: 'Extract address from proof',
                child: IconButton(
                    onPressed: () {
                      //image to text
                      // show(context);
                      showDialog(
                          context: context!,
                          builder: (context) => imagePickAlert(
                              context: context,
                              onCameraPressed: () async {
                                final imgPath =
                                    await obtainImage(ImageSource.camera);
                                print('path $imgPath');

                                if (imgPath == null) return;
                                processImage(imgPath, context);

                                Navigator.of(context).pop();
                              },
                              onGalleryPressed: () async {
                                final imgPath =
                                    await obtainImage(ImageSource.gallery);
                                print('path $imgPath');

                                if (imgPath == null) return;
                                processImage(imgPath, context);

                                Navigator.of(context).pop();
                              }));
                    },
                    icon: textGenarating
                        ? SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : Image.asset(
                            'assets/images/text2image.png',
                            height: 35,
                            width: 35,
                          )),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

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
        hintText: HintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500),

        fillColor: Colors.transparent,
      ),
    );
  }

  //text to image

  ImagePicker picker = ImagePicker();

  // ignore: unused_field
  RecognitionResponse? _response;

  final ITextRecognizer _recognizer = MLKitTextRecognizer();

  // @override
  // void dispose() {
  //   super.dispose();
  //   if (_recognizer is MLKitTextRecognizer) {
  //     (_recognizer as MLKitTextRecognizer).dispose();
  //   }
  // }

  //obtaining the image
  Future<String?> obtainImage(ImageSource source) async {
    final file = await picker.pickImage(source: source);
    return file?.path;
  }

  //processing the image
  bool textGenarating = false;
  // void processImage(String imgPath) async {
  //   textGenarating = true;
  //   notifyListeners();

  //   final recognizedText = await _recognizer.processImage(imgPath);
  //   print("text : $recognizedText");
  //   _response =
  //       RecognitionResponse(imgPath: imgPath, recognizedText: recognizedText);

  //   addresscontroller.text = recognizedText;
  //   textGenarating = false;
  //   notifyListeners();
  // }
  void processImage(String imgPath, BuildContext context) async {
    try {
      textGenarating = true;
      notifyListeners();

      final recognizedText = await _recognizer.processImage(imgPath);

      if (recognizedText.isEmpty) {
        print('no text from image $recognizedText or ');

        textGenarating = false;
        print('Hi am after text genarating');
        notifyListeners();
        print('Hi am after text listeners');
        showNoTextSnackBar(context); // Call the snack bar here
        print('Hi am after text snack');
      } else {
        print("text : $recognizedText");
        _response = RecognitionResponse(
            imgPath: imgPath, recognizedText: recognizedText);

        addresscontroller.text = recognizedText;

        textGenarating = false;
        notifyListeners();
      }
    } catch (e) {
      print('error on proccessimage $e');
    }
  }

  //if no text from image returns snackbar
  void showNoTextSnackBar(BuildContext context) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text('No text found in the image.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//dialog fro text to image
Widget imagePickAlert({
  void Function()? onCameraPressed,
  void Function()? onGalleryPressed,
  required BuildContext context,
}) {
  return AlertDialog(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    title: const Text(
      "Select image",
      style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.w600),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text(
            "Camera",
          ),
          onTap: onCameraPressed,
        ),
        //  Divider(),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text(
            "Gallery",
          ),
          onTap: onGalleryPressed,
        ),
      ],
    ),
    actions: [
      TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(0, 255, 255, 255))),
        child: const Text(
          'back',
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
