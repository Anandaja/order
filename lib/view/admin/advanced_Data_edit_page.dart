import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jnn_erp/view/admin/dormitory_creating_page.dart';
// import 'package:jnn_erp/view/admin/homestay_creation_page.dart';
// import 'package:jnn_erp/view/admin/new_room_creation_page.dart';
import 'package:order_now_android/view/admin/room_edit_type.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
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
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Settings',
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
                child: SizedBox(
                  height: 26,
                  width: 26,
                  child: Image.asset(
                    'assets/images/tools.png',
                    scale: 1,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
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
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => const RoomCreationPage(),
                          //   ),
                          // );
                          //room type edit

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const RoomEditTypePage(
                                Catogary: 'Room',
                              ),
                            ),
                          );
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
                            borderRadius: BorderRadius.circular(14),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          height: MediaQuery.of(context).size.height / 5.3,
                          width: MediaQuery.of(context).size.width / 3.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      topRight: Radius.circular(14)),
                                  color: Color.fromRGBO(253, 185, 63, 1),
                                ),
                                height: MediaQuery.of(context).size.height / 45,
                              ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              SizedBox(
                                height: 52,
                                width: 52,
                                child: Image.asset(
                                  'assets/images/room icon.png',
                                  scale: 1,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                'ROOM',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Bounceable(
                        onTap: () {
                          //dormitory
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) =>
                          //         const DormitoryCreationPage(),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const RoomEditTypePage(
                                Catogary: 'Dormitory',
                              ),
                            ),
                          );
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
                            borderRadius: BorderRadius.circular(14),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          height: MediaQuery.of(context).size.height / 5.3,
                          width: MediaQuery.of(context).size.width / 3.1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      topRight: Radius.circular(14)),
                                  color: Color.fromRGBO(253, 185, 63, 1),
                                ),
                                height: MediaQuery.of(context).size.height / 45,
                              ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              SizedBox(
                                height: 52,
                                width: 52,
                                child: Image.asset(
                                  'assets/images/dormitory icon.png',
                                  scale: 1,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                'DORMITORY',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
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
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Bounceable(
                  onTap: () {
                    //homestay
                    // Navigator.push(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (context) => const HomestayCreationPage(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const RoomEditTypePage(
                          Catogary: 'HomeStay',
                        ),
                      ),
                    );
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
                      borderRadius: BorderRadius.circular(14),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    height: MediaQuery.of(context).size.height / 5.3,
                    width: MediaQuery.of(context).size.width / 3.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14)),
                            color: Color.fromRGBO(253, 185, 63, 1),
                          ),
                          height: MediaQuery.of(context).size.height / 45,
                        ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        SizedBox(
                          height: 52,
                          width: 52,
                          child: Image.asset(
                            'assets/images/homestay icon.png',
                            scale: 1,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          'HOMESTAY',
                          style: GoogleFonts.nunitoSans(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
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
    );
  }
}
