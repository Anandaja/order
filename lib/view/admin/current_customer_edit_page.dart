import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/current_customer_edit_provider.dart';

import 'package:provider/provider.dart';

class CurrentCustomerEditPage extends StatefulWidget {
  const CurrentCustomerEditPage({
    super.key,
    required this.currentCustomerData,
  });
  final Map<String, dynamic> currentCustomerData;

  @override
  CurrentCustomerEditPageState createState() => CurrentCustomerEditPageState();
}

class CurrentCustomerEditPageState extends State<CurrentCustomerEditPage> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    final provider =
        Provider.of<CurrentCustomerEditProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.namecontroller.text = widget.currentCustomerData['name'];
      provider.peoplecontroller.text = widget.currentCustomerData['Noofpeople'];
      provider.phonenumbercontroller.text =
          widget.currentCustomerData['mobileNumber'];
      provider.addresscontroller.text = widget.currentCustomerData['address'];
      provider.CheckIndatecontroller.text =
          widget.currentCustomerData['checkindate'];
      provider.checkINTimecontroller.text =
          widget.currentCustomerData['checkintime'];
      provider.Checkoutdatecontroller.text =
          widget.currentCustomerData['checkoutdate'];
      provider.checkOUTTimecontroller.text =
          widget.currentCustomerData['checkouttime'];
      provider.ratecontroller.text = widget.currentCustomerData['rate'];
      provider.proofInitialValue = widget.currentCustomerData['proof'];
      provider.purposeInitialValue = widget.currentCustomerData['purpose'];
      if (kDebugMode) {
        print(
            'hey am  ${widget.currentCustomerData['catogary']} ${provider.purposeInitialValue}');
        print('My uniqueID is ${widget.currentCustomerData['uniqueID']}');
      }
    });

    super.initState();
  }

  //exit pop from the page
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            title: const Text('Oops! Editing not finished!'),
            content:
                const Text('Leaving now will clear all data. Are you sure?'),
            actions: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(0, 255, 255, 255))),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(0, 255, 255, 255))),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Provider.of<CurrentCustomerEditProvider>(context,
                          listen: false)
                      .ischangedPurpose = false;
                  Provider.of<CurrentCustomerEditProvider>(context,
                          listen: false)
                      .ischangedProof = false;
                  Provider.of<CurrentCustomerEditProvider>(context,
                          listen: false)
                      .clearingfiealds();
                  Provider.of<CurrentCustomerEditProvider>(context,
                          listen: false)
                      .areChangesMade = false;
                }, // is it works?  androis ios?
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Provider.of<CurrentCustomerEditProvider>(context, listen: false)
                    .ischangedPurpose = false;
                Provider.of<CurrentCustomerEditProvider>(context, listen: false)
                    .ischangedProof = false;
                Provider.of<CurrentCustomerEditProvider>(context, listen: false)
                    .clearingfiealds();
                Provider.of<CurrentCustomerEditProvider>(context, listen: false)
                    .areChangesMade = false;
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          elevation: 10,
          shadowColor: const Color.fromARGB(255, 0, 0, 0),
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
          title: Text(
            'Edit Details',
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Consumer<CurrentCustomerEditProvider>(
            builder: (context, connector, child) {
          //   bool isRoom = false;
          bool isDormitory = false;
          bool isHomestay = false;
          String catogary = widget.currentCustomerData['catogary'];
          if (catogary == 'homestay') {
            isHomestay = true;
          } else if (catogary == 'dormitory') {
            isDormitory = true;
          }
          /* else{
            isRoom=true;
          }*/
          /*   switch (catogary) {
            case 'rooms':
              catogary == 'rooms';
              isRoom = true;
              break;
            case 'dormitory':
              catogary == 'dormitory';
              isDormitory = true;
              break;
            case 'homestay':
              catogary == 'homestay';
              isHomestay = true;
              break;
          }*/
          return ListView(
            padding: const EdgeInsets.only(top: 30),
            //  physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,

            //   mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  //   physics: const NeverScrollableScrollPhysics(),
                  // shrinkWrap: true, // This is important ⬇️
                  // shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: isDormitory
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 17),
                                  child: Column(
                                    children: [
                                      Text('DORMITORY',
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: const TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 85),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              //  letterSpacing: 2.8
                                              letterSpacing: 1,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      Baseline(
                                        baseline: 0.0,
                                        baselineType: TextBaseline.alphabetic,
                                        child: Container(
                                          child: Text(
                                            '${widget.currentCustomerData['roomnoORname']}',
                                            style: GoogleFonts.nunitoSans(
                                              textStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    90, 171, 96, 1),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 41,
                                                letterSpacing: 4.7,
                                                height:
                                                    1.0, // Adjust the line height as needed
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : isHomestay
                                  ? Text(
                                      '${widget.currentCustomerData['roomnoORname']}',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 17),
                                      child: Column(
                                        children: [
                                          Text('ROOMNO',
                                              style: GoogleFonts.nunitoSans(
                                                textStyle: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 85),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  //  letterSpacing: 2.8
                                                  letterSpacing: 3.6,
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Baseline(
                                            baseline: 0.0,
                                            baselineType:
                                                TextBaseline.alphabetic,
                                            child: Container(
                                              child: Text(
                                                '${widget.currentCustomerData['roomnoORname']}',
                                                style: GoogleFonts.nunitoSans(
                                                  textStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        90, 171, 96, 1),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 40.5,
                                                    letterSpacing: 4.7,
                                                    height:
                                                        1.0, // Adjust the line height as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          // child: Text(
                          //   isDormitory
                          //       ? 'Dormitory NO ${widget.currentCustomerData['roomnoORname']}'
                          //       : isHomestay
                          //           ? '${widget.currentCustomerData['roomnoORname']}'
                          //           : 'ROOM NO ${widget.currentCustomerData['roomnoORname']}',
                          //   style: const TextStyle(
                          //       color: Color.fromARGB(255, 0, 0, 0),
                          //       fontWeight: FontWeight.w600,
                          //       fontSize: 19),
                          // ),
                        ),
                        isHomestay
                            ? Container() //try to add padding if its homestay
                            : Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    isDormitory
                                        ? Container()
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                21,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    30.0), //Use this code to make rounded corners
                                                color: const Color.fromRGBO(
                                                    253, 185, 63, 1)),
                                            child: Center(
                                              child: Text(
                                                widget.currentCustomerData[
                                                    'roomtype'],
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            )),
                                    isDormitory
                                        ? Container()
                                        : const SizedBox(
                                            height: 15,
                                          ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                30.0), //Use this code to make rounded corners
                                            color: const Color.fromRGBO(
                                                68, 142, 74, 1)),
                                        child: Center(
                                          child: Text(
                                            '${widget.currentCustomerData['floor']}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'assets/images/singlecustomer.png',
                              fit: BoxFit.contain,
                            )),
                        const SizedBox(
                          width: 2,
                        ),
                        const Text(
                          'Customer Details',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: connector.textformkey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                //name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Name',
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
                                                1.9,
                                        child: connector.testFormFieald(
                                            context,
                                            connector.namecontroller,
                                            'Enter Name',
                                            TextInputType.text,
                                            false,
                                            null,
                                            false,
                                            false)),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'No of people',
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
                                                3, // Adjust the width as needed
                                        child: connector.testFormFieald(
                                            context,
                                            connector.peoplecontroller,
                                            'Enter Count',
                                            TextInputType.number,
                                            false,
                                            null,
                                            false,
                                            false)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            //phonenumber Fieald
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                connector.testFormFieald(
                                    context,
                                    connector.phonenumbercontroller,
                                    'Enter Mobile Number',
                                    TextInputType.phone,
                                    false,
                                    null,
                                    false,
                                    true)
                              ],
                            ),
                            const SizedBox(
                              height: 11,
                            ), //Address fieald
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                connector.testFormFieald(
                                    context,
                                    connector.addresscontroller,
                                    'Enter address',
                                    TextInputType.text,
                                    false,
                                    null,
                                    true,
                                    false)
                              ],
                            ),
                            const SizedBox(
                              height: 11,
                            ),

                            //Drop down buttons
                            Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              key: connector.dropdownformkey,
                              child: Row(
                                children: [
                                  //proofs
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ID-Proof',
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
                                                2.3,
                                        child: DropdownButtonFormField(
                                          value: widget
                                                  .currentCustomerData['proof']!
                                                  .isEmpty
                                              ? null
                                              : widget.currentCustomerData[
                                                  'proof']!,
                                          validator: (value) {
                                            if (value == null) {
                                              return "*required";
                                            }
                                            return null; // no error
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          onChanged: (value) {
                                            connector.ProofFinder(value);
                                            connector.ischangedProof = true;
                                            connector.areChangesMade = true;
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
                                            hintText: 'Select Proof',
                                            hintStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            fillColor: Colors.transparent,
                                          ),
                                          items: connector.Proofitems.map(
                                              (String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  //Purpose drop
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Purpose',
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
                                                2.3,
                                        child: DropdownButtonFormField(
                                          value: widget
                                                  .currentCustomerData[
                                                      'purpose']!
                                                  .isEmpty
                                              ? null
                                              : widget.currentCustomerData[
                                                  'purpose']!,
                                          validator: (value) {
                                            if (value == null) {
                                              return "*required";
                                            }
                                            return null; // no error
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          onChanged: (value) {
                                            connector.PurposeFinder(value);
                                            connector.ischangedPurpose = true;
                                            connector.areChangesMade = true;
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
                                            hintText: 'Select Purpose',
                                            hintStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            fillColor: Colors.transparent,
                                          ),
                                          items: connector.Purposeitems.map(
                                              (String item) {
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
                              ),
                            ),
                            //check in time ,check in date
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check-In-Date',
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
                                                2.3,
                                        child: connector.testFormFieald(
                                            context,
                                            connector.CheckIndatecontroller,
                                            'Enter date',
                                            TextInputType.none,
                                            true,
                                            () => connector.CheckinDatePicker(
                                                context),
                                            false,
                                            false)),
                                  ],
                                ),
                                const Spacer(),
                                //check out
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check-in-Time',
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: connector.testFormFieald(
                                          context,
                                          connector.checkINTimecontroller,
                                          'Enter time',
                                          TextInputType.none,
                                          true, () {
                                        connector.CheckinTimePicker(context);
                                      }, false, false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            //check out time ,check out date
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check-Out-Date',
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
                                                2.3,
                                        child: connector.testFormFieald(
                                            context,
                                            connector.Checkoutdatecontroller,
                                            'Enter Date',
                                            TextInputType.none,
                                            true, () {
                                          connector.CheckoutDatePicker(context);
                                        }, false, false)),
                                  ],
                                ),
                                const Spacer(),
                                //check out
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check-out-Time',
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
                                                2.3,
                                        child: connector.testFormFieald(
                                            context,
                                            connector.checkOUTTimecontroller,
                                            'Enter Time',
                                            TextInputType.none,
                                            true, () {
                                          connector.CheckoutTimePicker(context);
                                        }, false, false)),
                                  ],
                                ),
                              ],
                            ),
                            //Rate
                            const SizedBox(
                              height: 11,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                      child: connector.testFormFieald(
                                          context,
                                          connector.ratecontroller,
                                          'Current Rate ${widget.currentCustomerData['rate']}',
                                          TextInputType.number,
                                          false,
                                          () {},
                                          false,
                                          false)),
                                ],
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 11,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
                      onPressed: connector.isProcessing
                          ? null
                          : () async {
                              connectivity
                                  .checkConnectivity()
                                  .then((value) async {
                                if (value == ConnectivityResult.none) {
                                  connector.isProcessing =
                                      false; //to stop the indication
                                  connector.ischangedProof =
                                      false; //making the selection to false
                                  connector.ischangedPurpose =
                                      false; //making the selection to false
                                  // connector.clearingfiealds();
                                  connector.areChangesMade = false;
                                  NoInternetDialog(context);
                                  connector.isProcessing = false;
                                } else {
                                  if (connector.textformkey.currentState!
                                          .validate() &&
                                      connector.dropdownformkey.currentState!
                                          .validate()) {
                                    if (connector.areChangesMade) {
                                      try {
                                        connector.isProcessing = true;

                                        if (kDebugMode) {
                                          print(connector.namecontroller.text);
                                        }

                                        if (kDebugMode) {
                                          connector.ischangedProof
                                              ? print(
                                                  'changed proof ID ${connector.currentSelectedproof}')
                                              : print(
                                                  'is this proof is null  ${connector.currentSelectedproof}');
                                        }
                                        if (kDebugMode) {
                                          connector.ischangedPurpose
                                              ? print(
                                                  'Changed Purpose ${connector.currentSelectedPurpose}')
                                              : print(
                                                  "is this purpose is null ${connector.currentSelectedPurpose}");
                                        }
                                        if (kDebugMode) {
                                          print(connector
                                              .CheckIndatecontroller.text);
                                        }
                                        if (kDebugMode) {
                                          print(connector
                                              .checkINTimecontroller.text);
                                        }
                                        if (kDebugMode) {
                                          print(connector
                                              .Checkoutdatecontroller.text);
                                        }
                                        if (kDebugMode) {
                                          print(connector
                                              .checkOUTTimecontroller.text);
                                        }
                                        if (kDebugMode) {
                                          print(connector.ratecontroller.text);
                                        }

                                        //Updating current customer data
                                        await connector.UpdateCustomerData(context,
                                                oldname: widget.currentCustomerData[
                                                    'name'],
                                                Newname: connector
                                                    .namecontroller.text,
                                                address: connector
                                                    .addresscontroller.text,
                                                mobilenumber: connector
                                                    .phonenumbercontroller.text,
                                                noofpeople: connector
                                                    .peoplecontroller.text,
                                                proof: connector.ischangedProof
                                                    ? connector
                                                        .currentSelectedproof
                                                    : connector
                                                        .proofInitialValue,
                                                purpose: connector.ischangedPurpose
                                                    ? connector
                                                        .currentSelectedPurpose
                                                    : connector
                                                        .purposeInitialValue,
                                                checkindate: connector
                                                    .CheckIndatecontroller.text,
                                                checkintime: connector
                                                    .checkINTimecontroller.text,
                                                checkoutdate: connector
                                                    .Checkoutdatecontroller
                                                    .text,
                                                checkouttime: connector
                                                    .checkOUTTimecontroller
                                                    .text,
                                                rate: connector.ratecontroller.text,
                                                catogary: catogary,
                                                uniqueID: widget.currentCustomerData['uniqueID'])
                                            .then((value) => setState(() {
                                                  connector.areChangesMade =
                                                      false;
                                                }));
                                      } finally {
                                        connector.isProcessing =
                                            false; //to stop the indication
                                        connector.ischangedProof =
                                            false; //making the selection to false
                                        connector.ischangedPurpose =
                                            false; //making the selection to false
                                        //   Navigator.of(context).pop();
                                      }
                                    } else {
                                      // Show a snack bar indicating that no changes have been made
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('No changes made.'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                }
                              });
                            },
                      label: connector.isProcessing
                          ? const SizedBox(
                              height: 17,
                              width: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color.fromRGBO(253, 186, 63, 1),
                              ),
                            )
                          : const Text(
                              'Update changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                      icon: const Icon(
                        Icons.refresh_outlined,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
