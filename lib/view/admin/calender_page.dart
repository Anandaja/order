// ignore_for_file: use_key_in_widget_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_now_android/model/calender_model.dart';
import 'package:order_now_android/view/admin/reservation_catogary.dart';
import 'package:order_now_android/view/utilitie/enums.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/calender_page_view_model.dart';
import 'package:provider/provider.dart';

class CalenderPage extends StatefulWidget {
  @override
  CalenderPageState createState() => CalenderPageState();
}

class CalenderPageState extends State<CalenderPage> {
  ConnectivityResult? connectivityResult;
  // = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    super.initState();
    final date = DateTime.now();
    pro.currentDateTime = DateTime(date.year, date.month);
    pro.selectedDateTime = DateTime(date.year, date.month, date.day);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   pro.getData();
    //   setState(() {
    //     pro.getCalendar(context);
    //     // pro.getData(); //Disable this and try
    //   });
    // });
    // worked code
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   pro.getData().then((_) {
    //     setState(() {
    //       //REPLACE THIS SETSTATE , SHAFI  //if i remove it the calender date not loads.// i will resolve it
    //       pro.getCalendar(context);
    //     });

    //     // You might not need to call pro.notifyListeners() here, depending on your implementation
    //   });
    // });

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
    Provider.of<CalenderPageProvider>(context, listen: false).DetailsLoader(
        context); //by calling this details loader on here it loads the data with indictor on the initstate
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    // Provider.of<CalenderPageProvider>(context, listen: false)
    //     .DetailsLoader(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(0, 255, 0, 0),
        title: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Date',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(
                width: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  height: 10,
                  width: 10,
                  // margin: EdgeInsets.all(100.0),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(253, 186, 63, 1),
                      shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
      ),
      body: Consumer<CalenderPageProvider>(builder: (context, consumer, child) {
        return Stack(children: [
          connectivityResult == ConnectivityResult.none
              ? NoNetworkDisplay(context)
              :
              //addthe shimmer here
              consumer.isLoading
                  ? consumer.CalenderShimmerBuilder(context)
                  // const Center(
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //       color: Colors.red,
                  //     ),
                  //   )
                  : Padding(
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
                          child: (consumer.currentView == CalendarViews.dates)
                              ? _datesView()
                              : (consumer.currentView == CalendarViews.months)
                                  ? _showMonthsList()
                                  : _yearsView(consumer.midYear ??
                                      consumer.currentDateTime!.year)),
                    ),
        ]);
      }),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   pro.getData();
      // }),
    );
  }

  // dates view
  Widget _datesView() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // header
        Row(
          children: <Widget>[
            // prev month button
            _toggleBtn(false),
            // month and year
            Expanded(
              child: InkWell(
                onTap: () =>
                    setState(() => pro.currentView = CalendarViews.months),
                child: Center(
                  child: Text(
                      '${pro.monthNames[pro.currentDateTime!.month - 1]} ${pro.currentDateTime!.year}',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ),
            ),
            // next month button
            _toggleBtn(true),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(child: _calendarBody()),
      ],
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next) {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        if (pro.currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (pro.currentView == CalendarViews.year) {
          if (next) {
            pro.midYear = (pro.midYear == null)
                ? pro.currentDateTime!.year + 9
                : pro.midYear! + 9;
          } else {
            pro.midYear = (pro.midYear == null)
                ? pro.currentDateTime!.year - 9
                : pro.midYear! - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25),
        //     border: Border.all(color: Colors.white),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.white.withOpacity(0.5),
        //         offset: Offset(3, 3),
        //         blurRadius: 3,
        //         spreadRadius: 0,
        //       ),
        //     ],
        //     gradient: LinearGradient(
        //       colors: [Colors.black, Colors.black.withOpacity(0.1)],
        //       stops: [0.5, 1],
        //       begin: Alignment.bottomRight,
        //       end: Alignment.topLeft,
        //     )),
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  // calendar
  Widget _calendarBody() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    if (pro.sequentialDates == null) return Container();
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: pro.sequentialDates!.length + 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20,
        crossAxisCount: 7,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        if (index < 7) return _weekDayTitle(index);
        if (pro.sequentialDates![index - 7].date == pro.selectedDateTime)
          return _selector(pro.sequentialDates![index - 7]);
        return _calendarDates(pro.sequentialDates![index - 7]);
      },
    );
  }

  // calendar header
  Widget _weekDayTitle(int index) {
    return Text(
        Provider.of<CalenderPageProvider>(context, listen: false)
            .weekDays[index],
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ));
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate) {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        if (pro.selectedDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() {
            pro.selectedDateTime = calendarDate.date;
          });
          print("Selected dATE ${pro.selectedDateTime}");

          //Navigate to Select Catogary page

          //before navigating it checks  if the selected date is past date or todays date ,if its true it shows an snackbar otherwise push to catogary page
          if (pro.selectedDateTime!.isBefore(pro.DateToday)) {
            print("Cannot Reserve because the date is passed");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot Reserve the room'),
                duration: Duration(seconds: 3), // You can adjust the duration
              ),
            );
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ReservationCatogaryPage(
                        CurrentDate: pro.selectedDateTime!)));
          }
        }
      },
      child: Center(
          child: (calendarDate.isPrebooked)
              ? Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromARGB(255, 68, 142, 74)
                      // Color.fromARGB(255, 41, 105, 52),
                      ),
                  child: Center(
                    child: Text(
                      '${calendarDate.date.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Text(
                  '${calendarDate.date.day}',
                  style: TextStyle(
                    color: (calendarDate
                            .isPrebooked) //this checking willl not work because we allready calling the same thing on the top
                        ? const Color.fromARGB(255, 5, 255,
                            13) // Set the color for prebooked dates
                        : (calendarDate.thisMonth)
                            ? (calendarDate.date.weekday == DateTime.sunday)
                                ? Color.fromARGB(
                                    209, 255, 66, 66) // Colors.yellow
                                : const Color.fromARGB(255, 0, 0, 0)
                            : (calendarDate.date.weekday == DateTime.sunday)
                                ? Color.fromARGB(209, 255, 44, 44)
                                    .withOpacity(0.3)
                                // Colors.yellow.withOpacity(0.5)
                                : const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.3),
                  ),
                )),
    );
  }

  // date selector
  Widget _selector(Calendar calendarDate) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: (calendarDate.isPrebooked)
                ? Color.fromARGB(255, 41, 105, 52)
                : Color.fromARGB(255, 253, 186, 63),
            width: 2),
        // gradient: LinearGradient(
        //   colors: [Colors.black.withOpacity(0.1), Colors.white],
        //   stops: [0.1, 1],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.white.withOpacity(0.9),
        //   borderRadius: BorderRadius.circular(50),
        // ),
        child: Center(
          child: Text(
            '${calendarDate.date.day}',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  // get next month calendar
  void _getNextMonth() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    if (pro.currentDateTime!.month == 12) {
      pro.currentDateTime = DateTime(pro.currentDateTime!.year + 1, 1);
    } else {
      pro.currentDateTime =
          DateTime(pro.currentDateTime!.year, pro.currentDateTime!.month + 1);
    }
    pro.getCalendar(context);
  }

  // get previous month calendar
  void _getPrevMonth() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    if (pro.currentDateTime!.month == 1) {
      pro.currentDateTime = DateTime(pro.currentDateTime!.year - 1, 12);
    } else {
      pro.currentDateTime =
          DateTime(pro.currentDateTime!.year, pro.currentDateTime!.month - 1);
    }
    pro.getCalendar(context);
  }

  // get calendar for current month

  // show months list
  Widget _showMonthsList() {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => pro.currentView = CalendarViews.year),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${pro.currentDateTime!.year}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        Divider(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: pro.monthNames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                pro.currentDateTime =
                    DateTime(pro.currentDateTime!.year, index + 1);
                pro.getCalendar(context);
                setState(() => pro.currentView = CalendarViews.dates);
              },
              title: Center(
                child: Text(
                  pro.monthNames[index],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: (index == pro.currentDateTime!.month - 1)
                          ? Color.fromARGB(255, 253, 186, 63) // Colors.yellow
                          : const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // years list views
  Widget _yearsView(int midYear) {
    final pro = Provider.of<CalenderPageProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _toggleBtn(false),
            Spacer(),
            _toggleBtn(true),
          ],
        ),
        Expanded(
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                int thisYear;
                if (index < 4) {
                  thisYear = midYear - (4 - index);
                } else if (index > 4) {
                  thisYear = midYear + (index - 4);
                } else {
                  thisYear = midYear;
                }
                return ListTile(
                  onTap: () {
                    pro.currentDateTime =
                        DateTime(thisYear, pro.currentDateTime!.month);
                    pro.getCalendar(context);
                    setState(() => pro.currentView = CalendarViews.months);
                  },
                  title: Text(
                    '$thisYear',
                    style: TextStyle(
                        fontSize: 18,
                        color: (thisYear == pro.currentDateTime?.year)
                            ? Color.fromARGB(255, 253, 186, 63)
                            : const Color.fromARGB(255, 0, 0, 0)),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
