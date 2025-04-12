// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view_model/reception/customer_details_view_model.dart';
import 'package:provider/provider.dart';

class CustomerDetailEditpageProvider extends ChangeNotifier {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController peoplecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController checkINTimecontroller = TextEditingController();
  TextEditingController checkOUTTimecontroller = TextEditingController();
  TextEditingController CheckIndatecontroller = TextEditingController();
  TextEditingController Checkoutdatecontroller = TextEditingController();
  TextEditingController ratecontroller = TextEditingController();

  bool isProcessing = false;

  bool areChangesMade = false;

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

  late bool avilable;
  final GlobalKey<FormState> textformkey =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownformkey = GlobalKey<FormState>();

  // var roomformkey = GlobalKey<FormState>();

  //date &Time Picker
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

  ///for test

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

  //For dropdowns
  bool ischangedProof = false; //on change
  bool ischangedPurpose = false; //on change
  String proofInitialValue = '';
  String purposeInitialValue = '';

  List<String> Purposeitems = [
    'Travel',
    'Bussiness',
    'Special events',
    'Refreshment',
    'Other'
  ];

  List<String> Proofitems = ['Adhaar', 'VoterID', 'DrivingLicence', 'Other'];

  String currentSelectedproof = '';
  String currentSelectedPurpose = '';
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

  Widget testFormFieald(
      BuildContext context,
      TextEditingController controller,
      String HintText,
      TextInputType? KeyboardType,
      bool onTap,
      void Function()? onTapFunction,
      bool isAddress,
      bool isPhone) {
    return TextFormField(
        keyboardType: KeyboardType,
        onChanged: (value) {
          areChangesMade = true;
        },
        onTap: onTap
            ? () {
                Future.delayed(Duration.zero, onTapFunction);
                areChangesMade = true;
              }
            : null,
        validator: (value) {
          if (value!.isEmpty) {
            return "*required";
          }
          return null;
        },
        controller: controller,
        maxLines: isAddress ? 5 : 1, // if address tile adjusting the heigt
        minLines: isAddress ? 1 : null, // <-- SEE HERE,

        decoration: InputDecoration(
          prefixIcon: isPhone
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "+91",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500),
                  ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
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
        ));
  }

  // Firebase

  final CollectionReference customercollection =
      FirebaseFirestore.instance.collection('customers');

//Edit the details of a customer of rooms,dormitory,homestay.
  Future<void> UpdateCustomerData(BuildContext context,
      {required String uniqueID,
      required String oldname,
      required String Newname,
      required String address,
      required String mobilenumber,
      required String noofpeople,
      required String proof,
      required String purpose,
      required String checkindate,
      required String checkintime,
      required String checkoutdate,
      required String checkouttime,
      required String rate,
      required String catogary}) async {
    try {
      notifyListeners();
      QuerySnapshot querySnapshot = await customercollection
          .where('catogary', isEqualTo: catogary)
          .where('name', isEqualTo: oldname)
          .where('uniqueID', isEqualTo: uniqueID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first (and usually only) matching document
        var docid = querySnapshot.docs[0].id;

        customercollection

            // Use the retrieved document ID here
            .doc(docid)
            .update({
              'name': Newname,
              'mobileNumber': mobilenumber,
              'address': address,
              'proof': proof,
              'purpose': purpose,
              'checkindate': checkindate,
              'checkintime': checkintime,
              'checkoutdate': checkoutdate,
              'checkouttime': checkouttime,
              'rate': rate,
              'Noofpeople': noofpeople,
            })
            .then((value) {
              Provider.of<CustomerProvider>(context, listen: false)
                  .DetailsLoader(context);
              //await Provider.of<CustomerViewModel>(context, listen: false)
              //     .loadRoomCustomers();
              //   await Provider.of<CustomerViewModel>(context, listen: false)
              //   .loadDormitoryCustomers();
              //   await Provider.of<CustomerViewModel>(context, listen: false)
              //     .loadHomestayCustomers();
              // To refresh the page to get the realtime customer data on customer details page
              if (kDebugMode) {
                print(
                    'Customer data updated on firestore , customer id $uniqueID');
              }
              notifyListeners();
            })
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Customer Data Edited'),
                    duration:
                        Duration(seconds: 2), // You can adjust the duration
                  ),
                ))
            .then((value) => Navigator.of(context).pop());
      }

      // print('name changed ${name} "s  updated');
    } catch (error) {
      // print('The ${name} "s Address is not updated');
      if (kDebugMode) {
        print('Error here $error');
      }
    }
  }
}
