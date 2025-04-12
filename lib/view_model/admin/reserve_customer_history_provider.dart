import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';

class ReserveCustomerHistoryProvider extends ChangeNotifier {
  TextEditingController namecontroller = TextEditingController();
  // TextEditingController peoplecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController AdvancePaymentController = TextEditingController();

  TextEditingController Totalratecontroller = TextEditingController();
  TextEditingController CheckIndatecontroller = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //for scaffold

  String proofInitialValue = ''; //for dropdowns

  bool isProcessing = false;

  void clearingfiealds() {
    namecontroller.clear();
    //peoplecontroller.clear();
    phonenumbercontroller.clear();
    addresscontroller.clear();
    AdvancePaymentController.clear();
    Totalratecontroller.clear();
    CheckIndatecontroller.clear();
    if (kDebugMode) {
      print('Textfiealds cleared');
    }
  }

  late bool avilable;
  bool autovalidate = false;

  final GlobalKey<FormState> textformkey =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownProofkey =
      GlobalKey<FormState>(); //FOR PUPOSE AND proof

  //test
  String? currentSelectedproof;

  //For the on change() of DropdownFomFieald;
  bool ischangedProof = false; //on change
  bool areChangesMade =
      false; //for the on change proper working in edit section

  bool DateChanged = false;

  //date &Time Picker
  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2023);
  DateTime last = DateTime(2050);

  DateTime? BeforeFormat; //to get the date before formatting

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now(); //for check in &check out
  // final TimeOfDay fixedTime = TimeOfDay(hour: 1, minute: 0);
//date picker
  Future CheckinDatePicker(BuildContext context, DateTime ReservedDate) async {
    BeforeFormat = await showDatePicker(
      context: context,
      initialDate: ReservedDate,
      firstDate: initial,
      lastDate: last,
    );

    if (BeforeFormat != null) {
      // String Date = BeforeFormat!.toLocal().toString().split(" ")[0];
      String Date = DateFormat('dd-MM-yyyy').format(BeforeFormat!);
      CheckIndatecontroller.text = Date;
      if (kDebugMode) {
        print('check in date $Date');
        print("Date before Format $BeforeFormat");
      }
      DateChanged =
          true; //if date is changed then it  use the new date otherwise , it use the initial Date
      notifyListeners();
    }
  }

  Widget testFormFieald(BuildContext? context,
      {required TextEditingController controller,
      required String HintText,
      required TextInputType? KeyboardType,
      required bool onTap,
      required void Function()? onTapFunction,
      required bool isAddress,
      required bool isPhone}) {
    return TextFormField(
      readOnly: true,
      keyboardType: KeyboardType,
      onChanged: (value) {
        areChangesMade = true;
      },
      onTap: onTap
          ? () {
              Future.delayed(Duration.zero, onTapFunction);
              areChangesMade = true;
            }
          : null,
      validator: (value) {
        if (value!.isEmpty) {
          return "*required";
        }
        return null;
      },
      maxLines: isAddress ? 5 : 1, // if address tile adjusting the heigt
      minLines: isAddress ? 1 : null, // <-- SEE HERE,

      controller: controller,
      decoration: InputDecoration(
        prefixIcon: isPhone
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "+91",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500),
                ),
              )
            : null,

        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFF7EC679)),
          borderRadius: BorderRadius.circular(8.0),
        ), //its enables the outline border of textfieald
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xFF7EC679)),
          borderRadius: BorderRadius.circular(8.0),
        ), //its maintain 's the same outline when we clicked it
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2,
              color: Colors.red), // its creates an red border around it
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2, color: Colors.red), //it maintain the red border
          borderRadius: BorderRadius.circular(8.0),
        ),

        filled: true,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w800),
        // labelText: 'Username',
        hintText: HintText,
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w500),

        fillColor: Colors.transparent,
      ),
    );
  }

  Widget ListCreator(
      {required BuildContext context,
      required String Catogary,
      required String roomno,
      required String roomtype,
      required String rate,
      required String image,
      required String floor,
      required int index}) {
    // availble = mapofuserdetails['isAvailable'];
    //   print("is availble $availble");
    // print("INDEXX $index");

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Bounceable(
            onTap: () {
              //on tap to navigate to corresponding room details page
              print(
                  "Room details \n $roomno ,\n $roomtype,\n $rate,\n $floor,\n $index");
              print('image url $image');
              //on tap current room details/book page will load
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.27),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(9),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                      //    color: Color.fromRGBO(68, 142, 74, 1),
                    ),
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                      child: Stack(
                        children: [
                          // Placeholder Image
                          Center(
                            child: Image.asset('assets/images/img.png',
                                width: MediaQuery.of(context).size.width / 9.5,
                                height:
                                    MediaQuery.of(context).size.height / 9.5),
                          ),
                          // Actual Image with Fade Transition
                          Positioned.fill(
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),
                  //used expanded to align elements correctly
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roomno,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Catogary == 'rooms'
                            ? Text(
                                roomtype,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Catogary == 'dormitory'
                                ? Text(
                                    'Per Head rate $rate',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Text(
                                    'Rate $rate',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Bounceable(
                      onTap: () {
                        //
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        child: Icon(
                          Icons.done,
                          color: const Color.fromRGBO(41, 105, 52, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
