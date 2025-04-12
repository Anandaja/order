import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jnn_erp/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/reservation_history_provider.dart';
import 'package:provider/provider.dart';

class ReservationHistoryPage extends StatefulWidget {
  const ReservationHistoryPage({super.key});
  @override
  ReservationHistoryPagestate createState() => ReservationHistoryPagestate();
}

class ReservationHistoryPagestate extends State<ReservationHistoryPage> {
  // ConnectivityResult? connectivityResult;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult;
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

  // Future<bool> showExitPopup() async {
  //   if (connectivityResult == ConnectivityResult.none) {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute<void>(
  //             builder: (BuildContext context) => const Homepage()),
  //         (route) => false);
  //   }
  //   // Navigator.of(context).pop();
  //   return true;
  //   //if showDialouge had returned null, then return false
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<ReservationHistoryProvider>(context, listen: false)
        .DetailsLoader(context);
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
          'Reservation History',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<ReservationHistoryProvider>(
          builder: (context, consumer, child) {
        return Stack(children: [
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplay(context)
              : consumer.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(68, 142, 74, 1),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          consumer.buildcustomerTiles(
                            context,
                            'Normal Rooms',
                            consumer.ReserveRoomsList,
                            'Sheduled to ',
                          ),
                          consumer.buildcustomerTiles(
                            context,
                            'Dormitorys',
                            consumer.ReserveDormitoryList,
                            'Sheduled to ',
                          ),
                          consumer.buildcustomerTiles(
                            context,
                            'Homestay',
                            consumer.HomestayReserveList,
                            'Sheduled to ',
                          ),
                        ],
                      ),
                    ),
        ]);
      }),
    );
  }
}
