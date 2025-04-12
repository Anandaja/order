import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/dormitory_creating_page.dart';
import 'package:order_now_android/view/admin/dormitory_edit_list.dart';
import 'package:order_now_android/view/admin/homestay_creation_page.dart';
import 'package:order_now_android/view/admin/homestay_edit_list.dart';
import 'package:order_now_android/view/admin/new_room_creation_page.dart';
import 'package:order_now_android/view/admin/room_edit_list.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class RoomEditTypePage extends StatefulWidget {
  const RoomEditTypePage({
    super.key,
    required this.Catogary,
  });

  final String Catogary;

  @override
  RoomEditTypePagestate createState() => RoomEditTypePagestate();
}

class RoomEditTypePagestate extends State<RoomEditTypePage> {
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
          "Advance Edit",
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
          //New Reservation Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Bounceable(
              onTap: () {
                //Create New room page
                if (widget.Catogary == "Room") {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const RoomCreationPage(),
                    ),
                  );
                } else if (widget.Catogary == 'Dormitory') {
                  //dormitory
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DormitoryCreationPage(),
                    ),
                  );
                } else {
                  //homestay
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const HomestayCreationPage(),
                    ),
                  );
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
                              'assets/images/pencil.png',
                              fit: BoxFit.contain,
                            )),
                      ),
                    ), // it creates the green circular icons
                    Text('Create New ${widget.Catogary}',
                        style: const TextStyle(
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

          //reservation details Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Bounceable(
              onTap: () {
                if (widget.Catogary == "Room") {
                  print('${widget.Catogary} edit page loads');
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const RoomsEditList(),
                    ),
                  );
                } else if (widget.Catogary == 'Dormitory') {
                  print('${widget.Catogary} edit page loads');
                  //dormitory
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DormitoryEditList(),
                    ),
                  );
                } else {
                  print('${widget.Catogary} edit page loads');
                  //homestay
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const HomestayEditList(),
                    ),
                  );
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
                            'assets/images/write.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ), // it creates the green circular icons
                    Text('Edit ${widget.Catogary}',
                        style: const TextStyle(
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
