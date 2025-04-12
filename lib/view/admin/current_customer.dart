import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view_model/admin/current_customer_view_model.dart';

import 'package:provider/provider.dart';

class CurrentCustomerData extends StatefulWidget {
  const CurrentCustomerData({
    super.key,
    required this.currentCustomerData,
  });
  final Map<String, dynamic> currentCustomerData;

  @override
  CurrentCustomerDataState createState() => CurrentCustomerDataState();
}

class CurrentCustomerDataState extends State<CurrentCustomerData> {
  @override
  void initState() {
    final provider =
        Provider.of<CurrentCustomerProvider>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
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
          'Current Customer',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<CurrentCustomerProvider>(
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
                                            color: Color.fromRGBO(0, 0, 0, 85),
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
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 85),
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
                                          MediaQuery.of(context).size.width / 4,
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
                                      width: MediaQuery.of(context).size.width /
                                          1.9,
                                      child: connector.testFormFieald(
                                          connector.namecontroller,
                                          'Enter Name',
                                          false,
                                          null,
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
                                      width: MediaQuery.of(context).size.width /
                                          3, // Adjust the width as needed
                                      child: connector.testFormFieald(
                                          connector.peoplecontroller,
                                          'Enter Count',
                                          false,
                                          null,
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
                                  connector.phonenumbercontroller,
                                  'Enter Mobile Number',
                                  false,
                                  null,
                                  false)
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
                                  connector.addresscontroller,
                                  'Enter address',
                                  false,
                                  null,
                                  true)
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: DropdownButtonFormField(
                                        value: widget
                                                .currentCustomerData['proof']!
                                                .isEmpty
                                            ? null
                                            : widget
                                                .currentCustomerData['proof']!,
                                        validator: (value) {
                                          if (value == null) {
                                            return "*required";
                                          }
                                          return null; // no error
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_sharp),
                                        onChanged: (value) {
                                          //
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
                                          hintText: 'Select Proof',
                                          hintStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          fillColor: Colors.transparent,
                                        ),
                                        items: connector.Proofitems.map(
                                            (String item) {
                                          return DropdownMenuItem<String>(
                                            enabled: false,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: DropdownButtonFormField(
                                        value: widget
                                                .currentCustomerData['purpose']!
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
                                          //
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
                                          hintText: 'Select Purpose',
                                          hintStyle: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          fillColor: Colors.transparent,
                                        ),
                                        items: connector.Purposeitems.map(
                                            (String item) {
                                          return DropdownMenuItem<String>(
                                            enabled: false,
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: connector.testFormFieald(
                                          connector.CheckIndatecontroller,
                                          'Enter date',
                                          true,
                                          () {},
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
                                          connector.checkINTimecontroller,
                                          'Enter time',
                                          true,
                                          () {},
                                          false)),
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: connector.testFormFieald(
                                          connector.Checkoutdatecontroller,
                                          'Enter Date',
                                          true,
                                          () {},
                                          false)),
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
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: connector.testFormFieald(
                                          connector.checkOUTTimecontroller,
                                          'Enter Time',
                                          true,
                                          () {},
                                          false)),
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.9,
                                    child: connector.testFormFieald(
                                        connector.ratecontroller,
                                        'Current Rate }',
                                        false,
                                        () {},
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
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
