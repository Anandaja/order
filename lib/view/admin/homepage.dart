// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:jnn_erp/model/wether_model.dart';
//import 'package:jnn_erp/view/admin/calender_page.dart';
// import 'package:jnn_erp/view/admin/select_reservation%20type.dart';
import 'package:lottie/lottie.dart';
import 'package:order_now_android/view/admin/advanced_Data_edit_page.dart';
import 'package:order_now_android/view/admin/customer_details_admin.dart';
import 'package:order_now_android/view/admin/room_catogary_admin.dart';
import 'package:order_now_android/view/admin/select_reservation%20type.dart';
import 'package:order_now_android/view/loginpage.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/whether_api_service.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jnn_erp/view/admin/customer_details_admin.dart';
// import 'package:jnn_erp/view/admin/room_catogary_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  Homepagestate createState() => Homepagestate();
}

class Homepagestate extends State<Homepage> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //settings
                    Bounceable(
                      onTap: () {
                        Navigator.of(context).pop(); //pop before navigate
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SettingsPage()));
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: const BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color.fromRGBO(0, 0, 0, 0),
                                //     blurRadius: 4,
                                //     offset: Offset(0, 4),
                                //   ),
                                // ],
                                // border: Border.all(
                                //   //  strokeAlign: BorderSide.strokeAlignOutside,
                                //     color: const Color.fromRGBO(58, 57, 57, 0.3)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                color: Color.fromARGB(255, 255, 255, 255)),
                            child: Center(
                              child: SizedBox(
                                height: 38,
                                width: 38,
                                child: Image.asset(
                                  'assets/images/pencil.png',
                                  //'assets/images/Setting.png',
                                  scale: 1,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Settings',
                            style: GoogleFonts.nunitoSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    //Logout
                    Bounceable(
                      onTap: () {
                        Navigator.of(context).pop(); //pop before navigate
                        _showAlertDialog();
                        // Timer(
                        //   const Duration(seconds: 1),
                        //   () {
                        //     _showAlertDialog();
                        //   },
                        // );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: const BoxDecoration(
                                // border: Border.all(
                                //   //  strokeAlign: BorderSide.strokeAlignOutside,
                                //     color: const Color.fromRGBO(58, 57, 57, 0.3)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
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
                  ],
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
              SizedBox(
                width: 4,
              ),
              Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Confirm logout by clicking yes'),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(0, 255, 255, 255))),
              child: const Text(
                'No',
              ),
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

                if (kDebugMode) {
                  print('Logout succesfull removed from shared');
                }
                sp.clear();
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

  int? temperature;
  // String? condition; //just shos the condition text like cloud etc
  int? condition;
  int? humidity;
  String? country;
  String? city;
  String? weatherIcon;
  WeatherModel weatherModel = WeatherModel();

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  ConnectivityResult? toPass;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    ///works but
    //we need to check after each baacking // i think we also add the onConnectivity changed??
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult;
          toPass = value as ConnectivityResult?;
          print("Connectivity result from this page$value");
        });
      }
    });
    // connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    //   //connectivity listner
    //   if (mounted) {
    //     setState(() {
    //       connectivityResult = result;
    //       toPass = result;
    //       print("Connectivity result from this page$result");
    //     });
    //   }
    //   // log(result.name);
    // });
    super.initState();
    // getLocationData();
  }

  /// variable weatherData contain response from the API
  /// to fetch data check the response to get the way the data structured
  // getLocationData() async {
  //   var weatherData = await weatherModel.getLocationWeather();
  //   setState(() {
  //     condition = weatherData['weather'][0]['main'];
  //     humidity = weatherData['main']['humidity'];
  //     country = weatherData['sys']['country'];
  //     city = weatherData['name'];
  //     double temp = weatherData['main']['temp'];
  //     temperature = temp.toInt();
  //   });
  //   if (kDebugMode) {
  //     print("${temperature.toString()} C");
  //     print("Contry $country");
  //     print("Condition $condition");
  //     print("City $city");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Admin',
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
              //   height: 23,
              // ),
              // const SizedBox(
              //   height: 50,
              // ),
              const SizedBox(
                height: 40,
              ),

              //api
              FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If error occured
                    if (snapshot.hasError) {
                      //if there is error when fetching api data it will diplay this image
                      print("Erro on loading api ${snapshot.error}");
                      return Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: Image.asset(
                              'assets/images/offline.png',
                              scale: 1,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );

                      // if data has no errors
                    } else if (snapshot.hasData) {
                      //if no error, Extracting data from snapshot object
                      //added try and catch if there is any error while fetching display the offline image
                      try {
                        final weatherData = snapshot.data;
                        // condition = weatherData['weather'][0]['main'];//string condition shows cloud text
                        // var condition = weatherData['weather'][0]['id'];
                        humidity = weatherData['main']['humidity'];
                        country = weatherData['sys']['country'];
                        city = weatherData['name'];
                        double temp = weatherData['main']['temp'];
                        // weatherIcon = weatherModel.getWeatherIcon(condition);
                        temperature = temp.toInt();
                        weatherIcon = weatherModel.ShowAsset(temperature!);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${temperature.toString()}°C",
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 55,
                                      color: Color.fromRGBO(68, 142, 74, 1),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 4,
                                  // ),
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Lottie.asset(
                                      weatherIcon!,
                                      frameRate: FrameRate(60),
                                      repeat: true,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // Text("$weatherIcon",
                                  //     style: const TextStyle(
                                  //       // color: Colors.black,
                                  //       fontSize: 20,
                                  //       // fontWeight: FontWeight.w500,
                                  //     ))
                                  // Text("Contry $country"),
                                  // Text("Condition $condition"),
                                  // Text("City $city"),
                                  // Text("icon $weatherIcon")
                                ],
                              ),
                              Text(
                                'Marayoor',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        print("Error on conversion $e");
                        return Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: SizedBox(
                              height: 45,
                              width: 45,
                              child: Image.asset(
                                'assets/images/offline.png',
                                scale: 1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color.fromRGBO(68, 142, 74, 1),
                            ),
                          )),
                    );
                  }
                  // else {
                  //   return Center(
                  //     child: Text("${snapshot.connectionState} Wether"),
                  //   );
                  // }
                  //if there is no network or default
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/images/offline.png',
                          scale: 1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
                future: weatherModel.getLocationWeather(),
              ),
              const SizedBox(
                height: 30,
              ),
              //room Grid new
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Bounceable(
                          onTap: () {
                            // Rooms catogary page
                            //room details on tap

                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const RoomCatogaryPageAdmin()));
                            if (kDebugMode) {
                              print('tappeddd room');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 122, 190, 117)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.27),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 126, 198, 121),
                            ),
                            height: MediaQuery.of(context).size.height / 6.5,
                            width: MediaQuery.of(context).size.width / 2.9,
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          topRight: Radius.circular(14)),
                                      color: Color.fromRGBO(253, 186, 63, 0),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 75,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: SizedBox(
                                        height: 42,
                                        width: 42,
                                        child: Image.asset(
                                          'assets/images/room icon.png',
                                          scale: 1,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 12,
                                  // ),
                                  Text(
                                    'Bookings',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: const TextStyle(
                                            fontSize: 21,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Bounceable(
                          onTap: () {
                            // Rooms customers page
                            //on tap to navigate to customer details page
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        AdminCustomerDetailsPage(
                                          passedResult: toPass,
                                        )));
                            if (kDebugMode) {
                              print('tappeddd customer');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 122, 190, 117)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.27),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 126, 198, 121),
                            ),
                            height: MediaQuery.of(context).size.height / 6.5,
                            width: MediaQuery.of(context).size.width / 2.9,
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          topRight: Radius.circular(14)),
                                      color: Color.fromRGBO(253, 186, 63, 0),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 75,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19),
                                      child: SizedBox(
                                        height: 42,
                                        width: 42,
                                        child: Image.asset(
                                          'assets/images/color_customer.png',
                                          scale: 1,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 12,
                                  // ),
                                  Text(
                                    'Customers',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: const TextStyle(
                                            fontSize: 21,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //reservation grid
              const SizedBox(
                height: 35,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Bounceable(
                    onTap: () {
                      //on tap to navigate to Calender Reservation page

                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => CalenderPage()));
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const SelectReservationTypePage()));

                      if (kDebugMode) {
                        print('tappeddd Reservation');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 122, 190, 117)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.27),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 126, 198, 121),
                      ),
                      height: MediaQuery.of(context).size.height / 6.5,
                      width: MediaQuery.of(context).size.width / 2.9,
                      child: Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14)),
                                color: Color.fromRGBO(253, 186, 63, 0),
                              ),
                              height: MediaQuery.of(context).size.height / 75,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 19),
                                child: SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: Image.asset(
                                    'assets/images/reserving.png',
                                    scale: 1,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 12,
                            // ),
                            Text(
                              'Reservation',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: const TextStyle(
                                      fontSize: 21,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //room details tile
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
              //   child: Bounceable(
              //     onTap: () {
              //       //room details on tap

              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //               builder: (context) =>
              //                   const RoomCatogaryPageAdmin()));
              //       if (kDebugMode) {
              //         print('tappeddd room');
              //       }
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: const [
              //           BoxShadow(
              //               color: Color.fromRGBO(0, 0, 0, 0.27),
              //               blurRadius: 4,
              //               //spreadRadius: 4,
              //               offset: Offset(0, 4))
              //         ],
              //         borderRadius: BorderRadius.circular(9),
              //         color: const Color.fromARGB(255, 255, 255, 255),
              //       ),
              //       height: MediaQuery.of(context).size.height / 12,
              //       //width: MediaQuery.of(context).size.width,
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
              //             // height: 70,
              //             height: MediaQuery.of(context).size.height / 12,
              //             child: Center(
              //               child: SizedBox(
              //                 height: 22,
              //                 width: 22,
              //                 child: Image.asset(
              //                   'assets/images/room.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('ROOM DETAILS',
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
              // const SizedBox(
              //   height: 23,
              // ),
              // //Tour details tile
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate to Calender Reservation page

              //       // Navigator.push(
              //       //     context,
              //       //     CupertinoPageRoute(
              //       //         builder: (context) => CalenderPage()));
              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //               builder: (context) =>
              //                   const SelectReservationTypePage()));

              //       if (kDebugMode) {
              //         print('tappeddd Reservation');
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
              //                 height: 27,
              //                 width: 27,
              //                 child: Image.asset(
              //                   'assets/images/reserve.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('RESERVATION',
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
              // const SizedBox(
              //   height: 23,
              // ),
              // //customer tile
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate to customer details page
              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //               builder: (context) => AdminCustomerDetailsPage(
              //                     passedResult: toPass,
              //                   )));
              //       if (kDebugMode) {
              //         print('tappeddd customer');
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
              //                   'assets/images/customer.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('CUSTOMER DETAILS',
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
              // const SizedBox(
              //   height: 23,
              // ),
              //Finance
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
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
              // const SizedBox(
              //   height: 23,
              // ),
              // //Employee Details
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate EMPLOYEE details page

              //       if (kDebugMode) {
              //         print('tappeddd EMPLOYEE ');
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
              //                   'assets/images/employees.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('EMPLOYEE DETAILS',
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
              // const SizedBox(
              //   height: 23,
              // ),
              // //Bussiness Overview
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 32),
              //   child: Bounceable(
              //     onTap: () {
              //       //on tap to navigate BUSSINESS details page

              //       if (kDebugMode) {
              //         print('tappeddd BUSSINESS');
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
              //                   'assets/images/stats.png',
              //                   scale: 1,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //             ),
              //           ), // it creates the green circular icons
              //           const Text('BUSSINESS REPORT',
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
      ),
    );
  }
}
