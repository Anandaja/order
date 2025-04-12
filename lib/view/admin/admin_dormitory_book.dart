import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/admin_dormitory_book_provider.dart';
import 'package:order_now_android/view_model/admin/dormitory_admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminDormitoryBookPage extends StatefulWidget {
  const AdminDormitoryBookPage({
    super.key,
    required this.currentDormitoryData,
  });
  final Map<String, dynamic> currentDormitoryData;
  @override
  AdminDormitoryBookPageState createState() => AdminDormitoryBookPageState();
}

class AdminDormitoryBookPageState extends State<AdminDormitoryBookPage> {
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

    final provider =
        Provider.of<AdminDormitoryBookProvider>(context, listen: false);
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

      //REMOVE THESE PRINTS BY SHAFI
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
                  Provider.of<AdminDormitoryBookProvider>(context,
                          listen: false)
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
    Provider.of<AdminDormitoryBookProvider>(context, listen: false).avilable =
        widget.currentDormitoryData['isAvailable'];
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        key: Provider.of<AdminDormitoryBookProvider>(context, listen: false)
            .scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AdminDormitoryBookProvider>(context, listen: false)
                    .clearingfiealds();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0),
              )),
        ),
        body: Consumer<AdminDormitoryBookProvider>(
          builder: (context, consumer, child) {
            return ListView(
              padding: EdgeInsets.zero,
              //  physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Stack(clipBehavior: Clip.none, children: [
                  Positioned(
                    child: ClipRRect(
                        child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: double.infinity,
                      child: Image.network(
                        widget.currentDormitoryData['image'],
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
                    )),
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
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Dormitory No ${widget.currentDormitoryData['dormitoryno']}',

                                ///${widget.currentDormitoryData['dormitoryno']}

                                style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              21,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            30.0), //Use this code to make rounded corners
                                        color: consumer.avilable
                                            ? const Color.fromRGBO(
                                                41, 105, 52, 1)
                                            : const Color.fromRGBO(
                                                255, 0, 0, 1),
                                      ),
                                      child: consumer.avilable
                                          ? const Center(
                                              child: Text(
                                                'Available',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
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
                                    width: 15,
                                  ),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
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
                                          '${widget.currentDormitoryData['floor']}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
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
                              height: 30,
                            ),
                            Form(
                                key: consumer.textformkey,
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer.namecontroller,
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer.peoplecontroller,
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
                                        consumer.testFormFieald(
                                            context,
                                            consumer.phonenumbercontroller,
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
                                        consumer.testFormFieald(
                                            consumer.scaffoldKey.currentContext,
                                            consumer.addresscontroller,
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
                                      autovalidateMode: consumer.autovalidate
                                          ? AutovalidateMode.always
                                          : AutovalidateMode.onUserInteraction,
                                      key: consumer.dropdownformkey,
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
                                                    consumer.autovalidate =
                                                        false;
                                                    consumer.ProofFinder(value);
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
                                                        color:
                                                            Color(0xFF7EC679),
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
                                                        color:
                                                            Color(0xFF7EC679),
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    hintText: 'Select Proof',
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    fillColor:
                                                        Colors.transparent,
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
                                                      child: Text(
                                                          'DrivingLicence'),
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
                                                    consumer.autovalidate =
                                                        false;
                                                    consumer.PurposeFinder(
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
                                                        color:
                                                            Color(0xFF7EC679),
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
                                                        color:
                                                            Color(0xFF7EC679),
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
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    hintText: 'Select Purpose',
                                                    hintStyle: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    fillColor:
                                                        Colors.transparent,
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
                                                      child: Text(
                                                          'Special events'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Refreshment',
                                                      child:
                                                          Text('Refreshment'),
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer
                                                        .CheckIndatecontroller,
                                                    'Enter date',
                                                    TextInputType.none,
                                                    true,
                                                    () => consumer
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer
                                                        .checkINTimecontroller,
                                                    'Enter time',
                                                    TextInputType.none,
                                                    true, () {
                                                  consumer.CheckinTimePicker(
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer
                                                        .Checkoutdatecontroller,
                                                    'Enter Date',
                                                    TextInputType.none,
                                                    true, () {
                                                  consumer.CheckoutDatePicker(
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
                                                child: consumer.testFormFieald(
                                                    context,
                                                    consumer
                                                        .checkOUTTimecontroller,
                                                    'Enter Time',
                                                    TextInputType.none,
                                                    true, () {
                                                  consumer.CheckoutTimePicker(
                                                      context);
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
                                              child: consumer.testFormFieald(
                                                  context,
                                                  consumer.ratecontroller,
                                                  'Per head Rate ${widget.currentDormitoryData['perHeadRate']}',
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
                                onPressed: consumer.isProcessing
                                    ? null
                                    : () async {
                                        connectivity
                                            .checkConnectivity()
                                            .then((value) async {
                                          if (value ==
                                              ConnectivityResult.none) {
                                            consumer.clearingfiealds();
                                            NoInternetDialog(context);
                                            consumer.isProcessing = false;
                                          } else {
                                            if (consumer
                                                    .textformkey.currentState!
                                                    .validate() &&
                                                consumer.dropdownformkey
                                                    .currentState!
                                                    .validate()) {
                                              String uniqueID =
                                                  consumer.generateUniqueID();
                                              try {
                                                consumer.isProcessing = true;

                                                if (kDebugMode) {
                                                  print(consumer
                                                      .namecontroller.text);
                                                  print(widget
                                                          .currentDormitoryData[
                                                      'dormitoryno']);

                                                  print(
                                                      'ID ${consumer.currentSelectedproof}');
                                                  print(
                                                      'Purpose ${consumer.currentSelectedPurpose}');
                                                  print(consumer
                                                      .CheckIndatecontroller
                                                      .text);
                                                  print(consumer
                                                      .checkINTimecontroller
                                                      .text);
                                                  print(consumer
                                                      .Checkoutdatecontroller
                                                      .text);
                                                  print(consumer
                                                      .checkOUTTimecontroller
                                                      .text);
                                                  print(consumer
                                                      .ratecontroller.text);
                                                }

                                                // Other print statements...

                                                // Update the availability of the dormitory
                                                await consumer
                                                    .UpdateAvailbility(
                                                  context,
                                                  dormitoryno: widget
                                                          .currentDormitoryData[
                                                      'dormitoryno'],
                                                  Availbility: false,
                                                );

                                                // Book the dormitory, here no roomtype
                                                await consumer.BookDormitory(
                                                        uniqueID,
                                                        consumer.ratecontroller
                                                            .text,
                                                        widget.currentDormitoryData[
                                                            'floor'],
                                                        widget.currentDormitoryData[
                                                            'dormitoryno'],
                                                        consumer.namecontroller
                                                            .text,
                                                        consumer
                                                            .addresscontroller
                                                            .text,
                                                        consumer
                                                            .phonenumbercontroller
                                                            .text,
                                                        consumer
                                                            .currentSelectedPurpose,
                                                        consumer.onchanged
                                                            ? consumer
                                                                .checkINTimecontroller
                                                                .text
                                                            : consumer
                                                                .initialCheckinTime,
                                                        consumer.onchanged
                                                            ? consumer
                                                                .CheckIndatecontroller
                                                                .text
                                                            : consumer
                                                                .initialCheckinDate,
                                                        consumer.onchanged
                                                            ? consumer
                                                                .checkOUTTimecontroller
                                                                .text
                                                            : consumer
                                                                .initialCheckoutTime,
                                                        consumer.onchanged
                                                            ? consumer
                                                                .Checkoutdatecontroller
                                                                .text
                                                            : consumer
                                                                .initiaCheckoutDate,
                                                        consumer
                                                            .currentSelectedproof,
                                                        consumer
                                                            .peoplecontroller
                                                            .text,
                                                        'dormitory',
                                                        true)
                                                    .then((value) => consumer
                                                        .clearingfiealds())
                                                    .then((value) =>
                                                        Navigator.of(context).pop(
                                                            [Provider.of<DormitoryAdminProvider>(context, listen: false).DetailsLoader()]));
                                              } finally {
                                                consumer.isProcessing = false;
                                              }
                                            } else {
                                              consumer.autovalidation();
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
                                  child: consumer.isProcessing
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
                                          'BOOK DORMITORY',
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
          },
        ),
      ),
    );
  }
}
