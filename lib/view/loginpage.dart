import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:order_now_android/view/admin/homepage.dart';
//import 'package:jnn_erp/view/admin/homepage.dart';
//import 'package:jnn_erp/view/reseptionist/homepage.dart';
import 'package:order_now_android/view/utilitie/enums.dart';
import 'package:order_now_android/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Provider.of<LoginProvider>(context, listen: false)
          .showExitPopup(context),
      child: Scaffold(
          body: Consumer<LoginProvider>(builder: (context, consumer, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0, bottom: 30),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: SvgPicture.asset(
                        'assets/images/JNN Tourist Home-optimized.svg',
                        alignment: Alignment.topCenter),
                    // child: Image.asset(
                    //   'assets/images/Jnn logo.svg',
                    //   //alignment: Alignment.topCenter,
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              //Radio buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    Radio(
                      activeColor: const Color.fromARGB(255, 0, 0, 0),
                      value: users.Receptionist,
                      groupValue: consumer.Loggeduser,
                      onChanged: (value) {
                           Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                        
                      },
                    ),
                    const Text(
                      'Reception',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Radio(
                      activeColor: const Color.fromARGB(255, 0, 0, 0),
                      value: users.Admin,
                      groupValue: consumer.Loggeduser,
                      onChanged: (value) {
                        
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                        // Provider.of<LoginProvider>(context, listen: false)
                        //     .RadioFinder(value!); // to change the state
                        // print('clicked Admin');
                        // print(consumer.Loggeduser);
                      },
                    ),
                    const Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: consumer.formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal:
                              45), //it make equal differnce horizontaly on the screen
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "*required username";
                          }
                          return null;
                        },
                        controller: consumer.usernamecontroller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF7EC679)),
                            borderRadius: BorderRadius.circular(30.0),
                          ), //its enables the outline border of textfieald
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Color(0xFF7EC679)),
                            borderRadius: BorderRadius.circular(30.0),
                          ), //its maintain 's the same outline when we clicked it
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Colors
                                    .red), // its creates an red border around it
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Colors.red), //it maintain the red border
                            borderRadius: BorderRadius.circular(30.0),
                          ),

                          filled: true,
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w800),
                          labelText: 'Username',
                          hintText: 'Enter username here',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w500),

                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "*required password";
                          }
                          return null;
                        },
                        controller: consumer.passcontroller,
                        obscureText: consumer.obscureText,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Color(0xFF7EC679)),
                              borderRadius: BorderRadius.circular(30.0),
                            ), //its enables the outline border of textfieald
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Color(0xFF7EC679)),
                              borderRadius: BorderRadius.circular(30.0),
                            ), //its maintain 's the same outline when we clicked it
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors
                                      .red), // its creates an red border around it
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2,
                                  color:
                                      Colors.red), //it maintain the red border
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w800),
                            labelText: 'Password',
                            hintText: 'Enter password here',
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500),
                            fillColor: Colors.white70,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                  onPressed: () {
                                    consumer.toggle();
                                  },
                                  icon: Icon(
                                    consumer.obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  )),
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: consumer.isProcessing
                        ? null
                        : () async {
                            if (consumer.formkey.currentState!.validate()) {
                              try {
                                consumer.isProcessing = true;
                                if (consumer.Loggeduser == users.Receptionist) {
                                  if (kDebugMode) {
                                    print(consumer.Loggeduser);
                                  } //its working so we can seperte the function
                                  await Provider.of<LoginProvider>(context,
                                          listen: false)
                                      .ReceptionCheck(
                                          context,
                                          consumer.Loggeduser,
                                          consumer.usernamecontroller.text,
                                          consumer.passcontroller.text);
                                } else if (consumer.Loggeduser == users.Admin) {
                                  if (kDebugMode) {
                                    print(consumer.Loggeduser);
                                  }
                                  await Provider.of<LoginProvider>(context,
                                          listen: false)
                                      .AdminCheck(
                                          context,
                                          consumer.Loggeduser,
                                          consumer.usernamecontroller.text,
                                          consumer.passcontroller.text);
                                }
                              } catch (e) {
                                print('erro on login $e');
                              } finally {
                                consumer.isProcessing = false;
                              }
                            } else {
                              //snack bar error message
                              if (kDebugMode) {
                                print('Login error on login onpressed');
                              }
                              const snackBar = SnackBar(
                                content: Text(
                                    'Enter Username and Password to continue'),
                                backgroundColor:
                                    Color.fromARGB(255, 218, 13, 13),
                                elevation: 5,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF296934),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    child: Center(
                      child: consumer.isProcessing
                          ? const SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color.fromRGBO(253, 186, 63, 1),
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 3.3),
                child: const Text(
                  'Powered by Nish',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              )
              // const SizedBox(
              //   height: 90,
              // ),
              // //website link add on the Future  here!
              // const Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Text(
              //     'Powered by Nish',
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.w800,
              //         fontSize: 15),
              //   ),
              // )
            ],
          ),
        );
      })),
    );
  }
}
