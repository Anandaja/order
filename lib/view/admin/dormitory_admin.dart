//import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/dormitory_admin_view_model.dart';
import 'package:provider/provider.dart';

class DormitoryPageAdmin extends StatefulWidget {
  const DormitoryPageAdmin({super.key, required this.passedResult});
  final ConnectivityResult? passedResult;

  @override
  DormitoryPageAdminstate createState() => DormitoryPageAdminstate();
}

class DormitoryPageAdminstate extends State<DormitoryPageAdmin> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult?;
        });
      }
    });
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      //connectivity listner
      if (mounted) {
        setState(() {
          connectivityResult = result;
          print("Connectivity result $result");
        });
      }
      // log(result.name);
    } as void Function(ConnectivityResult event)?);
    super.initState();
  }

//modify this
  Future<bool> NointernetPopup() async {
    if (widget.passedResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.none) {
      return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: ThemeData(
                  dialogBackgroundColor:
                      const Color.fromARGB(255, 248, 247, 247),
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
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(68, 142, 74, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2, // Added elevation
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16), // Adjusted padding
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
          ) ??
          false; //if showDialouge had returned null, then return false
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DormitoryAdminProvider>(context, listen: false).DetailsLoader();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
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
          'Dormitory Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
          Consumer<DormitoryAdminProvider>(builder: (context, consumer, child) {
        return Stack(children: [
          // widget.passedResult == ConnectivityResult.none ||
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplay(context)
              : consumer.isLoading
                  ? consumer.buildShimmerFloorListView(2)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 17,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 26, top: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Ground Floor',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: consumer.dormitoryList.length,
                            itemBuilder: ((context, index) {
                              //use a bool if All chip is selected then automatically load the data on this page
                              Map<String, dynamic> detailsList = {
                                'dormitoryno':
                                    consumer.dormitoryList[index].dormitoryno,
                                'perHeadRate':
                                    consumer.dormitoryList[index].perHeadRate,
                                'image': consumer.dormitoryList[index].image,
                                'isAvailable':
                                    consumer.dormitoryList[index].isAvailable,
                                'floor': consumer.dormitoryList[index].floor,
                              };

                              return consumer.ListCreator(
                                  context, detailsList, index);
                            }),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
        ]);
      }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 10, right: 10),
      //   child: FloatingActionButton(
      //       backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Provider.of<DormitoryAdminViewModel>(context, listen: false)
      //             .showAlertDialog(context);
      //         if (kDebugMode) {
      //           print('pressed');
      //         }
      //       }),
      // ),
    );
  }
}
