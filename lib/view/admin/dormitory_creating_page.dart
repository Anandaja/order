import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/view_model/admin/dormitory_creation_view_model.dart';
import 'package:provider/provider.dart';

class DormitoryCreationPage extends StatefulWidget {
  const DormitoryCreationPage({super.key});

  @override
  DormitoryCreationPageState createState() => DormitoryCreationPageState();
}

class DormitoryCreationPageState extends State<DormitoryCreationPage> {
  Future<bool> showExitPopup() async {
    Provider.of<DormitoryCreationProvider>(context, listen: false)
        .clearingfiealds();
    Provider.of<DormitoryCreationProvider>(context, listen: false)
        .isimageAdded = false;
    // Navigator.of(context).pop();
    return true;
    //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(body: Consumer<DormitoryCreationProvider>(
          builder: (context, consumer, child) {
        return CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color.fromARGB(190, 240, 240, 240),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  //i think we should add this same bol while the user click his back button its now work only while we click this button
                  consumer.isimageAdded =
                      false; //to avoid the showing of added image if it not updated with this it only displays the updated image url in firestore
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0),
                )),
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
                background: Stack(fit: StackFit.expand, children: [
              consumer.isImageLoading
                  ? Container(
                      color:
                          Colors.black, // Set a background color while loading
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color.fromRGBO(253, 186, 63, 1),
                        ),
                      ),
                    )
                  : consumer.isimageAdded
                      ? Image.network(
                          consumer.downloadURL,
                          fit: BoxFit.fill,
                        )
                      : Center(
                          child: IconButton(
                            tooltip: 'Add image',
                            onPressed: () {
                              consumer.imgFromGallery();
                            },
                            icon: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.asset(
                                  'assets/images/add-image.png',
                                  fit: BoxFit.contain,
                                )),
                          ),
                        )
            ])),
          ),
          //3
          SliverFixedExtentList(
            itemExtent: 630,
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/pencil.png',
                                  fit: BoxFit.contain,
                                )),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              'Create New Dormitory',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        // Room-No
                        Form(
                          key: consumer.formkey4fiealds,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dormitory-No',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      child: consumer.testFormFieald(
                                        consumer.roomnocontoller,
                                        'Enter Dormitory-No',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Form(
                                  autovalidateMode: consumer.autovalidate
                                      ? AutovalidateMode.always
                                      : AutovalidateMode.onUserInteraction,
                                  key: consumer.dropdownkey,
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Available',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            child: DropdownButtonFormField(
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "*required";
                                                  }
                                                  return null; // no error
                                                },
                                                icon: const Icon(Icons
                                                    .keyboard_arrow_down_sharp),
                                                onChanged: (value) {
                                                  consumer.AvalablityFinder(
                                                      value);
                                                  consumer.ischangedAvailability =
                                                      true;
                                                  consumer.areChangesMade =
                                                      true;
                                                  if (kDebugMode) {
                                                    print(value);
                                                  }
                                                  consumer.autovalidate =
                                                      false; //to make alway validation
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 18.0,
                                                          horizontal: 10.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF7EC679),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  labelStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                  hintText: 'Availblity',
                                                  hintStyle: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  fillColor: Colors.transparent,
                                                ),
                                                items: const [
                                                  DropdownMenuItem<bool>(
                                                    value: true,
                                                    child: Text(
                                                      'Yes',
                                                    ),
                                                  ),
                                                  DropdownMenuItem<bool>(
                                                    value: false,
                                                    child: Text(
                                                      'No',
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Floor',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "*required";
                                                }
                                                return null; // no error
                                              },
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              onChanged: (value) {
                                                consumer.FloorFinder(value);
                                                consumer.ischangedfloor =
                                                    true; //is this neccsery?
                                                consumer.areChangesMade = true;
                                                consumer.autovalidate =
                                                    false; //to make alway validation
                                                if (kDebugMode) {
                                                  print(value);
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 18.0,
                                                        horizontal: 10.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF7EC679),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                hintText: 'Floor',
                                                hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                fillColor: Colors.transparent,
                                              ),
                                              items: consumer.Flooritems.map(
                                                  (String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Per Head Rate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.9,
                                        child: consumer.testFormFieald(
                                          consumer.ratecontroller,
                                          'Enter Per Rate',
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        SizedBox(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 1,
                            child: ElevatedButton(
                              onPressed: consumer.isProcessing
                                  ? null
                                  : () async {
                                      if (consumer.formkey4fiealds.currentState!
                                              .validate() &&
                                          consumer.dropdownkey.currentState!
                                              .validate()) {
                                        try {
                                          consumer.isProcessing = true;

                                          if (kDebugMode) {
                                            print(
                                                consumer.roomnocontoller.text);

                                            print(
                                                'floor ${consumer.currentSelectedfloor}');
                                            print(
                                                'Avaialability ${consumer.currentSelectedBoolType}');
                                            print(consumer.ratecontroller.text);
                                          }

                                          // create the room

                                          await consumer.CreateNewDormitory(
                                                  Rate: consumer
                                                      .ratecontroller.text,
                                                  Floor: consumer
                                                      .currentSelectedfloor,
                                                  DormitoryNo: consumer
                                                      .roomnocontoller.text,
                                                  isAvailable: consumer
                                                      .currentSelectedBoolType,
                                                  imageURL:
                                                      consumer.isimageAdded
                                                          ? consumer.downloadURL
                                                          : 'imageurl')
                                              .then((value) =>
                                                  consumer.clearingfiealds())
                                              .then((value) =>
                                                  Navigator.of(context).pop())
                                              .then((value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'New Dormitory Created'),
                                                      duration: Duration(
                                                          seconds:
                                                              2), // You can adjust the duration
                                                    ),
                                                  ));
                                        } finally {
                                          consumer.isimageAdded = false;
                                          consumer.isProcessing = false;
                                        }
                                      } else {
                                        consumer.autovalidation();
                                      }
                                    },
                              //replace this button with room book ,dormitory book, book button
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(41, 105, 52, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 15.0,
                              ),
                              child: Center(
                                child: consumer.isProcessing
                                    ? const SizedBox(
                                        height: 17,
                                        width: 17,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color:
                                              Color.fromRGBO(253, 186, 63, 1),
                                        ),
                                      )
                                    : const Text(
                                        'CREATE NEW DORMITORY',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            )),
                        // const SizedBox(
                        //   height: 18,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]);
      })),
    );
  }
}
