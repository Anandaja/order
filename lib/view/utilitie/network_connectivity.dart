// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/reseptionist/homepage.dart';

//widget to display if there is no internet connection
Widget NoNetworkDisplay(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 350,
          width: 350,
          child: Image.asset(
            'assets/images/404 logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const Text(
          'No internet. Try again later',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2, // Added elevation
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16), // Adjusted padding
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Homepage()),
                  (route) => false);
            },
            child: const Text(
              "Back to Home",
              style: TextStyle(color: Colors.white),
            ))
      ],
    ),
  );
}

//dialog for backing fromthe network error page
Future<void> NoInternetDialog(
  BuildContext context,
) async {
  // to logout the app

  return showDialog(
    barrierDismissible: false,
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2, // Added elevation
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16), // Adjusted padding
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
  );
}

//for reception
Future<void> NoInternetDialogReception(
  BuildContext context,
) async {
  // to logout the app

  return showDialog(
    barrierDismissible: false,
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2, // Added elevation
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16), // Adjusted padding
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const HomepageResp()),
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
  );
}

//for reception
Widget NoNetworkDisplayReception(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 350,
          width: 350,
          child: Image.asset(
            'assets/images/404 logo.png',
            fit: BoxFit.contain,
          ),
        ),
        const Text(
          'No internet. Try again later',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2, // Added elevation
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16), // Adjusted padding
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomepageResp()),
                  (route) => false);
            },
            child: const Text(
              "Back to Home",
              style: TextStyle(color: Colors.white),
            ))
      ],
    ),
  );
}
