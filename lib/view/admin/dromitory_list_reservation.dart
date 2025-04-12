//import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/dormitory_reservation_booking.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/dormitorylist_reservation_provider.dart';
import 'package:provider/provider.dart';

class DormitoryListReservation extends StatefulWidget {
  const DormitoryListReservation(
      {super.key,
      required this.CurrentDate,
      required this.FormattedCurrentDate});

  final DateTime CurrentDate;
  final String FormattedCurrentDate;
  @override
  DormitoryListReservationstate createState() =>
      DormitoryListReservationstate();
}

class DormitoryListReservationstate extends State<DormitoryListReservation>
    with TickerProviderStateMixin {
  Future<bool> showExitPopup() async {
    Provider.of<DormitoryListReservationProvider>(context, listen: false)
        .ReserveDormitoryList
        .clear();
    return true;
  }

  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  void initState() {
    Provider.of<DormitoryListReservationProvider>(context, listen: false)
            .addToCartPopUpAnimationController =
        AnimationController(
            vsync: this, duration: const Duration(milliseconds: 400));

    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult?;
        });
      }
    });

    //is it only for the on change
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      //connectivity listner
      if (mounted) {
        setState(() {
          connectivityResult = result;
          print("Connectivity result $result");
        });
      }
      // log(result.name);
    } as void Function(ConnectivityResult event)?);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DormitoryListReservationProvider>(context, listen: false)
        .DetailsLoader(widget.CurrentDate);
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop([
                  Provider.of<DormitoryListReservationProvider>(context,
                          listen: false)
                      .ReserveDormitoryList
                      .clear()
                ]);
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
            'Dormitory Details',
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Consumer<DormitoryListReservationProvider>(
            builder: (context, consumer, child) {
          return Stack(children: [
            connectivityResult == ConnectivityResult.none
                ? NoNetworkDisplay(context)
                : consumer.isLoading
                    ? consumer.buildShimmerFloorListView(2)
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 26, top: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Ground Floor',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: consumer.dormitoryList.length,
                              itemBuilder: ((context, index) {
                                //use a bool if All chip is selected then automatically load the data on this page
                                Map<String, dynamic> detailsList = {
                                  'dormitoryno':
                                      consumer.dormitoryList[index].dormitoryno,
                                  'perHeadRate':
                                      consumer.dormitoryList[index].perHeadRate,
                                  'image': consumer.dormitoryList[index].image,
                                  'isAvailable':
                                      consumer.dormitoryList[index].isAvailable,
                                  'floor': consumer.dormitoryList[index].floor,
                                };

                                return consumer.ListCreator(
                                    context, detailsList, index);
                              }),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
          ]);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: connectivityResult == ConnectivityResult.none
            ? Container()
            : Consumer<DormitoryListReservationProvider>(
                builder: (context, value, child) {
                return value.ReserveDormitoryList.isNotEmpty
                    ? SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 1), end: Offset.zero)
                            .animate(value.addToCartPopUpAnimationController),
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 15,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(41, 105, 52, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 5.0,
                                  ),
                                  // backgroundColor: Color.fromRGBO(68, 142, 74, 1),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              DormitoryReservationBooking(
                                                CurrentDate: widget.CurrentDate,
                                                ReservedRoomList: Provider.of<
                                                            DormitoryListReservationProvider>(
                                                        context,
                                                        listen: false)
                                                    .ReserveDormitoryList,
                                                FormattedCurrentDate:
                                                    widget.FormattedCurrentDate,
                                              )),
                                    ).then((value) => Provider.of<
                                                DormitoryListReservationProvider>(
                                            context,
                                            listen: false)
                                        .addToCartPopUpAnimationController
                                        .reverse());
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'GO TO RESERVATION',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                          height: 27,
                                          width: 27,
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                  // icon: Center(
                                  //   child: SizedBox(
                                  //     height: 27,
                                  //     width: 27,
                                  //     child: Image.asset(
                                  //       'assets/images/reserve.png',
                                  //       scale: 1,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // )),
                                ),
                              ),
                            )),
                      )
                    : Container();
              }),
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: Color.fromRGBO(68, 142, 74, 1),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         CupertinoPageRoute(
        //             builder: (context) => DormitoryReservationBooking(
        //                   CurrentDate: widget.CurrentDate,
        //                   ReservedRoomList:
        //                       Provider.of<DormitoryListReservationProvider>(
        //                               context,
        //                               listen: false)
        //                           .ReserveDormitoryList,
        //                   FormattedCurrentDate: widget.FormattedCurrentDate,
        //                 )),
        //       );
        //     },
        //     child: Center(
        //       child: SizedBox(
        //         height: 27,
        //         width: 27,
        //         child: Image.asset(
        //           'assets/images/reserve.png',
        //           scale: 1,
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //     )),
      ),
    );
  }
}
