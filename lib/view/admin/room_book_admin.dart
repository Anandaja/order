import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/admin_rooms_book_provider.dart';
import 'package:order_now_android/view_model/admin/rooms_page_view_model.dart';

import 'package:provider/provider.dart';

class AdminRoomBookPage extends StatefulWidget {
  const AdminRoomBookPage({super.key, required this.currentRoomData});
  final Map<String, dynamic> currentRoomData;
  @override
  AdminRoomBookPageState createState() => AdminRoomBookPageState();
}

class AdminRoomBookPageState extends State<AdminRoomBookPage> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  DateTime currentDateTime = DateTime.now();

  @override
  void initState() {
    String formattedTime = DateFormat('hh:mm a').format(DateTime(
        2021,
        1,
        1,
        currentDateTime.hour,
        currentDateTime.minute)); //to get the formmatted time

    String formattedDate =
        currentDateTime.toLocal().toString().split(" ")[0]; //formatted date

    final provider = Provider.of<AdminRoomBookProvider>(context, listen: false);
    String NextDay = currentDateTime
        .toLocal()
        .add(Duration(days: 1))
        .toString()
        .split(" ")[0];

    String checkOutTime =
        DateFormat('hh:mm a').format(DateTime(2021, 1, 1, 13, 0));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.initialCheckinDate = formattedDate;
      provider.initialCheckinTime = formattedTime;
      provider.initiaCheckoutDate = NextDay;
      provider.initialCheckoutTime = checkOutTime;

      provider.CheckIndatecontroller.text = formattedDate; //checkin date
      provider.checkINTimecontroller.text = formattedTime; //checkin time
      provider.Checkoutdatecontroller.text = NextDay; //test
      provider.checkOUTTimecontroller.text = checkOutTime;

      //REMOVE ALL UNWANTED PRINTS LIKE THIS IN THE APP BY SHAFI
      // print('initial check in date ${provider.initialCheckinDate}');

      // print('initial checkin time ${provider.initialCheckinTime}');

      // print('the initial checkout date ${provider.initiaCheckoutDate}');

      // print('initial check out time ${provider.initialCheckoutTime}');
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
            title: const Text('Oops! Booking not finished!'),
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
                  Provider.of<AdminRoomBookProvider>(context, listen: false)
                      .clearingfiealds();
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
    Provider.of<AdminRoomBookProvider>(context, listen: false).avilable =
        widget.currentRoomData['isAvailable'];
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        key: Provider.of<AdminRoomBookProvider>(context, listen: false)
            .scaffoldKey, //to avoid the deactivated widget error
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AdminRoomBookProvider>(context, listen: false)
                    .clearingfiealds();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0),
              )),
        ),
        // extendBodyBehindAppBar: true,
        body: Consumer<AdminRoomBookProvider>(
            builder: (context, connector, child) {
          return ListView(
            padding: EdgeInsets.zero,
            //  physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,

            //   mainAxisSize: MainAxisSize.min,
            children: [
              Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.5), //load image here befor the orginal image loads
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: double.infinity,
                      child: Image.network(
                        widget.currentRoomData['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color.fromRGBO(253, 186, 63, 1),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(236, 236, 236, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ]),
              // Closing bracket for Stack
              // Closing bracket for Stack

              // SizedBox(height: 20),
              //the image loads aboveof the container ,just replace  this with any other widget to achieve the ui

              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                    //  height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(236, 236, 236, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        //   physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true, // This is important ⬇️
                        // shrinkWrap: true,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 17),
                                child: Column(
                                  children: [
                                    Text('ROOMNO',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 85),
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
                                      baselineType: TextBaseline.alphabetic,
                                      child: Container(
                                        child: Text(
                                          '${widget.currentRoomData['roomno']}',
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

                                    // Text('${widget.currentRoomData['roomno']}',
                                    //     style: GoogleFonts.nunitoSans(
                                    //       textStyle: const TextStyle(
                                    //           color: Color.fromARGB(
                                    //               255, 65, 133, 69),
                                    //           fontWeight: FontWeight.w800,
                                    //           fontSize: 35,
                                    //           letterSpacing: 4.8
                                    //           //   4.76
                                    //           ),
                                    //     ))
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                21,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              30.0), //Use this code to make rounded corners
                                          color: connector.avilable
                                              ? const Color.fromRGBO(
                                                  41, 105, 52, 1)
                                              : const Color.fromRGBO(
                                                  255, 0, 0, 1),
                                        ),
                                        child: connector.avilable
                                            ? const Center(
                                                child: Text(
                                                  'Available',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : const Center(
                                                child: Text('NotAvailable',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white)),
                                              )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                21,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                30.0), //Use this code to make rounded corners
                                            color: const Color.fromRGBO(
                                                253, 185, 63, 1)),
                                        child: Center(
                                          child: Text(
                                            widget.currentRoomData['roomtype'],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        )),
                                    const SizedBox(
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
                                            '${widget.currentRoomData['floor']} Floor',
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
                            height: 10,
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
                            height: 20,
                          ),
                          Form(
                              key: connector.textformkey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      //name
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
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
                                      Form(
                                        key: connector.PeopleKey,
                                        autovalidateMode: connector.autovalidate
                                            ? AutovalidateMode.always
                                            : AutovalidateMode
                                                .onUserInteraction,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3, // Adjust the width as needed
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
                                                onChanged: (String? value) {
                                                  connector.peoplecount =
                                                      value!;
                                                  connector.autovalidate =
                                                      false;
                                                  //    connector.ProofFinder(value);
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 18.0,
                                                          horizontal: 10.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
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
                                                  hintText: 'Count',
                                                  hintStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  fillColor: Colors.transparent,
                                                ),
                                                items: connector.NoOfpeople.map(
                                                    (String item) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  //phonenumber Fieald
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          connector.scaffoldKey.currentContext,
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
                                    autovalidateMode: connector.autovalidate
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.onUserInteraction,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
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
                                                onChanged: (String? value) {
                                                  connector.autovalidate =
                                                      false;

                                                  connector.ProofFinder(value);
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 18.0,
                                                          horizontal: 10.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
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
                                                  hintText: 'Select Proof',
                                                  hintStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  fillColor: Colors.transparent,
                                                ),
                                                items: const [
                                                  DropdownMenuItem<String>(
                                                    value: 'Adhaar',
                                                    child: Text(
                                                      'Adhaar',
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'VoterID',
                                                    child: Text(
                                                      'VoterID',
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'DrivingLicence',
                                                    child:
                                                        Text('DrivingLicence'),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'Other',
                                                    child: Text('Other'),
                                                  )
                                                ],
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
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
                                                  connector.autovalidate =
                                                      false;
                                                  connector.PurposeFinder(
                                                      value);
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 18.0,
                                                          horizontal: 10.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
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
                                                  hintText: 'Select Purpose',
                                                  hintStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  fillColor: Colors.transparent,
                                                ),
                                                items: const [
                                                  DropdownMenuItem(
                                                    value: 'Travel',
                                                    child: Text(
                                                      'Travel',
                                                    ),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Bussiness',
                                                    child: Text(
                                                      'Bussiness',
                                                    ),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Special events',
                                                    child:
                                                        Text('Special events'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Refreshment',
                                                    child: Text('Refreshment'),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: 'Other',
                                                    child: Text('Other'),
                                                  )
                                                ],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: connector.testFormFieald(
                                                  context,
                                                  connector
                                                      .CheckIndatecontroller,
                                                  'Enter date',
                                                  TextInputType.none,
                                                  true,
                                                  () => connector
                                                      .CheckinDatePicker(
                                                          context),
                                                  false,
                                                  false)),
                                        ],
                                      ),
                                      const Spacer(),
                                      //check out
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: connector.testFormFieald(
                                                  context,
                                                  connector
                                                      .checkINTimecontroller,
                                                  'Enter time',
                                                  TextInputType.none,
                                                  true, () {
                                                connector.CheckinTimePicker(
                                                    context);
                                              }, false, false)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: connector.testFormFieald(
                                                  context,
                                                  connector
                                                      .Checkoutdatecontroller,
                                                  'Enter Date',
                                                  TextInputType.none,
                                                  true, () {
                                                connector.CheckoutDatePicker(
                                                    context);
                                              }, false, false)),
                                        ],
                                      ),
                                      const Spacer(),
                                      //check out
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: connector.testFormFieald(
                                                  context,
                                                  connector
                                                      .checkOUTTimecontroller,
                                                  'Enter Time',
                                                  TextInputType.none,
                                                  true, () {
                                                connector.CheckoutTimePicker(
                                                    context); // changed to not fixed
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.9,
                                            child: connector.testFormFieald(
                                                context,
                                                connector.ratecontroller,
                                                'Current Rate ${widget.currentRoomData['rate']}',
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 1,
                            child: ElevatedButton(
                              onPressed: connector.isProcessing
                                  ? null
                                  : () async {
                                      connectivity
                                          .checkConnectivity()
                                          .then((value) async {
                                        if (value == ConnectivityResult.none) {
                                          connector.clearingfiealds();
                                          NoInternetDialog(context);
                                          connector.isProcessing = false;
                                        } else {
                                          if (connector
                                                  .textformkey.currentState!
                                                  .validate() &&
                                              connector
                                                  .dropdownformkey.currentState!
                                                  .validate() &&
                                              connector.PeopleKey.currentState!
                                                  .validate()) {
                                            String uniqueID =
                                                connector.generateUniqueID();
                                            try {
                                              connector.isProcessing = true;

                                              if (kDebugMode) {
                                                print(connector
                                                    .namecontroller.text);
                                                print(widget
                                                    .currentRoomData['roomno']);

                                                print(
                                                    'ID ${connector.currentSelectedproof}');
                                                print(
                                                    'Purpose ${connector.currentSelectedPurpose}');
                                                print(connector
                                                    .CheckIndatecontroller
                                                    .text);
                                                print(connector
                                                    .checkINTimecontroller
                                                    .text);
                                                print(connector
                                                    .Checkoutdatecontroller
                                                    .text);
                                                print(connector
                                                    .checkOUTTimecontroller
                                                    .text);
                                                print(connector
                                                    .ratecontroller.text);
                                                print(
                                                    'count ${connector.peoplecount}');
                                                // Other print statements...
                                              }

                                              // Update the availability of the room
                                              await connector.UpdateAvailbility(
                                                context,
                                                roomno: widget
                                                    .currentRoomData['roomno'],
                                                Availbility: false,
                                              );

                                              // Book the room
                                              await connector.BookRoom(
                                                      uniqueID,
                                                      connector
                                                          .ratecontroller.text,
                                                      widget.currentRoomData[
                                                          'roomtype'],
                                                      widget.currentRoomData[
                                                          'floor'],
                                                      widget.currentRoomData[
                                                          'roomno'],
                                                      connector
                                                          .namecontroller.text,
                                                      connector
                                                          .addresscontroller
                                                          .text,
                                                      connector
                                                          .phonenumbercontroller
                                                          .text,
                                                      connector
                                                          .currentSelectedPurpose,
                                                      connector.onchanged
                                                          ? connector
                                                              .checkINTimecontroller
                                                              .text
                                                          : connector
                                                              .initialCheckinTime,
                                                      connector.onchanged
                                                          ? connector
                                                              .CheckIndatecontroller
                                                              .text
                                                          : connector
                                                              .initialCheckinDate,
                                                      connector.onchanged
                                                          ? connector
                                                              .checkOUTTimecontroller
                                                              .text
                                                          : connector
                                                              .initialCheckoutTime,
                                                      connector.onchanged
                                                          ? connector
                                                              .Checkoutdatecontroller
                                                              .text
                                                          : connector
                                                              .initiaCheckoutDate,
                                                      connector
                                                          .currentSelectedproof,
                                                      connector.peoplecount,
                                                      'rooms',
                                                      true)
                                                  .then((value) => connector
                                                      .clearingfiealds())
                                                  .then((value) =>
                                                      Navigator.of(context).pop(
                                                          [Provider.of<AdminRoomsProvider>(context, listen: false).DetailssLoader(context)]));
                                            } finally {
                                              connector.isProcessing = false;
                                            }
                                          } else {
                                            connector.autovalidation();
                                          }
                                        }
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(41, 105, 52, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 15.0,
                              ),
                              child: Center(
                                child: connector.isProcessing
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
                                        'BOOK ROOM',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          )
                        ],
                      ),
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }
}
