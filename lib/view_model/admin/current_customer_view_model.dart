import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentCustomerProvider extends ChangeNotifier {
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

  final GlobalKey<FormState> textformkey =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownformkey = GlobalKey<FormState>();

  //for dropdowns
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

  Widget testFormFieald(TextEditingController controller, String Text,
      bool onTap, void Function()? onTapFunction, bool isAddress) {
    return TextFormField(
      readOnly: true,
      onTap: onTap
          ? () {
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
