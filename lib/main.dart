import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/firebase_options.dart';
import 'package:order_now_android/view/landingpage.dart';
import 'package:order_now_android/view/main_page.dart';
import 'package:order_now_android/view/splash.dart';
import 'package:order_now_android/view_model/admin/admin_dormitory_book_provider.dart';
import 'package:order_now_android/view_model/admin/admin_homestay_book_provider.dart';
import 'package:order_now_android/view_model/admin/admin_rooms_book_provider.dart';
import 'package:order_now_android/view_model/admin/calender_page_view_model.dart';
import 'package:order_now_android/view_model/admin/current_customer_edit_provider.dart';
import 'package:order_now_android/view_model/admin/current_customer_view_model.dart';
import 'package:order_now_android/view_model/admin/customer_details_admin_view_model.dart';
import 'package:order_now_android/view_model/admin/dormitory_admin_view_model.dart';
import 'package:order_now_android/view_model/admin/dormitory_creation_view_model.dart';
import 'package:order_now_android/view_model/admin/dormitory_edit_list_provider.dart';
import 'package:order_now_android/view_model/admin/dormitory_edit_view_model.dart';
import 'package:order_now_android/view_model/admin/dormitory_reservation_booking_provider.dart';
import 'package:order_now_android/view_model/admin/dormitorylist_reservation_provider.dart';
import 'package:order_now_android/view_model/admin/edit_room_view_model.dart';
import 'package:order_now_android/view_model/admin/homestay_admin_view_model.dart';
import 'package:order_now_android/view_model/admin/homestay_creation_view_model.dart';
import 'package:order_now_android/view_model/admin/homestay_edit_list_provider.dart';
import 'package:order_now_android/view_model/admin/homestay_edit_page_view_model.dart';
import 'package:order_now_android/view_model/admin/homestay_reservation_booking_provider.dart';
import 'package:order_now_android/view_model/admin/homestaylist_reservation_provider.dart';
import 'package:order_now_android/view_model/admin/reservation_history_provider.dart';
import 'package:order_now_android/view_model/admin/reserve_customer_edit_view_model.dart';
import 'package:order_now_android/view_model/admin/reserve_customer_history_provider.dart';
import 'package:order_now_android/view_model/admin/room_creation_view_model.dart';
import 'package:order_now_android/view_model/admin/room_edit_list_provider.dart';
import 'package:order_now_android/view_model/admin/room_reservation_booking_view_model.dart';
import 'package:order_now_android/view_model/admin/roomlist_reservation_view_model.dart';
import 'package:order_now_android/view_model/admin/rooms_page_view_model.dart';
import 'package:order_now_android/view_model/admin/sheduled_dates_view_model.dart';
import 'package:order_now_android/view_model/cartpage_view_medel.dart';
import 'package:order_now_android/view_model/homepage_view_model.dart';
import 'package:order_now_android/view_model/homepageuser_view_model.dart';
import 'package:order_now_android/view_model/landing_page_view_model.dart';
import 'package:order_now_android/view_model/order_details_view_model.dart';
import 'package:order_now_android/view_model/reception/customer_details_edit_view_model.dart';
import 'package:order_now_android/view_model/reception/customer_details_view_model.dart';
import 'package:order_now_android/view_model/reception/dormitory_book_view_model.dart';
import 'package:order_now_android/view_model/reception/dormitory_view_model.dart';
import 'package:order_now_android/view_model/reception/homestay_book_view_model.dart';
import 'package:order_now_android/view_model/reception/homestay_view_model.dart';
import 'package:order_now_android/view_model/reception/room_book_view_model.dart';
import 'package:provider/provider.dart';

import 'view_model/login_view_model.dart';
import 'view_model/reception/rooms_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true); //is it want??
  // await FirebaseDatabase.instance.ref('tables').keepSynced(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider<LoginProvider>(
            create: (context) => LoginProvider()),
        ChangeNotifierProvider<RoomsProvider>(
            create: ((context) => RoomsProvider())),
        ChangeNotifierProvider<RoomBookProvider>(
            create: ((context) => RoomBookProvider())),
        ChangeNotifierProvider<CustomerProvider>(
            create: ((context) => CustomerProvider())),
        ChangeNotifierProvider<DormitoryProvider>(
            create: ((context) => DormitoryProvider())),
        ChangeNotifierProvider<dormitoryBookProvider>(
            create: ((context) => dormitoryBookProvider())),
        ChangeNotifierProvider<HomestayProvider>(
            create: ((context) => HomestayProvider())),
        ChangeNotifierProvider<HomestayBookProvider>(
            create: ((context) => HomestayBookProvider())),
        ChangeNotifierProvider<CustomerDetailEditpageProvider>(
            create: ((context) => CustomerDetailEditpageProvider())),
        ChangeNotifierProvider<AdminRoomsProvider>(
            create: ((context) => AdminRoomsProvider())),
        ChangeNotifierProvider<AdminEditRoomsProvider>(
            create: ((context) => AdminEditRoomsProvider())),
        ChangeNotifierProvider<DormitoryAdminProvider>(
            create: ((context) => DormitoryAdminProvider())),
        ChangeNotifierProvider<AdminDormitoryEditProvider>(
            create: ((context) => AdminDormitoryEditProvider())),
        ChangeNotifierProvider<CustomerDetailsAdminProvider>(
            create: ((context) => CustomerDetailsAdminProvider())),
        ChangeNotifierProvider<CurrentCustomerProvider>(
            create: ((context) => CurrentCustomerProvider())),
        ChangeNotifierProvider<AdminHomestayProvider>(
            create: ((context) => AdminHomestayProvider())),
        ChangeNotifierProvider<AdminHomestayEditProvider>(
            create: ((context) => AdminHomestayEditProvider())),
        ChangeNotifierProvider<RoomCreationProvider>(
            create: ((context) => RoomCreationProvider())),
        ChangeNotifierProvider<DormitoryCreationProvider>(
            create: ((context) => DormitoryCreationProvider())),
        ChangeNotifierProvider<HomestayCreationProvider>(
            create: ((context) => HomestayCreationProvider())),
        ChangeNotifierProvider<CalenderPageProvider>(
            create: ((context) => CalenderPageProvider())),
        ChangeNotifierProvider<RoomReservationListProvider>(
            create: ((context) => RoomReservationListProvider())),
        ChangeNotifierProvider<RoomRservationBookingProvider>(
            create: ((context) => RoomRservationBookingProvider())),
        ChangeNotifierProvider<SheduledDateProvider>(
            create: ((context) => SheduledDateProvider())),
        ChangeNotifierProvider<ReserveCustomerEditProvider>(
            create: ((context) => ReserveCustomerEditProvider())),
        ChangeNotifierProvider<ReservationHistoryProvider>(
            create: ((context) => ReservationHistoryProvider())),
        ChangeNotifierProvider<ReserveCustomerHistoryProvider>(
            create: ((context) => ReserveCustomerHistoryProvider())),
        ChangeNotifierProvider<DormitoryListReservationProvider>(
            create: ((context) => DormitoryListReservationProvider())),
        ChangeNotifierProvider<DormitoryReservationBookingProvider>(
            create: ((context) => DormitoryReservationBookingProvider())),
        ChangeNotifierProvider<HomestayListReservationProvider>(
            create: ((context) => HomestayListReservationProvider())),
        ChangeNotifierProvider<HomestayReservationBookingProvider>(
            create: ((context) => HomestayReservationBookingProvider())),
        ChangeNotifierProvider<AdminRoomBookProvider>(
            create: ((context) => AdminRoomBookProvider())),
        ChangeNotifierProvider<AdminDormitoryBookProvider>(
            create: ((context) => AdminDormitoryBookProvider())),
        ChangeNotifierProvider<AdminHomestayBookProvider>(
            create: ((context) => AdminHomestayBookProvider())),
        ChangeNotifierProvider<CurrentCustomerEditProvider>(
            create: ((context) => CurrentCustomerEditProvider())),
        ChangeNotifierProvider<RoomsEditListProvider>(
            create: ((context) => RoomsEditListProvider())),
        ChangeNotifierProvider<DormitoryEditListProvider>(
            create: ((context) => DormitoryEditListProvider())),
        ChangeNotifierProvider<HomestayEditListProvider>(
            create: ((context) => HomestayEditListProvider())),
      
        ChangeNotifierProvider<HomepageViewModel>(
            create: ((context) => HomepageViewModel())),
        ChangeNotifierProvider<OrderDetailsViewModel>(
            create: ((context) => OrderDetailsViewModel())),
            
  ChangeNotifierProvider<LandingpageViewModel>(
            create: ((context) => LandingpageViewModel())),
        ChangeNotifierProvider<HomepageuserViewModel>(
            create: ((context) => HomepageuserViewModel())),
        ChangeNotifierProvider<CartPageViewModel>(
            create: ((context) => CartPageViewModel()))
     
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          //   textTheme: GoogleFonts.ralewayTextTheme(),
          textTheme: GoogleFonts.montserratTextTheme(), //which one??
          useMaterial3: true,
        ),
        home:  MainPage(),
      ),
    );
  }
}
