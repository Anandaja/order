import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/dormitory_admin.dart';
import 'package:order_now_android/view/admin/homestay.dart';
import 'package:order_now_android/view/admin/rooms_admin.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class RoomCatogaryPageAdmin extends StatefulWidget {
  const RoomCatogaryPageAdmin({super.key});

  @override
  RoomCatogaryPageAdminstate createState() => RoomCatogaryPageAdminstate();
}

class RoomCatogaryPageAdminstate extends State<RoomCatogaryPageAdmin> {
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
    // connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    //   //connectivity listner
    //   if (mounted) {
    //     setState(() {
    //       connectivityResult = result;
    //       print("Connectivity result $result");
    //     });
    //   }
    //   // log(result.name);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(0, 255, 0, 0),
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Category',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                width: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  height: 10,
                  width: 10,
                  // margin: EdgeInsets.all(100.0),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(253, 186, 63, 1),
                      shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
        // actions: [
        //   PopupMenuButton(
        //       icon: const Icon(
        //         Icons.more_vert_rounded,
        //         color: Colors.black,
        //       ),
        //       color: Colors.white,
        //       itemBuilder: (BuildContext context) {
        //         return [
        //           PopupMenuItem(
        //             child: const Text(
        //               'Advanced Edit',
        //               style: TextStyle(fontWeight: FontWeight.w500),
        //             ),
        //             onTap: () {
        //               Navigator.push(
        //                   context,
        //                   CupertinoPageRoute(
        //                       builder: (context) => const SettingsPage()));
        //             },
        //           ),
        //         ];
        //       })
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            //ROOMS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Bounceable(
                onTap: () {
                  //on tap to navigate aLL room details page
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => RoomsPageAdmin(
                                passedResult: connectivityResult,
                              )));

                  if (kDebugMode) {
                    print('tapped room');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  height: MediaQuery.of(context).size.height / 9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          color: Color.fromRGBO(68, 142, 74, 1),
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          child: Image.asset(
                            'assets/images/SixBed Rooms.jpeg',
                            fit: BoxFit
                                .cover, // Ensure the image fully covers the container without distortion.
                          ),
                        ),
                      ),
                      const Text(
                        'ROOMS',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
            //dormitory
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Bounceable(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => DormitoryPageAdmin(
                                passedResult: connectivityResult,
                              )));
                  //on tap to navigate aLL Dormatory details page
                  if (kDebugMode) {
                    print('Dormataory');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  height: MediaQuery.of(context).size.height / 9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          color: Color.fromRGBO(68, 142, 74, 1),
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          child: Image.asset(
                            'assets/images/dormatory.jpg',
                            fit: BoxFit
                                .cover, // Ensure the image fully covers the container without distortion.
                          ),
                        ),
                      ),
                      const Text(
                        'DORMATORY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              21, //set the font size by checking 22 or 21 on mobile
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
            const SizedBox(
              height: 30,
            ),
            //homestay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Bounceable(
                onTap: () {
                  //on tap to navigate aLL Homestay details page
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AdminHomestayPage(
                                passedResult: connectivityResult,
                              )));

                  if (kDebugMode) {
                    print('Homestay');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.27),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  height: MediaQuery.of(context).size.height / 9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          color: Color.fromRGBO(68, 142, 74, 1),
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        height: MediaQuery.of(context).size.height / 9,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                          child: Image.asset(
                            'assets/images/Homestay.jpeg',
                            fit: BoxFit
                                .cover, // Ensure the image fully covers the container without distortion.
                          ),
                        ),
                      ),
                      const Text(
                        'HOMESTAY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              21, //set the font size by checking 22 or 21 on mobile
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(41, 105, 52, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Available',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 0, 0, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Not Available',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
