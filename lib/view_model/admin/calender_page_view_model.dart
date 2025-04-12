// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/model/calender_model.dart';
import 'package:order_now_android/model/reservation_model.dart';
import 'package:order_now_android/view/utilitie/enums.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CalenderPageProvider extends ChangeNotifier {
//  bool checkColor = false;

  DateTime DateToday = DateTime.now();

  DateTime? currentDateTime;
  DateTime? selectedDateTime;
  List<Calendar>? sequentialDates =
      []; //added question mark during the declaration, because  to avoid yellow error
  int? midYear;
  CalendarViews currentView = CalendarViews.dates;
  final List<String> weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  //firebase
  bool isLoading = false; //just added for the loading of the page

  void DetailsLoader(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Set loading state to true
        isLoading = true;
        notifyListeners();

        await getData();
        await getCalendar(context);

        // Set loading state to false
        isLoading = false;
        notifyListeners();
      } catch (e) {
        // Handle errors
        if (kDebugMode) {
          print('Error loading customer details: $e');
        }
        // Set loading state to false in case of an error
        isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> getCalendar(BuildContext context) async {
    // Loading = true; //just added for the loading of the page you can remove it
    // notifyListeners();

    sequentialDates = CustomCalendar().getMonthCalendar(
        context, currentDateTime!.month, currentDateTime!.year,
        startWeekDay: StartWeekDay.monday);

    // Loading = false;
    // notifyListeners();
  }

  void setPrebookedDate(BuildContext context, DateTime reservedDate) {
    // Find the corresponding Calendar object for the reserved date
    Calendar reservedCalendar = sequentialDates!.firstWhere(
      (calendar) => calendar.date == reservedDate,
      orElse: () => Calendar(date: reservedDate),
    );

    // Update the isPrebooked property for the reserved date
    reservedCalendar.isPrebooked = true;

    // Call getData to update the Ui
    getData();
    notifyListeners();
  }

//CRUD
  final CollectionReference dataRetriver =
      FirebaseFirestore.instance.collection('reservation');

// Reservation Booking !
  Future<void> ReserveBooking(BuildContext context,
      {required DateTime date,
      required List ReserveList,
      required String name,
      required String phonenumber,
      required String proof,
      required String Totalrate,
      required String AdvanceAmount,
      required String uniqueId,
      required bool isReserved,
      required String Catogary,
      required String Address}) async {
    //   var docid = dataRetriver.doc().id;
    try {
      await dataRetriver.add({
        'date': date,
        'reserveList': ReserveList,
        'name': name,
        'phonenumber': phonenumber,
        'proof': proof,
        'Totalrate': Totalrate,
        'AdvanceAmount': AdvanceAmount,
        'uniqueId': uniqueId,
        'isReserved': isReserved,
        'catogary': Catogary,
        'address': Address,
      }).then((value) {
        //Should i do any thing here to make the date green means should  i update here , to achive the thing
        // setState(() {
        setPrebookedDate(context, date); //this is main
        // });
      });
      // print('Sub collection added to Firestore');
      ///  ReservedDates.clear();//clearing the list here will avoid the doubling??
      notifyListeners();
      print('New user document added to Firestore');
    } catch (e) {
      notifyListeners();
      print('Error adding new user document: $e');
    }
  }

  List<DataBaseDetails> DatabaseList = [];

  List ReservedDates = [];

//checking this function depthly for the loading
  Future<void> getData() async {
    try {
      notifyListeners();

      // Clear ReservedDates before populating it with new dates
      ReservedDates.clear();

      final snapshot = await dataRetriver.get();
      print('check here${snapshot.docs.length}');

      final DateDetails = snapshot.docs
          .map((doc) => DataBaseDetails.fromJson(doc.data()))
          .toList();
      // print("After ${DateDetails}");

      DatabaseList = DateDetails.where((data) => data.date != null).toList();

      DatabaseList = DateDetails; //converting it to DatabaseList

      // for (DataBaseDetails dates in DatesList) {
      //   DateTime test = DatesList[0].date;
      // }
      print('jobb ${DatabaseList[0].date}');
      for (int i = 0; i < DatabaseList.length; i++) {
        //here i is the index
        DateTime? test = DatabaseList[i].date;
        print("Its Just  A try with some Bug $test");

        ReservedDates.add(test);
      }

      print('Reserved dates $ReservedDates');
      if (DatabaseList.isEmpty) {
        if (kDebugMode) {
          print('List is empty');
        }
        const Text('data');
        notifyListeners();
      }
      //print("Dates List $DatabaseList");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  Widget CalenderShimmerBuilder(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade400,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.27),
                    blurRadius: 3,
                    //spreadRadius: 4,
                    offset: Offset(0, 3))
              ],
            ),
          ),
        ));
  }
}

//Custome calender code
class CustomCalendar {
  // number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  // check for leap year
  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  /// get the month calendar
  /// month is between from 1-12 (1 for January and 12 for December)
  /// to resolve the yellow error on thyear and moth we add int? like this
  List<Calendar> getMonthCalendar(BuildContext context, int? month, int? year,
      {StartWeekDay startWeekDay = StartWeekDay.sunday}) {
    // validate
    if (year == null || month == null || month < 1 || month > 12)
      throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = []; //List<Calendar>();

    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;

    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if (_isLeapYear(year) && month == DateTime.february) totalDays++;

    // get this month's calendar days
    // for (int i = 0; i < totalDays; i++) {
    //   calendar.add(
    //     Calendar(
    //       // i+1 because day starts from 1 in DateTime class
    //       date: DateTime(year, month, i + 1),
    //       thisMonth: true,
    //     ),
    //   );
    // }
    // get this month's calendar days
    for (int i = 0; i < totalDays; i++) {
      DateTime currentDate = DateTime(year, month, i + 1);
      bool isReserved =
          Provider.of<CalenderPageProvider>(context, listen: false)
              .ReservedDates
              .contains(currentDate);
      calendar.add(
        Calendar(
            date: DateTime(year, month, i + 1),
            thisMonth: true,
            isPrebooked: isReserved
            // Set this based on your prebooking logic,
            ),
      );
    }

    // fill the unfilled starting weekdays of this month with the previous month days
    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.first.date.weekday != DateTime.sunday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.first.date.weekday != DateTime.monday)) {
      // if this month is january, then previous month would be decemeber of previous year
      if (month == DateTime.january) {
        otherMonth = DateTime
            .december; // _monthDays index starts from 0 (11 for december)
        otherYear = year - 1;
      } else {
        otherMonth = month - 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february)
        totalDays++;

      leftDays = totalDays -
          calendar.first.date.weekday +
          ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);

      for (int i = totalDays; i > leftDays; i--) {
        calendar.insert(
          0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }

    // fill the unfilled ending weekdays of this month with the next month days
    if ((startWeekDay == StartWeekDay.sunday &&
            calendar.last.date.weekday != DateTime.saturday) ||
        (startWeekDay == StartWeekDay.monday &&
            calendar.last.date.weekday != DateTime.sunday)) {
      // if this month is december, then next month would be january of next year
      if (month == DateTime.december) {
        otherMonth = DateTime.january;
        otherYear = year + 1;
      } else {
        otherMonth = month + 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth - 1];
      if (_isLeapYear(otherYear) && otherMonth == DateTime.february)
        totalDays++;

      leftDays = 7 -
          calendar.last.date.weekday -
          ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if (leftDays == -1) leftDays = 6;

      for (int i = 0; i < leftDays; i++) {
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i + 1),
            nextMonth: true,
          ),
        );
      }
    }

    return calendar;
  }
}
