import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/homestay_admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminHomestayPage extends StatefulWidget {
  const AdminHomestayPage({super.key, required this.passedResult});

  final ConnectivityResult? passedResult;

  @override
  AdminHomestayPagestate createState() => AdminHomestayPagestate();
}

class AdminHomestayPagestate extends State<AdminHomestayPage> {
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
    Provider.of<AdminHomestayProvider>(context, listen: false).DetailsLoader();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              // if (widget.passedResult == ConnectivityResult.none ||
              //     connectivityResult == ConnectivityResult.none) {
              //   NoInternetDialog(context);
              // } else {
              //   Navigator.of(context).pop();
              // }
              //  Provider.of<AdminRoomsViewmodel>(context, listen: false)
              //     .resetFilter();
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
          'Homestay Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
          Consumer<AdminHomestayProvider>(builder: (context, consumer, child) {
        return Stack(children: [
          // widget.passedResult == ConnectivityResult.none ||
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplay(context)
              : consumer.isLoading
                  ? consumer.buildShimmerFloorListView(1)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 17,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: consumer.HomestayList.length,
                            itemBuilder: ((context, index) {
                              //use a bool if All chip is selected then automatically load the data on this page
                              Map<String, dynamic> detailsList = {
                                'name': consumer.HomestayList[index].name,
                                'rate': consumer.HomestayList[index].rate,
                                'image': consumer.HomestayList[index].image,
                                'isAvailable':
                                    consumer.HomestayList[index].isAvailable,
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
    );
  }
}
