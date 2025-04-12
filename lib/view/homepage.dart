// ignore_for_file: non_constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/view_model/homepage_view_model.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('tables');

  final FlutterTts flutterTts = FlutterTts();

  Future<void> FetchingData() async {
    databaseReference.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      snapshot.children.forEach((element) {
        // Access data for each order
        //  dynamic orderData = element.value as Map<String, dynamic>;
        String? orderId = element.key; // Get the automatically generated ID
        print('Order ID: $orderId');
        // print('Food name: ${orderData['foodname']}');
        // print('Quantity: ${orderData['quantinty']}');
        // Access other fields as needed
      });
    });
  }

  @override
  void initState() {
    Testload();
    FetchingData(); //to get all doc id
    // NewId(); it gives all the data inside doc as map.
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      //connectivity listner
      setState(() {
        connectivityResult = result;
        print("Connectivity result $result");
      });
      // log(result.name);
    });
    super.initState();
  }

  Future<void> initializeTTS() async {
    // Perform TTS initialization and setup here
    await flutterTts.awaitSpeakCompletion(true);
  }

  // bool isFirstLoad = true;
  Future<void> Testload() async {
    // Listen for child added events
    databaseReference.onChildChanged.listen((event) async {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> orderData =
            event.snapshot.value as Map<dynamic, dynamic>;

        print('New document added with ID: ${event.snapshot.key}');

        print("New Doc data ${event.snapshot.value}");
        setState(() {
          //optional!!!!
          orderData['foodname'];
          orderData['quantity'];
        });

        if (orderData['Availability'] == false) {
          //  i think i should update the table bool here
          await initializeTTS();
          flutterTts.speak('ORDER RECEIVED').then((result) {
            if (result == 1) {
              print("TTS success");
            } else {
              print("TTS error: $result");
            }
          });
        } else {
          print('No sound');
        }
      }
    }, onError: (Object error) {
      print('Error: $error');
    });

    // Use once to handle the initial load// There is some little bugs sometimes is it resolve whe using the combo of onvalue and Onchild added

    // await // when i removed it i cannot listen the speech is it worked?
    //     databaseReference.once().then((DatabaseEvent databaseEvent) {
    //   isFirstLoad = false;
    // });
  }

  //conctivity check

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  String connectivityCheck(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return "You are now connected to wifi";
    } else if (result == ConnectivityResult.mobile) {
      return "You are now connected to mobile data";
    } else if (result == ConnectivityResult.ethernet) {
      return "You are now connected to ethernet";
    } else if (result == ConnectivityResult.bluetooth) {
      return "You are now connected to bluetooth";
    } else if (result == ConnectivityResult.none) {
      return "No connection available";
    } else {
      return "No Connection!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomepageViewModel>(context, listen: false)
        .test(); //while call it here it prints the lenght or anything two times,by moving it to another place it not happaing
    return Scaffold(
      body: Consumer<HomepageViewModel>(builder: (context, consumer, child) {
        return Stack(children: [
          connectivityResult == ConnectivityResult.none
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 500,
                        width: 500,
                        child: Image.asset(
                          'assets/image/404 error png.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text('No internet Connection'),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true, //its alwys align in centre
                      toolbarHeight: MediaQuery.of(context).size.height / 7,
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            ' Here',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 188, 4),
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.9, //for adjusting the size
                        // childAspectRatio: MediaQuery.of(context).size.width /
                        //     (MediaQuery.of(context).size.height / 1.8),
                        // crossAxisCount: 2,
                        // mainAxisSpacing: 28.0,
                        // crossAxisSpacing: 0,
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 0, // spacing between rows
                        crossAxisSpacing: 0, // spacing between columns
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Map<String, dynamic> detailsList = {
                            'TableNo': consumer.TableList[index].TableNo,
                            'Availability':
                                consumer.TableList[index].Availability,
                            'Ongoing Order':
                                consumer.TableList[index].Ongoingord
                          };
                          // print(
                          //     "NO ${detailsList.values} + Availbility ${detailsList['Availability']}");
                          return consumer.Creator(context, detailsList, index);
                        },
                        childCount: consumer.TableList.length,
                      ),
                    ),
                  ],
                ),
        ]);

        // return Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: GridView.builder(
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2, // number of items in each row
        //       mainAxisSpacing: 8.0, // spacing between rows
        //       crossAxisSpacing: 8.0, // spacing between columns
        //     ),
        //     itemCount: consumer.TableList.length,
        //     itemBuilder: (context, index) {
        //       Map<String, dynamic> detailsList = {
        //         'TableNo': consumer.TableList[index].TableNo,
        //         'Availability': consumer.TableList[index].Availability,
        //         'Ongoing Order': consumer.TableList[index].Ongoingord
        //       };
        //       // print(
        //       //     "NO ${detailsList.values} + Availbility ${detailsList['Availability']}");
        //       return consumer.Creator(context, detailsList, index);
        //     },
        //   ),
        //   // child: ListView.builder(
        //   //   itemCount: consumer.OrderList.length,
        //   //   itemBuilder: (context, index) {
        //   //     Map<String, dynamic> detailsList = {
        //   //       'foodname': consumer.OrderList[index].foodname,
        //   //       'quantinty': consumer.OrderList[index].quantinty,
        //   //       'New': consumer.OrderList[index].New,
        //   //       'uniqeid': consumer.OrderList[index].uniqeid,
        //   //     };

        //   //     return consumer.ListCreator(context, detailsList, index);
        //   //   },
        //   // ),
        // );
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // readOrders();
      //     //  updateData(namecontroller.text, addresscontroller.text);
      //   },
      //   tooltip: 'update',
      //   child: const Icon(Icons.replay),
      // ),
    );
  }
}
