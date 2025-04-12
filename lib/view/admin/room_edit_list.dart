//import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jnn_erp/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/room_edit_list_provider.dart';
// import 'package:jnn_erp/view_model/admin/rooms_page_view_model.dart';
//import 'package:jnn_erp/view/reseptionist/homepage.dart';

import 'package:provider/provider.dart';

class RoomsEditList extends StatefulWidget {
  const RoomsEditList({super.key});

  @override
  RoomsEditListstate createState() => RoomsEditListstate();
}

class RoomsEditListstate extends State<RoomsEditList> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    Provider.of<RoomsEditListProvider>(context, listen: false)
        .NotAvailablecheck = false; //for the not Availble filter
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
    Provider.of<RoomsEditListProvider>(context, listen: false)
        .DetailssLoader(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              // if (connectivityResult == ConnectivityResult.none) {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute<void>(
              //           builder: (BuildContext context) => const Homepage()),
              //       (route) => false);
              // } else {
              //   Navigator.of(context).pop();
              // }
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
      body:
          Consumer<RoomsEditListProvider>(builder: (context, connector, child) {
        //want to set an circular loading screen

        return Stack(children: [
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
