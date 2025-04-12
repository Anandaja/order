// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/loginpage.dart';
import 'package:order_now_android/view/reseptionist/customer_details_page.dart';
import 'package:order_now_android/view/reseptionist/room_catogary_page.dart';
import 'package:order_now_android/view/reseptionist/rooms.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageResp extends StatefulWidget {
  const HomepageResp({super.key});

  @override
  HomepageRespstate createState() => HomepageRespstate();
}

class HomepageRespstate extends State<HomepageResp> {
  Future<void> iconDialog() async {
    // to logout the app
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: const Color.fromARGB(255, 248, 247, 247),
          ),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            // <-- SEE HERE
            titlePadding: const EdgeInsets.all(0),

            title: Stack(alignment: Alignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.65,
                // padding: const EdgeInsets.only(
                //   top: 18.0,
                // ),
                // margin: EdgeInsets.only(top: 13.0, right: 8.0),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(68, 142, 74, 1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0.0, 4),
                      ),
                    ]),
              ),
              Positioned(
                child: ClipRRect(
                  child: SizedBox(
                    width: 150, // size is correct??
                    height: 100,
                    child: SvgPicture.asset('assets/images/Jnn white Logo.svg',
                        // alignment: Alignment.topCenter
                        fit: BoxFit.contain),
                    // child: Image.asset(
                    //   'assets/images/white logo.png',
                    //   fit: BoxFit.contain,
                    //   filterQuality: FilterQuality.high,
                    // ),
                  ),
                ),
              ),
            ]),
            //    content: Container(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                //row buttons
                Bounceable(
                  onTap: () {
                    Navigator.of(context).pop(); //pop before navigate
                    _showAlertDialog();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            color: Color.fromARGB(255, 255, 255, 255)),
                        child: Center(
                          child: SizedBox(
                            height: 38,
                            width: 38,
                            child: Image.asset(
                              'assets/images/logout.png',
                              scale: 1,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Logout',
                        style: GoogleFonts.nunitoSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAlertDialog() async {
    // to logout the app
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          // <-- SEE HERE
          title: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/images/logout.png',
                  scale: 1,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('You want to Logout'),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(0, 255, 255, 255))),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(0, 255, 255, 255))),
              child: const Text('Yes'),
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.clear();
                print('Logout succesfull removed from shared');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Loginpage(title: 'title')));
              },
            ),
          ],
        );
      },
    );
  }

  //quick alert dialog
  Future<bool> test() async {
    return await QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'Oops...',
            text: 'Are you sure you want to leave?',
            confirmBtnColor: const Color.fromRGBO(68, 142, 74, 1),
            confirmBtnText: 'Yes',
            cancelBtnText: 'No',
            showCancelBtn: true,
            onConfirmBtnTap: () => SystemNavigator.pop(),
            onCancelBtnTap: () => Navigator.of(context).pop(false)) ??
        false; //if showDialouge had returned null, then return false
  }

  // for The back press of the app
  // Future<bool> showExitPopup() async {
  //   return await showDialog(
  //         //show confirm dialogue
  //         //the return value will be from "Yes" or "No" options
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.zero,
  //           ),
  //           title: const Text('Exit App'),
  //           content: const Text('Do you want to exit  App?'),
  //           actions: [
  //             TextButton(
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(
  //                       const Color.fromARGB(0, 255, 255, 255))),
  //               onPressed: () => Navigator.of(context).pop(false),
  //               //return false when click on "NO"
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(
  //                       const Color.fromARGB(0, 255, 255, 255))),
  //               onPressed: () =>
  //                   SystemNavigator.pop(), // is it works?  androis ios?
  //               //return true when click on "Yes"
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false; //if showDialouge had returned null, then return false
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //check in real device and fix the pop error .
      onWillPop: () => test(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reception',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Bounceable(
                      onTap: () {
                        iconDialog();
                        // _showAlertDialog();
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            border: Border.all(
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: const Color.fromRGBO(58, 57, 57, 0.3)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(9)),
                            color: Colors.transparent),
                        child: Center(
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: Image.asset(
                              'assets/images/Green logo.png',
                              scale: 1,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              const SizedBox(
                height: 60,
              ),
              //room details tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Bounceable(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const RoomCatogaryPage()));
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
                    height: MediaQuery.of(context).size.height / 12,
                    //width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                bottomLeft: Radius.circular(9)),
                            color: Color.fromRGBO(68, 142, 74, 1),
                          ),
                          width: 55,
                          // height: 70,
                          height: MediaQuery.of(context).size.height / 12,
                          child: Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: Image.asset(
                                'assets/images/room.png',
                                scale: 1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ), // it creates the green circular icons
                        const Text('ROOM DETAILS',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
              // const SizedBox(
              //   height: 30,
              // ),
              // //Tour details tile
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 35),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate to tour details page

              //       print('tappeddd tour');
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: const [
              //           BoxShadow(
              //               color: Color.fromRGBO(0, 0, 0, 0.27),
              //               blurRadius: 4,
              //               // spreadRadius: 2,
              //               offset: Offset(0, 4))
              //         ],
              //         borderRadius: BorderRadius.circular(9),
              //         color: const Color.fromARGB(255, 255, 255, 255),
              //       ),
              //       height: MediaQuery.of(context).size.height / 12,
              //       // width: MediaQuery.of(context).size.width / 11,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(9),
              //                   bottomLeft: Radius.circular(9)),
              //               color: Color.fromRGBO(68, 142, 74, 1),
              //             ),
              //             width: 55,
              //             //height: 70,
              //             height: MediaQuery.of(context).size.height / 12,
              //             child: Center(
              //               child: SizedBox(
              //                 height: 22,
              //                 width: 22,
              //                 child: Image.asset(
              //                   'assets/images/brochure.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('TOUR DETAILS',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.w500,
              //               )),

              //           Padding(
              //             padding: const EdgeInsets.only(right: 18),
              //             child: SizedBox(
              //               height: 13,
              //               width: 13,
              //               child: Image.asset(
              //                 'assets/images/right-arrow.png',
              //                 scale: 1,
              //                 fit: BoxFit.contain,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              //customer tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Bounceable(
                  onTap: () {
                    //on tap to navigate to customer details page
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CustomerDetailsPage()));
                    if (kDebugMode) {
                      print('tappeddd customer');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.27),
                            blurRadius: 4,
                            // spreadRadius: 2,
                            offset: Offset(0, 4))
                      ],
                      borderRadius: BorderRadius.circular(9),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    height: MediaQuery.of(context).size.height / 12,
                    // width: MediaQuery.of(context).size.width / 11,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(9),
                                bottomLeft: Radius.circular(9)),
                            color: Color.fromRGBO(68, 142, 74, 1),
                          ),
                          width: 55,
                          //height: 70,
                          height: MediaQuery.of(context).size.height / 12,
                          child: Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: Image.asset(
                                'assets/images/customer.png',
                                scale: 1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ), // it creates the green circular icons
                        const Text('CUSTOMER DETAILS',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
              const SizedBox(
                height: 30,
              ),
              // //Finance
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 35),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate finance details page

              //       if (kDebugMode) {
              //         print('tappeddd finance');
              //       }
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: const [
              //           BoxShadow(
              //               color: Color.fromRGBO(0, 0, 0, 0.27),
              //               blurRadius: 4,
              //               // spreadRadius: 2,
              //               offset: Offset(0, 4))
              //         ],
              //         borderRadius: BorderRadius.circular(9),
              //         color: const Color.fromARGB(255, 255, 255, 255),
              //       ),
              //       height: MediaQuery.of(context).size.height / 12,
              //       // width: MediaQuery.of(context).size.width / 11,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(9),
              //                   bottomLeft: Radius.circular(9)),
              //               color: Color.fromRGBO(68, 142, 74, 1),
              //             ),
              //             width: 55,
              //             //height: 70,
              //             height: MediaQuery.of(context).size.height / 12,
              //             child: Center(
              //               child: SizedBox(
              //                 height: 22,
              //                 width: 22,
              //                 child: Image.asset(
              //                   'assets/images/budget.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('FINANACE DETAILS',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.w500,
              //               )),

              //           Padding(
              //             padding: const EdgeInsets.only(right: 18),
              //             child: SizedBox(
              //               height: 13,
              //               width: 13,
              //               child: Image.asset(
              //                 'assets/images/right-arrow.png',
              //                 scale: 1,
              //                 fit: BoxFit.contain,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 23, bottom: 35),
          child: SpeedDial(
            //Speed dial menu
            // marginBottom: 10, //margin bottom
            icon: Icons.add, //icon on Floating action button
            activeIcon: Icons.close, //icon when menu is expanded on button
            backgroundColor: const Color.fromRGBO(
                68, 142, 74, 1), //background color of button
            foregroundColor: Colors.white, //font color, icon color in button
            activeBackgroundColor: const Color.fromRGBO(
                126, 198, 121, 1), //background color when menu is expanded
            activeForegroundColor: Colors.white,
            buttonSize: const Size(42, 42), //button size
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn, //check this widget ???????????
            overlayColor: Colors.transparent,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'), // action when menu opens
            onClose: () => print('DIAL CLOSED'), //action when menu closes

            elevation: 8.0, //shadow elevation of button
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10))), //shape of button
            spacing: 10,

            children: [
              SpeedDialChild(
                //speed dial child
                child: Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: Image.asset(
                      'assets/images/room.png',
                      scale: 1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                backgroundColor: const Color.fromRGBO(253, 185, 63, 1),
                foregroundColor: Colors.white,
                label: 'Book Room',
                labelStyle: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w500),
                onTap: () {
                  //room details navigation
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoomsPage()));
                  print('roombook');
                },
                onLongPress: () => print('FIRST CHILD LONG PRESS'),
              ),
              // SpeedDialChild(
              //   child: Center(
              //     child: SizedBox(
              //       height: 22,
              //       width: 22,
              //       child: Image.asset(
              //         'assets/images/budget.png',
              //         scale: 1,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              //   backgroundColor: const Color.fromRGBO(41, 105, 52, 1),
              //   foregroundColor: Colors.white,
              //   label: 'Upload Expense',
              //   labelStyle: const TextStyle(
              //       fontSize: 18.0, fontWeight: FontWeight.w500),
              //   onTap: () {
              //     //expence navigation
              //     print('uploadexpense');
              //   },
              //   onLongPress: () => print('SECOND CHILD LONG PRESS'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
