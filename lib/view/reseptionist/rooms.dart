import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'package:jnn_erp/view/reseptionist/homepage.dart';
import 'package:order_now_android/view_model/reception/rooms_view_model.dart';
import 'package:provider/provider.dart';

import '../utilitie/network_connectivity.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});
  @override
  RoomsPagestate createState() => RoomsPagestate();
}

class RoomsPagestate extends State<RoomsPage> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    Provider.of<RoomsProvider>(context, listen: false).NotAvailablecheck =
        false; //for the not Availble filter
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
    Provider.of<RoomsProvider>(context, listen: false).DetailsLoader();
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 236, 236, 1),
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
          'Room Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<RoomsProvider>(builder: (context, connector, child) {
        //want to set an circular loading screen

        // connector.DetailsLoader();

        return Stack(children: [
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplayReception(context)
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
    );
  }
}
