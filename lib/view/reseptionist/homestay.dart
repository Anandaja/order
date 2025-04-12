import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/reception/homestay_view_model.dart';
import 'package:provider/provider.dart';

class HomestayPage extends StatefulWidget {
  const HomestayPage({super.key});

  @override
  HomestayPagestate createState() => HomestayPagestate();
}

class HomestayPagestate extends State<HomestayPage> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  void initState() {
    connectivity.checkConnectivity().then((value) {
      print("Am vity $value");
      if (mounted) {
        setState(() {
          connectivityResult = value as ConnectivityResult?;
        });
      }
    });

    //is it only for the on change
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

  @override
  Widget build(BuildContext context) {
    Provider.of<HomestayProvider>(context, listen: false).DetailsLoader();
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
          'Homestay Details',
          style: GoogleFonts.nunitoSans(
            fontSize: 25,
            color: const Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<HomestayProvider>(builder: (context, consumer, child) {
        // consumer.DetailsLoader();
        return Stack(children: [
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplayReception(context)
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
