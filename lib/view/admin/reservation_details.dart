import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/reservation_history_page.dart';
import 'package:order_now_android/view/admin/sheduled_dates.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class ReservationDetailsTypePage extends StatefulWidget {
  const ReservationDetailsTypePage({
    super.key,
  });

  @override
  ReservationDetailsTypePagestate createState() =>
      ReservationDetailsTypePagestate();
}

class ReservationDetailsTypePagestate
    extends State<ReservationDetailsTypePage> {
  @override
  Widget build(BuildContext context) {
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
          'Reservation Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),

          //reservation details upcoming Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Bounceable(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const SheduledDatePage()));
                if (kDebugMode) {
                  print('sheduled ,upcoming room reservation');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        //spreadRadius: 4,
                        offset: Offset(0, 4))
                  ],
                  borderRadius: BorderRadius.circular(9),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                height: MediaQuery.of(context).size.height / 10,
                //width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Center(
                        child: SizedBox(
                          height: 29,
                          width: 29,
                          child: Image.asset(
                            'assets/images/reserving.png',
                            scale: 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ), // it creates the green circular icons
                    const Text('Sheduled Rooms',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.5,
                          fontWeight: FontWeight.w700,
                        )),

                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: SizedBox(
                        height: 13,
                        width: 13,
                        child: Image.asset(
                          'assets/images/right-arrow.png',
                          scale: 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //old details Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Bounceable(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const ReservationHistoryPage()));

                if (kDebugMode) {
                  print('Old details will Load');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        //spreadRadius: 4,
                        offset: Offset(0, 4))
                  ],
                  borderRadius: BorderRadius.circular(9),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                height: MediaQuery.of(context).size.height / 10,
                //width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/history.png',
                            scale: 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ), // it creates the green circular icons
                    const Text('Reservation History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.5,
                          fontWeight: FontWeight.w700,
                        )),

                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: SizedBox(
                        height: 13,
                        width: 13,
                        child: Image.asset(
                          'assets/images/right-arrow.png',
                          scale: 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
