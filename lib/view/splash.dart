import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/loginpage.dart';
import 'package:order_now_android/view/reseptionist/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      //  sp.clear(); on the logout button on pressed we want add this, then navigate him back to login page
      bool? isLogin = sp.getBool('isLogin') ?? false;
      bool? isReception = sp.getBool('isReception') ?? false;

      bool? isAdmin = sp.getBool('isAdmin') ?? false;
      if (isLogin) {
        if (isReception) {
          if (kDebugMode) {
            print('Reception $isReception');
          }
          Timer(const Duration(seconds: 3), () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const HomepageResp()));
          });
        } else if (isAdmin) {
          if (kDebugMode) {
            print('Admin $isAdmin');
          }
          Timer(const Duration(seconds: 3), () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const Homepage()));
          });
        }
      } else {
        Timer(
            const Duration(seconds: 4),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Loginpage(title: 'title'))));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF296934),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                  width: 200, // size is correct??
                  height: 150,
                  child: SvgPicture.asset('assets/images/Jnn white Logo.svg',
                      alignment: Alignment.topCenter)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
