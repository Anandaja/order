import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_now_android/model/rooms_model.dart';


class DataBaseDetails {
  DateTime? date;
  String name = '';
  String phonenumber = '';
  String proof = '';
  String catogary = '';
  String Totalrate = '';
  String AdvanceAmount = '';
  String uniqueId = '';
  String address = '';
  late bool isReserved;

  List<ReservationListDetails> reserveList = [];

  DataBaseDetails(
      {required this.date,
      required this.name,
      required this.phonenumber,
      required this.proof,
      required this.Totalrate,
      required this.AdvanceAmount,
      required this.uniqueId,
      required this.isReserved,
      required this.reserveList,
      required this.catogary,
      required this.address});

  DataBaseDetails.fromJson(dynamic json) {
// date = json['date'] != null ? DateTime.parse(json['date']) : DateTime.now();

    // Handle Timestamp conversion
    final timestamp = json['date'];
    date =
        timestamp != null ? (timestamp as Timestamp).toDate() : DateTime.now();

    catogary = json['catogary'] ?? '';
    name = json['name'] ?? '';
    phonenumber = json['phonenumber'] ?? '';
    proof = json['proof'] ?? '';
    Totalrate = json['Totalrate'] ?? '';
    AdvanceAmount = json['AdvanceAmount'] ?? '';
    uniqueId = json['uniqueId'] ?? '';
    address = json['address'] ?? '';
    isReserved = json['isReserved'] ?? false;
    reserveList = json['reserveList'] != null
        ? (json['reserveList'] as List<dynamic>)
            .map((e) => ReservationListDetails.fromJson(e))
            .toList()
        : []; // If reserveList is null, create an empty list
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['name'] = name;
    map['phonenumber'] = phonenumber;
    map['proof'] = proof;
    map['catogary'] = catogary;
    map['Totalrate'] = Totalrate;
    map['AdvanceAmount'] = AdvanceAmount;
    map['uniqueId'] = uniqueId;
    map['isReserved'] = isReserved;
    map['reserveList'] = reserveList;
    map['address'] = address;

    return map;
  }

  DataBaseDetails copyWith({
    required DateTime date,
    required String name,
    required String phonenumber,
    required String proof,
    required String Totalrate,
    required String AdvanceAmount,
    required String uniqueId,
    required bool isReserved,
    required List<ReservationListDetails> reserveList,
    required String catogary,
    required String address,
  }) =>
      DataBaseDetails(
          date: date,
          name: name,
          phonenumber: phonenumber,
          proof: proof,
          Totalrate: Totalrate,
          AdvanceAmount: AdvanceAmount,
          uniqueId: uniqueId,
          isReserved: isReserved,
          reserveList: reserveList,
          catogary: catogary,
          address: address);
}

class ReservationListDetails {
  String roomtype = '';
  String roomnoORname = '';
  String rate = '';
  String image = '';
  String floor = '';
  late bool isAvailable;

  ReservationListDetails(
      {required this.roomtype,
      required this.roomnoORname,
      required this.rate,
      required this.image,
      required this.isAvailable,
      required this.floor});

  ReservationListDetails.fromJson(dynamic json) {
    roomtype = json['roomtype'] ?? '';
    roomnoORname = json['roomnoORname'] ?? '';
    rate = json['rate'] ?? '';
    image = json['image'] ?? '';
    isAvailable = json['isAvailable'] ?? '';
    floor = json['floor'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['roomtype'] = roomtype;
    map['roomnoORname'] = roomnoORname;
    map['rate'] = rate;
    map['image'] = image;
    map['isAvailable'] = isAvailable;
    map['floor'] = floor;
    return map;
  }

  RoomDetails copyWith({
    required String roomtype,
    required String roomnoORname,
    required String rate,
    required String image,
    required bool isAvailable,
    required String floor,
  }) =>
      RoomDetails(
          roomtype: roomtype,
          roomno: roomnoORname,
          rate: rate,
          image: image,
          isAvailable: isAvailable,
          floor: floor);

//test fo the filter button
  ReservationListDetails.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    roomnoORname = snapshot.get('roomnoORname');
    roomtype = snapshot.get('roomtype');
    rate = snapshot.get('rate');
    isAvailable = snapshot.get('isAvailable');
    image = snapshot.get('image');
    floor = snapshot.get('floor');
  }
}
