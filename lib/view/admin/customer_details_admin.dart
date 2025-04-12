import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/admin/homepage.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/customer_details_admin_view_model.dart';

import 'package:provider/provider.dart';

class AdminCustomerDetailsPage extends StatefulWidget {
  const AdminCustomerDetailsPage({super.key, required this.passedResult});

  final ConnectivityResult? passedResult;
  @override
  AdminCustomerDetailsPagestate createState() =>
      AdminCustomerDetailsPagestate();
}

class AdminCustomerDetailsPagestate extends State<AdminCustomerDetailsPage> {
  ConnectivityResult? connectivityResult;
  // ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    print("Connectivity result from   Homepagr ${widget.passedResult}");
    // if (widget.passedResult == ConnectivityResult.none) {
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult?;
        });
      }
    });
    // }
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      //connectivity listner
      if (mounted) {
        setState(() {
          connectivityResult = result;
          print("Connectivity result from this page$result");
        });
      }
      // log(result.name);
    } as void Function(ConnectivityResult event)?);
    super.initState();
  }

  Future<bool> showExitPopup() async {
    // Provider.of<DormitoryCreationProvider>(context, listen: false)
    //     .clearingfiealds();
    // Provider.of<DormitoryCreationProvider>(context, listen: false)
    //     .isimageAdded = false;
    if (widget.passedResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.none) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const Homepage()),
          (route) => false);
    }
    // Navigator.of(context).pop();
    return true;
    //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CustomerDetailsAdminProvider>(context, listen: false)
        .DetailsLoader(context);
    return WillPopScope(
      onWillPop: () => showExitPopup(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (widget.passedResult == ConnectivityResult.none ||
                    connectivityResult == ConnectivityResult.none) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Homepage()),
                      (route) => false);
                } else {
                  Navigator.of(context).pop();
                }
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
            'Customer Details',
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Consumer<CustomerDetailsAdminProvider>(
            builder: (context, consumer, child) {
          return Stack(children: [
            // widget.passedResult == ConnectivityResult.none ||
            connectivityResult == ConnectivityResult.none
                ? NoNetworkDisplay(context)
                : consumer.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(68, 142, 74, 1),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            consumer.buildcustomerTiles(
                              context,
                              'Normal Rooms',
                              consumer.RoomCustomers,
                              'Room No ',
                            ),
                            consumer.buildcustomerTiles(
                              context,
                              'Dormitory',
                              consumer.DormitoryCustomers,
                              'Dormitory No ',
                            ),
                            consumer.buildcustomerTiles(context, 'HomeStay',
                                consumer.HomestayCustomers, '')
                          ],
                        ),
                      ),
          ]);
        }),
      ),
    );
  }
}
