import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/room_reservation_booking.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/roomlist_reservation_view_model.dart';
import 'package:provider/provider.dart';

class RoomReservationList extends StatefulWidget {
  const RoomReservationList(
      {super.key,
      required this.CurrentDate,
      required this.FormattedCurrentDate});

  final DateTime CurrentDate;
  final String FormattedCurrentDate;
  @override
  RoomReservationListstate createState() => RoomReservationListstate();
}

class RoomReservationListstate extends State<RoomReservationList>
    with TickerProviderStateMixin {
  Future<bool> showExitPopup() async {
    Provider.of<RoomReservationListProvider>(context, listen: false)
        .ReserveRoomList
        .clear();
    return true;
  }

  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    Provider.of<RoomReservationListProvider>(context, listen: false)
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

  // @override
  // void dispose() {
  //   Provider.of<RoomReservationListProvider>(context, listen: false)
  //       .addToCartPopUpAnimationController
  //       .dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<RoomReservationListProvider>(context, listen: false)
        .DetailssLoader(widget.CurrentDate);
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(236, 236, 236, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop([
                  Provider.of<RoomReservationListProvider>(context,
                          listen: false)
                      .ReserveRoomList
                      .clear(),
                  //is it want?
                  Provider.of<RoomReservationListProvider>(context,
                          listen: false)
                      .addToCartPopUpAnimationController
                      .reverse()
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
            'Reserve Room',
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Consumer<RoomReservationListProvider>(
            builder: (context, connector, child) {
          //want to set an circular loading screen

          // connector.DetailsLoader(widget.CurrentDate);

          return Stack(children: [
            connectivityResult == ConnectivityResult.none
                ? NoNetworkDisplay(context)
                : connector.isFetching
                    ? connector.buildShimmerItems(context)
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            //  here we wiil add the filter button
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //opens the dialog to filter
                                    connector.filterDialog(context);
                                    // connector.getReservedDocs(
                                    //     currentDate: widget.CurrentDate);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(68, 142, 74, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 2, // Added elevation
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16), // Adjusted padding
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Increased spacing between text and icon
                                      Icon(
                                        Icons.filter_list,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            connector.buildFloorListView(
                                context, '1st Floor', connector.Floor1List),
                            connector.buildFloorListView(
                                context, '2nd Floor', connector.Floor2List),
                            connector.buildFloorListView(
                                context, '3rd Floor', connector.Floor3List),
                          ],
                        ),
                      ),
          ]);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: connectivityResult == ConnectivityResult.none
            ? Container()
            : Consumer<RoomReservationListProvider>(
                builder: (context, value, child) {
                return value.ReserveRoomList.isNotEmpty
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
                                              RoomReservationBooking(
                                                CurrentDate: widget.CurrentDate,
                                                ReservedRoomList: Provider.of<
                                                            RoomReservationListProvider>(
                                                        context,
                                                        listen: false)
                                                    .ReserveRoomList,
                                                FormattedCurrentDate:
                                                    widget.FormattedCurrentDate,
                                              )),
                                    ).then((value) => Provider.of<
                                                RoomReservationListProvider>(
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
        //             builder: (context) => RoomReservationBooking(
        //                   CurrentDate: widget.CurrentDate,
        //                   ReservedRoomList:
        //                       Provider.of<RoomReservationListProvider>(context,
        //                               listen: false)
        //                           .ReserveRoomList,
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
