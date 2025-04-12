import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/sheduled_dates_view_model.dart';

import 'package:provider/provider.dart';

class SheduledDatePage extends StatefulWidget {
  const SheduledDatePage({super.key});

  @override
  SheduledDatePagestate createState() => SheduledDatePagestate();
}

class SheduledDatePagestate extends State<SheduledDatePage> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  void initState() {
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
    Provider.of<SheduledDateProvider>(context, listen: false)
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
          'Sheduled Rooms',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<SheduledDateProvider>(builder: (context, consumer, child) {
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
                            'Dormitory',
                            consumer.ReserveDormitoryList,
                            'Sheduled to ',
                          ),
                          consumer.buildcustomerTiles(
                            context,
                            'HomeStay',
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
