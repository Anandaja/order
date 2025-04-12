import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:order_now_android/view/utilitie/network_connectivity.dart';
import 'package:order_now_android/view_model/admin/dormitory_edit_view_model.dart';
import 'package:provider/provider.dart';

class DormitoryEditPage extends StatefulWidget {
  const DormitoryEditPage({super.key, required this.currentDormitoryData});
  final Map<String, dynamic> currentDormitoryData;

  @override
  DormitoryEditPageState createState() => DormitoryEditPageState();
}

class DormitoryEditPageState extends State<DormitoryEditPage> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    final provider =
        Provider.of<AdminDormitoryEditProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.dormitorynocontoller.text =
          widget.currentDormitoryData['dormitoryno'];
      provider.ratecontroller.text = widget.currentDormitoryData['perHeadRate'];
      provider.InitialFloorValue = widget.currentDormitoryData['floor'];
      provider.AvailablityInitialValue =
          widget.currentDormitoryData['isAvailable'];
    });

    super.initState();
  }

//exit pop from the page
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            title: const Text('Oops! Editing not finished!'),
            content: const Text(
                'Leaving now will clear all Edited Data. Are you sure?'),
            actions: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(0, 255, 255, 255))),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(0, 255, 255, 255))),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .dormitorynocontoller
                      .clear();
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .ratecontroller
                      .clear();
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .isimageAdded = false;
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .areChangesMade = false;
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .ischangedAvailability = false;
                  Provider.of<AdminDormitoryEditProvider>(context,
                          listen: false)
                      .ischangedfloor = false;
                }, // is it works?  androis ios?
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showExitPopup();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        body: Consumer<AdminDormitoryEditProvider>(
            builder: (context, consumer, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //i think we should add this same bol while the user click his back button its now work only while we click this button
                      consumer.isimageAdded =
                          false; //to avoid the showing of added image if it not updated with this it only displays the updated image url in firestore
                      consumer.areChangesMade = false;
                      consumer.ischangedAvailability = false;
                      consumer.ischangedfloor = false;
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
                actions: [
                  IconButton(
                      onPressed: () {
                        consumer.imgFromGallery();
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ))
                ],
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(fit: StackFit.expand, children: [
                  consumer.isImageLoading
                      ? Container(
                          color: Colors
                              .black, // Set a background color while loading
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
                          : Image.network(
                              widget.currentDormitoryData['image'],
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromRGBO(253, 186, 63, 1),
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                ])),
              ),
              //3
              SliverFixedExtentList(
                itemExtent: 600,
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 28,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                height: 27,
                                width: 27,
                                child: Image.asset(
                                  'assets/images/write.png',
                                  fit: BoxFit.contain,
                                )),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text(
                              'EDIT DATA',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Form(
                          key: consumer.formkey4fiealds,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: consumer.testFormFieald(
                                            consumer.dormitorynocontoller,
                                            'Edit Room-No',
                                          )),
                                    ],
                                  ),
                                  const Spacer(),
                                  Form(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    key: consumer.floorkey,
                                    child: Column(
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
                                              2.4,
                                          child: DropdownButtonFormField(
                                            value: widget
                                                    .currentDormitoryData[
                                                        'floor']!
                                                    .isEmpty
                                                ? null
                                                : widget.currentDormitoryData[
                                                    'floor']!,
                                            validator: (value) {
                                              if (value == null) {
                                                return "*required";
                                              }
                                              return null; // no error
                                            },
                                            icon: const Icon(Icons
                                                .keyboard_arrow_down_sharp),
                                            onChanged: (value) {
                                              consumer.FloorFinder(value);
                                              consumer.ischangedfloor = true;
                                              consumer.areChangesMade = true;
                                              if (kDebugMode) {
                                                print(value);
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18.0,
                                                      horizontal: 10.0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Color(0xFF7EC679),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Color(0xFF7EC679),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              filled: true,
                                              labelStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.w800,
                                              ),
                                              hintText: 'Select Floor',
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
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rate',
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
                                              2.4,
                                          child: consumer.testFormFieald(
                                            consumer.ratecontroller,
                                            'Edit Rate',
                                          )),
                                    ],
                                  ),
                                  const Spacer(),
                                  //Purpose drop
                                  Form(
                                    key: consumer.Availbilitykey,
                                    child: Column(
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
                                              2.4,
                                          child: DropdownButtonFormField(
                                              value:
                                                  widget.currentDormitoryData[
                                                      'isAvailable']!,
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
                                                consumer.areChangesMade = true;
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
                                                hintText: 'Select Availblity',
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: const Color.fromRGBO(68, 142, 74, 1),
                          onPressed: () async {
                            connectivity
                                .checkConnectivity()
                                .then((value) async {
                              if (value == ConnectivityResult.none) {
                                // cons.clearingfiealds();
                                NoInternetDialog(context);
                                consumer.isProcessing = false;
                                consumer.areChangesMade = false;
                                consumer.isimageAdded = false;
                                consumer.ischangedAvailability = false;
                                consumer.ischangedfloor = false;
                              } else {
                                if (consumer.formkey4fiealds.currentState!
                                        .validate() &&
                                    consumer.floorkey.currentState!
                                        .validate() &&
                                    consumer.Availbilitykey.currentState!
                                        .validate()) {
                                  if (consumer.areChangesMade) {
                                    try {
                                      consumer.isProcessing = true;

                                      if (kDebugMode) {
                                        print(
                                            consumer.dormitorynocontoller.text);
                                        print(consumer.ratecontroller.text);

                                        print(
                                            'floor ${consumer.currentSelectedfloor}');

                                        print(
                                            'Availability  ${consumer.currentSelectedBoolType}');
                                        consumer.TestChangesMade
                                            ? print('Image changed')
                                            : print('image not updated');
                                      }
                                      await consumer.UpdateDormitoryData(
                                              context,
                                              oldDormitoryno:
                                                  widget.currentDormitoryData[
                                                      'dormitoryno'],
                                              NewDormitoryno: consumer
                                                  .dormitorynocontoller.text,
                                              floor: consumer.ischangedfloor
                                                  ? consumer
                                                      .currentSelectedfloor
                                                  : consumer.InitialFloorValue,
                                              rate:
                                                  consumer.ratecontroller.text,
                                              isAvailable: consumer
                                                      .ischangedAvailability
                                                  ? consumer
                                                      .currentSelectedBoolType
                                                  : consumer
                                                      .AvailablityInitialValue,
                                              image: consumer.isimageAdded
                                                  ? consumer.downloadURL
                                                  : widget.currentDormitoryData[
                                                      'image'])
                                          .then((value) => setState(() {
                                                consumer.areChangesMade = false;
                                              }));
                                    } finally {
                                      consumer.isProcessing = false;
                                      consumer.isimageAdded = false;
                                      consumer.ischangedAvailability = false;
                                      consumer.ischangedfloor = false;

                                      //   Navigator.of(context).pop();
                                    }
                                  } else {
                                    // Show a snack bar indicating that no changes have been made
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No changes made.'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              }
                            });
                          },
                          label: consumer
                                  .isProcessing //is it want? shall we remove it?
                              ? const SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Color.fromRGBO(253, 186, 63, 1),
                                  ),
                                )
                              : const Text(
                                  'Update changes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                          icon: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        )
                      ],
                    ),
                  )
                ]),
              )
            ],
          );
        }),
      ),
    );
  }
}
