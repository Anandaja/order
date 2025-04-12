import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/dormitory_reservation_booking_provider.dart';
import 'package:order_now_android/view_model/admin/dormitorylist_reservation_provider.dart';
//import 'package:jnn_erp/view_model/admin/calender_page_view_model.dart';

//import 'package:jnn_erp/view_model/admin/roomlist_reservation_view_model.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DormitoryReservationBooking extends StatefulWidget {
  final DateTime CurrentDate;

  const DormitoryReservationBooking(
      {super.key,
      required this.CurrentDate,
      required this.ReservedRoomList,
      required this.FormattedCurrentDate});

  final List ReservedRoomList;
  final String FormattedCurrentDate;
  @override
  DormitoryReservationBookingState createState() =>
      DormitoryReservationBookingState();
}

class DormitoryReservationBookingState
    extends State<DormitoryReservationBooking> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
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
                  Provider.of<DormitoryReservationBookingProvider>(context,
                          listen: false)
                      .clearingfiealds();
                  Navigator.of(context).pop(true);
                  Provider.of<DormitoryListReservationProvider>(context,
                          listen: false)
                      .ReserveDormitoryList
                      .clear();
                  Provider.of<DormitoryListReservationProvider>(context,
                          listen: false)
                      .DetailsLoader(widget.CurrentDate);
                }, // is it works?  androis ios?
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Widget build(BuildContext context) {
    print("Reserve list from room list page ${widget.ReservedRoomList}");
    print("List length ${widget.ReservedRoomList.length}");
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(236, 236, 236, 1),
        body: Consumer<DormitoryReservationBookingProvider>(
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
                      Provider.of<DormitoryReservationBookingProvider>(context,
                              listen: false)
                          .clearingfiealds();
                      // showExitPopup();
                      Provider.of<DormitoryListReservationProvider>(context,
                              listen: false)
                          .ReserveDormitoryList
                          .clear();
                      Navigator.pop(context, [
                        Provider.of<DormitoryListReservationProvider>(context,
                                listen: false)
                            .DetailsLoader(widget.CurrentDate)
                      ]);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),

              // // consumer.OngoingList.isEmpty
              //           ? const SliverFillRemaining(
              //               hasScrollBody: true,
              //               //  fillOverscroll: true,
              //               child: Align(
              //                   alignment: Alignment.center,
              //                   child: Text('You haven\'t added any food')))
              //           :
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Dormitory List',
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
                    String roomno =
                        widget.ReservedRoomList[index]['roomnoORname'];
                    String rate = widget.ReservedRoomList[index]['rate'];
                    String image = widget.ReservedRoomList[index]['image'];
                    bool isAvailable =
                        widget.ReservedRoomList[index]['isAvailable'];
                    print("Availability $isAvailable");
                    String floor = widget.ReservedRoomList[index]['floor'];

                    return consumer.ListCreator(
                        context: context,
                        roomno: roomno,
                        rate: rate,
                        image: image,
                        floor: floor,
                        index: index);
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
                                    KeyboardType: TextInputType.name,
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
                                    KeyboardType: TextInputType.number,
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "*required";
                                            }
                                            return null; // no error
                                          },
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          onChanged: (String? value) {
                                            consumer.autovalidate = false;

                                            consumer.ProofFinder(value);
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
                                              child: Text('DrivingLicence'),
                                            ),
                                            DropdownMenuItem<String>(
                                              value: 'Other',
                                              child: Text('Other'),
                                            )
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
                                child: consumer.testFormFieald(context,
                                    controller: consumer.addresscontroller,
                                    HintText: 'Enter Address',
                                    onTap: false,
                                    isPhone: false,
                                    KeyboardType: TextInputType.text,
                                    onTapFunction: null,
                                    isAddress: true),
                              ),
                              const SizedBox(
                                height: 13,
                              ),

                              //here the row fiealds of rate .
                              //
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          child: consumer.testFormFieald(
                                              context,
                                              controller: consumer
                                                  .AdvancePaymentController,
                                              HintText: 'Enter Amount',
                                              KeyboardType:
                                                  TextInputType.number,
                                              onTap: false,
                                              onTapFunction: null,
                                              isPhone: false,
                                              isAddress: false)),
                                    ],
                                  ),
                                  const Spacer(),
                                  //check out
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.3,
                                          child: consumer.testFormFieald(
                                              context,
                                              controller:
                                                  consumer.Totalratecontroller,
                                              HintText: 'Enter Amount',
                                              KeyboardType:
                                                  TextInputType.number,
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
                            'Reservation on ',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 17,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${widget.FormattedCurrentDate}',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 17,
                              color: Color.fromRGBO(253, 186, 63, 1),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // buildTextField(controller: titleController),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // buildTextField(controller: descpController)

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
                                    if (value == ConnectivityResult.none) {
                                      Provider.of<DormitoryListReservationProvider>(
                                              context,
                                              listen: false)
                                          .ReserveDormitoryList
                                          .clear();
                                      consumer.clearingfiealds();
                                      NoInternetDialog(context);
                                      consumer.isProcessing = false;
                                    } else {
                                      if (consumer.textformkey.currentState!
                                              .validate() &&
                                          consumer
                                              .dropdownProofkey.currentState!
                                              .validate()) {
                                        String uniqueId =
                                            consumer.generateUniqueID();
                                        try {
                                          setState(() {
                                            consumer.isProcessing = true;
                                          });

                                          print(
                                              "The Room List ${widget.ReservedRoomList}");
                                          print(
                                              "Reserving Date ${widget.CurrentDate}");
                                          print(
                                              "Enter Customer Name ${consumer.namecontroller.text}");
                                          print(
                                              "Mobile number ${consumer.phonenumbercontroller.text}");
                                          print(
                                              "Selected Proof ${consumer.currentSelectedproof}");
                                          print(
                                              "Advance Amount ${consumer.AdvancePaymentController.text}");
                                          print(
                                              "ToTAL Amount ${consumer.Totalratecontroller.text}");

                                          await consumer.ReserveDormitory(
                                                  context,
                                                  date: widget.CurrentDate,
                                                  ReserveList:
                                                      widget.ReservedRoomList,
                                                  name: consumer
                                                      .namecontroller.text,
                                                  phonenumber: consumer
                                                      .phonenumbercontroller
                                                      .text,
                                                  proof: consumer
                                                      .currentSelectedproof,
                                                  Totalrate: consumer
                                                      .Totalratecontroller.text,
                                                  AdvanceAmount: consumer
                                                      .AdvancePaymentController
                                                      .text,
                                                  uniqueId: uniqueId,
                                                  isReserved: true,
                                                  Catogary: 'dormitory',
                                                  Address: consumer
                                                      .addresscontroller.text)
                                              .then((value) {
                                            Provider.of<DormitoryListReservationProvider>(
                                                    context,
                                                    listen: false)
                                                .ReserveDormitoryList
                                                .clear();
                                            consumer.clearingfiealds();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Dormitory are Reserved'),
                                                duration: Duration(
                                                    seconds:
                                                        3), // You can adjust the duration
                                              ),
                                            );
                                            //should i call this setPreebookDate function here always if there is any issues.
                                            // //Should i do any thing here to make the date green means should  i update here , to achive the thing
                                            // // setState(() {
                                            // return Provider.of<CalenderPageViewModel>(context,
                                            //         listen: false)
                                            //     .setPrebookedDate(
                                            //         context, widget.CurrentDate); //this is main
                                            // // });
                                          }).then((value) =>
                                                  Navigator.pop(context, [
                                                    Provider.of<DormitoryListReservationProvider>(
                                                            context,
                                                            listen: false)
                                                        .DetailsLoader(
                                                            widget.CurrentDate)
                                                  ]));
                                        } catch (e) {
                                          print("Error While Reserving $e");
                                          Text("Error");
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
                                      color: Color.fromRGBO(253, 186, 63, 1),
                                    ),
                                  )
                                : Text(
                                    'CONFIRM RESERVATION',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      )
                    ],
                  ),
                ),
              )
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         const SizedBox(
              //           height: 20,
              //         ),
              //         // Text(
              //         //   'Table No ${consumer.Tableno}',
              //         //   style: const TextStyle(
              //         //     color: Color.fromARGB(255, 255, 188, 4),
              //         //     fontWeight: FontWeight.w700,
              //         //     fontSize: 19,
              //         //   ),
              //         // ),
              //         const Padding(
              //           padding: EdgeInsets.only(left: 8),
              //           child: Align(
              //             alignment: Alignment.topLeft,
              //             child: Text(
              //               'Bill Details',
              //               style: TextStyle(
              //                 color: Color.fromARGB(255, 0, 0, 0),
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 14,
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 6,
              //         ),
              //         Container(
              //           height: MediaQuery.of(context).size.height / 2.7,
              //           width: double.infinity,
              //           decoration: const BoxDecoration(
              //             borderRadius: BorderRadius.all(Radius.circular(12)),
              //             color: Color.fromARGB(255, 37, 37, 37),
              //             // color: Color.fromARGB(255, 255, 188, 4)
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 15),
              //             child: Column(
              //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Expanded(
              //                   child: ListView.builder(
              //                     itemCount: consumer.OngoingList.length,
              //                     itemBuilder: ((context, index) {
              //                       //  String foodname = '';
              //                       //use a bool if All chip is selected then automatically load the data on this page
              //                       // Access the values directly from BillingList[index]
              //                       String foodname =
              //                           consumer.OngoingList[index].foodname;
              //                       int quantity =
              //                           consumer.OngoingList[index].quantity;
              //                       String rate =
              //                           consumer.OngoingList[index].rate;
              //                       int foodTotal = int.parse(rate) * quantity;

              //                       print('Testt ${consumer.OngoingList}');
              //                       return consumer.ListBilling(context,
              //                           foodname: foodname,
              //                           rate: rate,
              //                           quantity: quantity,
              //                           index: index,
              //                           foodtotal: foodTotal);
              //                     }),
              //                   ),
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       'Total',
              //                       style: GoogleFonts.inter(
              //                         textStyle: const TextStyle(
              //                           color: Color.fromARGB(255, 255, 188, 4),
              //                           fontSize: 24,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                       // style: const TextStyle(
              //                       //   color: Color.fromARGB(255, 255, 188, 4),
              //                       //   fontWeight: FontWeight.w700,
              //                       //   fontSize: 24,
              //                       // ),
              //                     ),
              //                     Text(
              //                       '${consumer.totalrate(BillFood: consumer.OngoingList)}/-',
              //                       style: GoogleFonts.inter(
              //                         textStyle: const TextStyle(
              //                           color: Color.fromARGB(255, 255, 188, 4),
              //                           fontSize: 24,
              //                           fontWeight: FontWeight.w700,
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 30,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 30,
              //         ),
              //         SizedBox(
              //           width: double.infinity,
              //           height: MediaQuery.of(context).size.height / 13,
              //           child: ElevatedButton(
              //             onPressed: consumer.isProcessing
              //                 ? null
              //                 : () async {
              //                     try {
              //                       consumer.ConfirmOrder(context,
              //                           tableNo: consumer.Tableno,
              //                           Availability: true);
              //                     } catch (e) {
              //                       print('error on onpressed $e');
              //                     } finally {
              //                       consumer.isProcessing = false;
              //                     }
              //                     //confirm order by updating the bool first and then remove ongoing order from this table
              //                   },
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //                 backgroundColor: Color.fromARGB(255, 37, 37, 37)),
              //             child: Center(
              //               child: consumer.isProcessing
              //                   ? const SizedBox(
              //                       height: 17,
              //                       width: 17,
              //                       child: CircularProgressIndicator(
              //                         strokeWidth: 3,
              //                         color: Color.fromRGBO(253, 186, 63, 1),
              //                       ),
              //                     )
              //                   : const Text('Confirm Order',
              //                       style: TextStyle(
              //                           fontSize: 19,
              //                           fontWeight: FontWeight.w700,
              //                           color:
              //                               Color.fromARGB(255, 255, 255, 255))),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 30,
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          );
        }),
      ),
    );
  }
}
