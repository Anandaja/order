import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/view/homepage_user.dart';
import 'package:order_now_android/view_model/landing_page_view_model.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/svg.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LandingpageViewModel>(context, listen: false).getTableData();
    });
    setState(() {
      visibility = false;
    });
    super.initState();
  }

  bool visibility = false;

  List<String> TextsList = ['We', 'Deliver', 'Fresh food'];

  @override
  Widget build(BuildContext context) {
    print(
        "TableList values: ${Provider.of<LandingpageViewModel>(context, listen: false).TableList}");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 179, 230, 193),
      body: Consumer<LandingpageViewModel>(
          builder: (context, LandingpageViewModel provider, child) {
        ///listview or single child scroolview?
        return ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 33, top: 33, bottom: 33),
            child: Center(
              child: Column(children: [
                for (var i = 0; i < TextsList.length; i++)
                  DelayedDisplay(
                    delay: Duration(milliseconds: 500 * i),
                    // slidingBeginOffset: const Offset(
                    //   -0.35,
                    //   0.0,
                    // ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          TextsList[i],
                          style: const TextStyle(
                              fontSize: 38, fontWeight: FontWeight.w600),
                        ),
                        if (i == 0)
                          const SizedBox(
                            width: 6,
                          ),
                        if (i == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              // wrap this content with padding and add top to this circel
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFBD04),
                                  borderRadius: BorderRadius.circular(100)
                                  //more than 50% of width makes circle
                                  ),
                            ),
                          )
                      ],
                    ),
                  ),
              ]),
              // child: Column(
              //   children: [
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const Text(
              //           'We',
              //           style: TextStyle(
              //               fontSize: 38, fontWeight: FontWeight.w600),
              //         ),
              //         const SizedBox(
              //           width: 6,
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(top: 10),
              //           child: Container(
              //             // wrap this content with padding and add top to this circel
              //             height: 12,
              //             width: 12,
              //             decoration: BoxDecoration(
              //                 color: const Color(0xFFFFBD04),
              //                 borderRadius: BorderRadius.circular(100)
              //                 //more than 50% of width makes circle
              //                 ),
              //           ),
              //         )
              //       ],
              //     ),
              //     const Align(
              //       alignment: Alignment.topLeft,
              //       child: Text(
              //         'Deliver',
              //         style:
              //             TextStyle(fontSize: 38, fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //     const Align(
              //       alignment: Alignment.topLeft,
              //       child: Text(
              //         'Fresh food',
              //         style:
              //             TextStyle(fontSize: 38, fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 163, 209, 176),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(180))),
            child: Stack(
              children: [
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.9,
                        width: MediaQuery.of(context).size.width / 1.3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0x5E000000),
                          //     blurRadius: 1,
                          //     offset: Offset(0, ),
                          //   ),
                          // ],
                        ),

                        // child: SvgPicture.asset(
                        //     'assets/images/noddle plate.svg',
                        //     alignment: Alignment.topCenter),
                        child: Image.asset(
                          'assets/image/Noddle.png',
                          //alignment: Alignment.topCenter,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    provider.isEmpty
                        ? Text(
                            "No Tables",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Table',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 4.9,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 179, 230, 193),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      alignment: Alignment.center,
                                      value: provider.dropdownValue,
                                      iconDisabledColor: Colors.black,
                                      iconEnabledColor:
                                          Color.fromARGB(255, 255, 188, 4),
                                      hint: Text(
                                        'No',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                      items: provider.TableList.map<
                                          DropdownMenuItem<int>>((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            value.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        // print("What if this is the contextv${context}");
                                        print('object $newValue');
                                        setState(() {
                                          provider.dropdownValue = newValue!;
                                          visibility = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                    visibility
                        ? Padding(
                            padding: const EdgeInsets.all(33),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 13,
                              width: MediaQuery.of(context).size.width / 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {
                                  print(
                                      "Selected table no ${provider.dropdownValue}");
                                  //  after pushing to next page change the visibility bool to false
                                  //or should we load it on the inistate

                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MyHomePageuser(
                                            tableNO: provider.dropdownValue)),
                                  ).then((value) {
                                    setState(() {
                                      visibility = false;
                                    });
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  //  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Continue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.63,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 21,
                                      width: 21,
                                      child: Image.asset(
                                        'assets/image/next.png',
                                        fit: BoxFit.contain,
                                      ),
                                      // child: ImageIcon(
                                      //   AssetImage("assets/images/next.png"),
                                      // ),
                                    ),

                                    ///  Icon(icon)
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
        ]);
      }),
    );
  }
}
