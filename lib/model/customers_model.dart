// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDetails {
  String roomtype = '';
  String roomnoORname = '';
  String rate = '';
  String floor = '';
  String name = '';
  String address = '';
  String mobileNumber = '';
  String purpose = '';
  String proof = '';
  String checkindate = '';
  String checkintime = '';
  String checkoutdate = '';
  String checkouttime = '';
  String Noofpeople = '';
  String catogary = '';
  String uniqueID = '';
  late bool isCustomerinRoom;

  CustomerDetails(
      {required this.roomtype,
      required this.roomnoORname,
      required this.rate,
      required this.floor,
      required this.name,
      required this.address,
      required this.mobileNumber,
      required this.purpose,
      required this.proof,
      required this.checkindate,
      required this.checkintime,
      required this.checkoutdate,
      required this.checkouttime,
      required this.Noofpeople,
      required this.catogary,
      required this.isCustomerinRoom,
      required this.uniqueID});

  CustomerDetails.fromJson(dynamic json) {
    roomtype = json['roomtype'] ?? '';
    roomnoORname = json['roomnoORname'] ?? '';
    rate = json['rate'] ?? '';
    floor = json['floor'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    mobileNumber = json['mobileNumber'] ?? '';
    proof = json['proof'] ?? '';
    purpose = json['purpose'] ?? '';
    checkindate = json['checkindate'] ?? '';
    checkintime = json['checkintime'] ?? '';
    checkoutdate = json['checkoutdate'] ?? '';
    checkouttime = json['checkouttime'] ?? '';
    Noofpeople = json['Noofpeople'] ?? '';
    catogary = json['catogary'] ?? '';
    uniqueID = json['uniqueID'] ?? '';
    isCustomerinRoom = json['isCustomerinRoom'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isCustomerinRoom'] = isCustomerinRoom;
    map['roomtype'] = roomtype;
    map['roomnoORname'] = roomnoORname;
    map['rate'] = rate;
    map['floor'] = floor;
    map['name'] = name;
    map['address'] = address;
    map['mobileNumber'] = mobileNumber;
    map['proof'] = proof;
    map['purpose'] = purpose;
    map['checkindate'] = checkindate;
    map['checkintime'] = checkintime;
    map['checkoutdate'] = checkoutdate;
    map['checkouttime'] = checkouttime;
    map['Noofpeople'] = Noofpeople;
    map['catogary'] = catogary;
    map['uniqueID'] = uniqueID;
    return map;
  }

  CustomerDetails copyWith({
    required String roomtype,
    required String roomnoORname,
    required String rate,
    required String image,
    required bool isAvailable,
    required String floor,
    required String name,
    required String address,
    required String mobileNumber,
    required String purpose,
    required String proof,
    required String checkindate,
    required String checkintime,
    required String checkoutdate,
    required String checkouttime,
    required String Noofpeople,
    required String catogary,
    required bool isCustomerinRoom,
    required String uniqueID,
  }) =>
      CustomerDetails(
          roomtype: roomtype,
          roomnoORname: roomnoORname,
          rate: rate,
          floor: floor,
          name: name,
          address: address,
          mobileNumber: mobileNumber,
          purpose: purpose,
          proof: proof,
          checkindate: checkindate,
          checkintime: checkintime,
          checkoutdate: checkoutdate,
          checkouttime: checkouttime,
          Noofpeople: Noofpeople,
          catogary: catogary,
          isCustomerinRoom: isCustomerinRoom,
          uniqueID: uniqueID);

  CustomerDetails.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    roomnoORname = snapshot.get('roomnoORname');
    roomtype = snapshot.get('roomtype');
    rate = snapshot.get('rate');
    floor = snapshot.get('floor');
    name = snapshot.get('name');
    address = snapshot.get('address');
    mobileNumber = snapshot.get('mobileNumber');
    purpose = snapshot.get('purpose');
    proof = snapshot.get('proof');
    checkindate = snapshot.get('checkindate');
    checkintime = snapshot.get('checkintime');
    checkoutdate = snapshot.get('checkoutdate');
    isCustomerinRoom = snapshot.get('isCustomerinRoom');
    checkouttime = snapshot.get('checkouttime');
    Noofpeople = snapshot.get('Noofpeople');
    catogary = snapshot.get('catogary');
    uniqueID = snapshot.get('uniqueID');
  }
}
