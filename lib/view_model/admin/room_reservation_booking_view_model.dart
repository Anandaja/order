import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_now_android/view/utilitie/animations/animations_4_widgets.dart';
import 'package:order_now_android/view/utilitie/text_to_image.dart';
import 'package:uuid/uuid.dart';

class RoomRservationBookingProvider extends ChangeNotifier {
  TextEditingController namecontroller = TextEditingController();
  // TextEditingController peoplecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController AdvancePaymentController = TextEditingController();

  TextEditingController Totalratecontroller = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); //for scaffold

  bool isProcessing = false;
  bool onchanged = false;

//testing the unique uid

// Function that generates a unique ID
  String generateUniqueID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  void clearingfiealds() {
    namecontroller.clear();
    addresscontroller.clear();
    phonenumbercontroller.clear();
    addresscontroller.clear();
    AdvancePaymentController.clear();
    Totalratecontroller.clear();
    if (kDebugMode) {
      print('Textfiealds cleared');
    }
  }

  late bool avilable;
  bool autovalidate = false;

  void autovalidation() {
    autovalidate = true;
    notifyListeners();
    //by callling like this we can update like initstate?
  }

  final GlobalKey<FormState> textformkey =
      GlobalKey<FormState>(); //for text form fiealds
  final GlobalKey<FormState> dropdownProofkey =
      GlobalKey<FormState>(); //FOR PUPOSE AND proof

  //test
  late String currentSelectedproof;

  //For the on change() of DropdownFomFieald;
  void ProofFinder(
    selectedValue,
  ) {
    currentSelectedproof = selectedValue;
    notifyListeners();
    if (kDebugMode) {
      print(' testcvvc $currentSelectedproof');
    } // getting the current value
  }

  //for the on change of dropdownfrom fieald purpose

  Widget testFormFieald(BuildContext context,
      {required TextEditingController controller,
      required String HintText,
      required TextInputType? KeyboardType,
      required bool onTap,
      required void Function()? onTapFunction,
      required bool isAddress,
      required bool isPhone}) {
    return TextFormField(
      keyboardType: KeyboardType,
      onTap: onTap
          ? () {
              onchanged = true; //here
              Future.delayed(Duration.zero, onTapFunction);
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
        suffixIcon: isAddress
            ? Tooltip(
                message: 'Extract address from proof',
                child: IconButton(
                    onPressed: () async {
                      // image to text
                      final imgPath = await obtainImage(ImageSource.gallery);
                      print('path $imgPath');

                      if (imgPath == null) return;
                      processImage(imgPath, context);

                      // Navigator.of(context).pop();
                      // showDialog(
                      //   context: context!,
                      //   builder: (context) => imagePickAlert(
                      //     context: context,
                      //     onCameraPressed: () async {
                      //       final imgPath =
                      //           await obtainImage(ImageSource.camera);
                      //       print('path $imgPath');

                      //       if (imgPath == null) return;
                      //       processImage(imgPath, context);

                      //       Navigator.of(context).pop();
                      //     },
                      //     onGalleryPressed: () async {
                      //       final imgPath =
                      //           await obtainImage(ImageSource.gallery);
                      //       print('path $imgPath');

                      //       if (imgPath == null) return;
                      //       processImage(imgPath, context);

                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // );
                    },
                    icon: textGenarating
                        ? const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : Image.asset(
                            'assets/images/text2image.png',
                            height: 35,
                            width: 35,
                          )),
              )
            : null,
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
  //

  Widget ListCreator(
      {required BuildContext context,
      //   required Map<String, dynamic> mapofuserdetails,
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
                        Text(
                          roomtype,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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

  //text to image

  ImagePicker picker = ImagePicker();

  // ignore: unused_field
  RecognitionResponse? _response;

  final ITextRecognizer _recognizer = MLKitTextRecognizer();

  // @override
  // void dispose() {
  //   super.dispose();
  //   if (_recognizer is MLKitTextRecognizer) {
  //     (_recognizer as MLKitTextRecognizer).dispose();
  //   }
  // }

  //obtaining the image
  Future<String?> obtainImage(ImageSource source) async {
    final file = await picker.pickImage(source: source);
    return file?.path;
  }

  //processing the image
  bool textGenarating = false;

  // //quick alert dialog
  // Future<Widget> NoTextImage(BuildContext context) async {
  //   return await QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.error,
  //       title: 'Oops...',
  //       text: 'There is No Text On that image!',
  //       confirmBtnColor: const Color.fromRGBO(68, 142, 74, 1),
  //       confirmBtnText: 'Select Another',
  //       onConfirmBtnTap: () {
  //         Navigator.of(context).pop();
  //       });
  // }

  void processImage(String imgPath, BuildContext context) async {
    try {
      textGenarating = true;
      notifyListeners();

      final recognizedText = await _recognizer.processImage(imgPath);

      if (recognizedText.isEmpty) {
        print('no text from image $recognizedText or ');

        textGenarating = false;
        print('Hi am after text genarating');
        notifyListeners();
        print('Hi am after text listeners');
        showNoTextSnackBar(context); // Call the snack bar here
        print('Hi am after text snack');
      } else {
        print("text : $recognizedText");
        _response = RecognitionResponse(
            imgPath: imgPath, recognizedText: recognizedText);

        addresscontroller.text = recognizedText;

        textGenarating = false;
        notifyListeners();
      }
    } catch (e) {
      print('error on proccessimage $e');
    }
  }

  void showNoTextSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No text found in the image.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // void processImage(String imgPath) async {
  //   textGenarating = true;
  //   notifyListeners();

  //   final recognizedText = await _recognizer.processImage(imgPath);
  //   print("text : $recognizedText");
  //   _response =
  //       RecognitionResponse(imgPath: imgPath, recognizedText: recognizedText);

  //   addresscontroller.text = recognizedText;
  //   textGenarating = false;
  //   notifyListeners();
  // }
}

Widget imagePickAlert({
  void Function()? onCameraPressed,
  void Function()? onGalleryPressed,
  required BuildContext context,
}) {
  return AlertDialog(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    title: const Text(
      "Select image",
      style: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.w600),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text(
            "Camera",
          ),
          onTap: onCameraPressed,
        ),
        //  Divider(),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text(
            "Gallery",
          ),
          onTap: onGalleryPressed,
        ),
      ],
    ),
    actions: [
      TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(0, 255, 255, 255))),
        child: const Text(
          'back',
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
