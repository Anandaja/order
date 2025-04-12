//import 'package:flutter/foundation.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/rooms_page_view_model.dart';
//import 'package:jnn_erp/view/reseptionist/homepage.dart';

import 'package:provider/provider.dart';

class RoomsPageAdmin extends StatefulWidget {
  const RoomsPageAdmin({super.key, required this.passedResult});

  final ConnectivityResult? passedResult;

  @override
  RoomsPageAdminstate createState() => RoomsPageAdminstate();
}

class RoomsPageAdminstate extends State<RoomsPageAdmin> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  String connectivityCheck(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return "You are now connected to wifi";
    } else if (result == ConnectivityResult.mobile) {
      return "You are now connected to mobile data";
    } else if (result == ConnectivityResult.ethernet) {
      return "You are now connected to ethernet";
    } else if (result == ConnectivityResult.bluetooth) {
      return "You are now connected to bluetooth";
    } else if (result == ConnectivityResult.none) {
      return "No connection available";
    } else {
      return "No Connection!!";
    }
  }

  @override
  void initState() {
    Provider.of<AdminRoomsProvider>(context, listen: false).NotAvailablecheck =
        false; //for the not Availble filter
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult?;
        });
      }
    });
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

//modify this
  Future<bool> NointernetPopup() async {
    if (widget.passedResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.none) {
      return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: ThemeData(
                  dialogBackgroundColor:
                      const Color.fromARGB(255, 248, 247, 247),
                ),
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // const SizedBox(
                      //   height: 12,
                      // ),
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.asset(
                          'assets/images/404 logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Text(
                        'No internet. Try again later',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(68, 142, 74, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2, // Added elevation
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16), // Adjusted padding
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const Homepage()),
                                  (route) => false);
                            },
                            child: Text(
                              "Back to Home",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      // SizedBox(
                      //   height: 12,
                      // ),
                    ],
                  ),
                ),
              );
            },
          ) ??
          false; //if showDialouge had returned null, then return false
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AdminRoomsProvider>(context, listen: false)
        .DetailssLoader(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              //  Provider.of<AdminRoomsViewmodel>(context, listen: false)
              //     .resetFilter();
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
          'Room Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<AdminRoomsProvider>(builder: (context, connector, child) {
        //want to set an circular loading screen

        return Stack(children: [
          // widget.passedResult == ConnectivityResult.none ||
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplay(context)
              : connector.isFetching
                  ? connector.buildShimmerItems(context)
                  /*const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(68, 142, 74, 1),
                  ),
                )*/
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 17,
                          ),
                          //  here we wiil add the filter button
                          Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  //opens the dialog to filter
                                  connector.filterDialog(context);
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 10, right: 10),
      //   child: FloatingActionButton(
      //       backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Provider.of<AdminRoomsViewmodel>(context, listen: false)
      //             .showAlertDialog(context);
      //         if (kDebugMode) {
      //           print('pressed');
      //         }
      //       }),
      // ),
    );
  }
}
