// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/reseptionist/homepage.dart';
import 'package:order_now_android/view/utilitie/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  //final formKey = GlobalKey<FormState>();
//  var formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  //loadig logging
  bool isProcessing = false;

  // to hide the button if no typo are there
  bool hidebutton = false;

  // Initially password is obscure
  bool obscureText = true;

  // Toggles the password show status
  void toggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void clearFiealds() {
    usernamecontroller.clear();
    passcontroller.clear();
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit  App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () =>
                    SystemNavigator.pop(), // is it works?  androis ios?
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  users? Loggeduser = users.Receptionist; //enum for radio button.
  // can we return a function value like this

  //For the on change();
  void RadioFinder(
    users selectedValue,
  ) {
    Loggeduser = selectedValue;
    notifyListeners();
    // print(' testcvvc ${selectedValue}'); its returning the selected value.
  }

//firebase checking the reception doc if the username and password is correct then the user can go to Reception page

  Future<void> ReceptionCheck(BuildContext context, users? Loggeduser,
      String username, String password) async {
    notifyListeners();
    try {
      var dataRetriver = FirebaseFirestore.instance.collection('credentials');
      var docsnapshot = await dataRetriver.doc('reception').get();
      if (docsnapshot.exists) {
        if (kDebugMode) {
          print('its available on the colection');
        }
        Map<String, dynamic>? data = docsnapshot.data();
        var uname = data?['Username'];
        var pass = data?['Password'];
        if (kDebugMode) {
          print(uname);
        }
        if (kDebugMode) {
          print(pass);
        }
        if (usernamecontroller.text != uname && passcontroller.text != pass) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Username and password'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  usernamecontroller.clear();
                  passcontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (usernamecontroller.text != uname) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Username'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  usernamecontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (passcontroller.text != pass) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Password'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  passcontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          if (kDebugMode) {
            print('Sign in succesfull // saved to shared');
          }
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString('Username', usernamecontroller.text.toString());
          sp.setString('Password', passcontroller.text.toString());
          //  sp.setString('CurrentUser', users.Receptionist as String);
          sp.setBool('isReception', true); //test
          sp.setBool('isLogin', true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomepageResp()));
          clearFiealds();
          //  isProcessing = false;
          // notifyListeners();
        }
      } else {
        if (kDebugMode) {
          print('the doc not existsts');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//firebase checking the admin doc if the username and password is correct then the user can go to admin page
  Future<void> AdminCheck(BuildContext context, users? Loggeduser,
      String username, String password) async {
    notifyListeners();
    try {
      var dataRetriver = FirebaseFirestore.instance.collection('credentials');
      var docsnapshot = await dataRetriver.doc('admin').get();
      if (docsnapshot.exists) {
        if (kDebugMode) {
          print('its available on the colection');
        }
        Map<String, dynamic>? data = docsnapshot.data();
        var uname = 'Admin@Jnn';
        var pass = 'Jnn@123A';
        if (kDebugMode) {
          print(uname);
        }
        if (kDebugMode) {
          print(pass);
        }
        if (usernamecontroller.text != uname && passcontroller.text != pass) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Username and password'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  usernamecontroller.clear();
                  passcontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (usernamecontroller.text != uname) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Username'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  usernamecontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (passcontroller.text != pass) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text('Invalid Password'),
            backgroundColor: const Color.fromARGB(255, 218, 13, 13),
            elevation: 5,
            action: SnackBarAction(
                textColor: Colors.white,
                label: 'clear',
                onPressed: () {
                  passcontroller.clear();
                }),
          );
          isProcessing = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          if (kDebugMode) {
            print('Sign in succesfull // saved to shared');
          }
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString('Username', usernamecontroller.text.toString());
          sp.setString('Password', passcontroller.text.toString());
          //   sp.setString('CurrentUser', users.Admin as String);
          sp.setBool('isAdmin', true); //test
          sp.setBool('isLogin', true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
          clearFiealds();
          //  isProcessing = false;
          // notifyListeners();
        }
      } else {
        if (kDebugMode) {
          print('the doc not existsts');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
