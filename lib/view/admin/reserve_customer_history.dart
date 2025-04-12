import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/reservation_model.dart';
import 'package:order_now_android/view_model/admin/reserve_customer_history_provider.dart';
import 'package:provider/provider.dart';

class ReserveCustomerHistory extends StatefulWidget {
  final DateTime CurrentDate;

  final String formattedDate;

  final String catogary;

  const ReserveCustomerHistory(
      {super.key,
      required this.CurrentDate,
      required this.ReservedRoomList,
      required this.CustomerDetails,
      required this.formattedDate,
      required this.catogary});
  final List<ReservationListDetails> ReservedRoomList;
  final Map<String, dynamic> CustomerDetails;
  @override
  ReserveCustomerHistoryState createState() => ReserveCustomerHistoryState();
}

class ReserveCustomerHistoryState extends State<ReserveCustomerHistory> {
  @override
  void initState() {
    final provider =
        Provider.of<ReserveCustomerHistoryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        print('Formatted Date  ${widget.formattedDate}');
        print("customername ${widget.CustomerDetails['name']}");
        print('Advance ${widget.CustomerDetails['AdvanceAmount']}');

        print('date ${widget.CustomerDetails['date']}');
        print('Totalrate ${widget.CustomerDetails['Totalrate']}');
        print('catogary ${widget.CustomerDetails['catogary']}');
        print('isReserved ${widget.CustomerDetails['isReserved']}');
        print('phonenumber ${widget.CustomerDetails['phonenumber']}');
        print('proof ${widget.CustomerDetails['proof']}');
        print('reserveList ${widget.CustomerDetails['reserveList']}');
        print("Unnnnnnnnnnnnnnnnniq id ${widget.CustomerDetails['uniqueId']}");
        print("Address ${widget.CustomerDetails['address']}"); //address
      }
      provider.namecontroller.text = widget.CustomerDetails['name'];
      provider.phonenumbercontroller.text =
          widget.CustomerDetails['phonenumber'];
      provider.AdvancePaymentController.text =
          widget.CustomerDetails['AdvanceAmount'];
      provider.Totalratecontroller.text = widget.CustomerDetails['Totalrate'];
      provider.proofInitialValue = widget.CustomerDetails['proof'];
      provider.CheckIndatecontroller.text = widget.formattedDate;
      provider.addresscontroller.text = widget.CustomerDetails['address'];

      provider.DateChanged = false;
      provider.areChangesMade = false;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    print("Reserve list from room list page ${widget.ReservedRoomList}");
    print("List length ${widget.ReservedRoomList.length}");
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 236, 236, 1),
      body: Consumer<ReserveCustomerHistoryProvider>(
          builder: (context, consumer, child) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true, //its alwys align in centre
              elevation: 10,
              shadowColor: Color.fromARGB(255, 0, 0, 0),
              toolbarHeight: 70,

              backgroundColor: Color.fromRGBO(68, 142, 74, 1),
              title: Text(
                'Reservation',
                style: GoogleFonts.nunitoSans(
                  fontSize: 25,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.catogary == 'rooms'
                        ? 'Room List'
                        : widget.catogary == 'dormitory'
                            ? 'Dormitory List'
                            : 'HomeStay List',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 17,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Use a bool if All chip is selected, then automatically load the data on this page
                  // Map<String, dynamic> detailsList = {
                  //   'roomtype': widget.ReservedRoomList[index].roomtype,
                  //   'roomno': widget.ReservedRoomList[index].roomno,
                  //   'rate': widget.ReservedRoomList[index].rate,
                  //   'image': widget.ReservedRoomList[index].image,
                  //   'isAvailable': widget.ReservedRoomList[index].isAvailable,
                  //   'floor': widget.ReservedRoomList[index].floor,
                  // };

                  String roomtype = widget.ReservedRoomList[index].roomtype;
                  String roomno = widget.ReservedRoomList[index].roomnoORname;
                  String rate = widget.ReservedRoomList[index].rate;
                  String image = widget.ReservedRoomList[index].image;
                  bool isAvailable = widget.ReservedRoomList[index].isAvailable;
                  print("Availability $isAvailable");
                  String floor = widget.ReservedRoomList[index].floor;

                  return consumer.ListCreator(
                      context: context,
                      roomno: roomno,
                      roomtype: roomtype,
                      rate: rate,
                      image: image,
                      floor: floor,
                      index: index,
                      Catogary: widget.catogary);
                },
                childCount: widget.ReservedRoomList.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Customer Details',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 17,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                        key: consumer.textformkey,
                        child: Column(
                          children: [
                            //Name Fieald
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width / 1.9,
                              child: consumer.testFormFieald(context,
                                  controller: consumer.namecontroller,
                                  HintText: 'Enter Name',
                                  onTap: false,
                                  isPhone: false,
                                  KeyboardType: TextInputType.none,
                                  onTapFunction: null,
                                  isAddress: false),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            //PhoneNumber Fieald
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Phone number',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width / 1.9,
                              child: consumer.testFormFieald(context,
                                  controller: consumer.phonenumbercontroller,
                                  HintText: 'Enter Mobile number',
                                  onTap: false,
                                  isPhone: true,
                                  KeyboardType: TextInputType.none,
                                  onTapFunction: null,
                                  isAddress: false),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            //for proof dropdown
                            Form(
                                autovalidateMode: consumer.autovalidate
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.onUserInteraction,
                                key: consumer.dropdownProofkey,
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'ID-Proof',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      // width: MediaQuery.of(context).size.width /
                                      //     2.3,
                                      child: DropdownButtonFormField(
                                        value: widget.CustomerDetails['proof']!
                                                .isEmpty
                                            ? null
                                            : widget.CustomerDetails['proof']!,
                                        validator: (value) {
                                          if (value == null) {
                                            return "*required";
                                          }
                                          return null; // no error
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_sharp),
                                        onChanged: (value) {
                                          // consumer.ProofFinder(value);
                                          // consumer.ischangedProof = true;
                                          // consumer.areChangesMade = true;
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
                                        items: [
                                          DropdownMenuItem<String>(
                                            enabled: false,
                                            value:
                                                widget.CustomerDetails['proof'],
                                            child: Text(
                                              widget.CustomerDetails['proof'],
                                            ),
                                          ),
                                          // DropdownMenuItem<String>(
                                          //   enabled: false,
                                          //   value: 'VoterID',
                                          //   child: Text(
                                          //     'VoterID',
                                          //   ),
                                          // ),
                                          // DropdownMenuItem<String>(
                                          //   enabled: false,
                                          //   value: 'DrivingLicence',
                                          //   child: Text('DrivingLicence'),
                                          // ),
                                          // DropdownMenuItem<String>(
                                          //   enabled: false,
                                          //   value: 'Other',
                                          //   child: Text('Other'),
                                          // )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                  ],
                                )),
                            //Adding image Proof here
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),

                            SizedBox(
                              //width: MediaQuery.of(context).size.width / 1.9,
                              child: consumer.testFormFieald(
                                context,
                                controller: consumer.addresscontroller,
                                HintText: 'Enter Address',
                                onTap: false,
                                isPhone: false,
                                KeyboardType: TextInputType.none,
                                onTapFunction: null,
                                isAddress: true,
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),

                            //here the row fiealds of rate .
                            //
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Advance Payment',
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
                                        child: consumer.testFormFieald(context,
                                            controller: consumer
                                                .AdvancePaymentController,
                                            HintText: 'Enter Amount',
                                            KeyboardType: TextInputType.none,
                                            onTap: false,
                                            onTapFunction: null,
                                            isPhone: false,
                                            isAddress: false)),
                                  ],
                                ),
                                const Spacer(),
                                //check out
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Amount',
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
                                        child: consumer.testFormFieald(context,
                                            controller:
                                                consumer.Totalratecontroller,
                                            HintText: 'Enter Amount',
                                            KeyboardType: TextInputType.none,
                                            onTap: false,
                                            onTapFunction: null,
                                            isPhone: false,
                                            isAddress: false)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: Image.asset(
                            'assets/images/reserving.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Reservation was ',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 17,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${widget.formattedDate}',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 17,
                            color: Color.fromRGBO(253, 186, 63, 1),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
