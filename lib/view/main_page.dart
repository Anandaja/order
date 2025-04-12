import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:order_now_android/view/homepage.dart';
import 'package:order_now_android/view/landingpage.dart';
import 'package:order_now_android/view/splash.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('tables');
  final FlutterTts flutterTts = FlutterTts();
  final Connectivity connectivity = Connectivity();

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  bool isTTSInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeTTS();
    fetchData();
    listenForChanges();
    listenConnectivity();
  }

  Future<void> initializeTTS() async {
    await flutterTts.awaitSpeakCompletion(true);
    setState(() {
      isTTSInitialized = true;
    });
  }

  void fetchData() {
    databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        for (var element in event.snapshot.children) {
          processOrder(element);
        }
      }
    }).catchError((error) {
      print('Firebase Fetch Error: $error');
    });
  }

  void listenForChanges() {
    databaseReference.onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        processOrder(event.snapshot);
      }
    }, onError: (error) {
      print('Firebase Listener Error: $error');
    });
  }

  void processOrder(DataSnapshot snapshot) async {
    Map<dynamic, dynamic> orderData = snapshot.value as Map<dynamic, dynamic>;
    print("Order Updated: ${snapshot.key}");
    print("Order Data: $orderData");

    if (orderData['Availability'] == false && isTTSInitialized) {
      await flutterTts.speak('ORDER RECEIVED');
    }
  }

  void listenConnectivity() {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: connectivityResult == ConnectivityResult.none
          ? _noInternetScreen()
          : const OrderPage(),
    );
  }

  Widget _noInternetScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/404 error png.png', height: 200),
          const SizedBox(height: 20),
          const Text('No Internet Connection', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}


class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to',
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _menuButton(
                  context,
                  label: "Order Now",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()),
                  ),
                ),
                _menuButton(
                  context,
                  label: "Order Table Details",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  ),
                ),
           Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 179, 230, 193),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: SizedBox(
                                height: 42,
                                width: 42,
                                child: Image.asset(
                                  'assets/images/room icon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Room Booking",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
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
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200,
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 179, 230, 193),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
