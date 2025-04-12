import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDetails {
  String roomtype = '';
  String roomno = '';
  String rate = '';
  String image = '';
  String floor = '';
  late bool isAvailable;

  RoomDetails(
      {required this.roomtype,
      required this.roomno,
      required this.rate,
      required this.image,
      required this.isAvailable,
      required this.floor});

  RoomDetails.fromJson(dynamic json) {
    roomtype = json['roomtype'] ?? '';
    roomno = json['roomno'] ?? '';
    rate = json['rate'] ?? '';
    image = json['image'] ?? '';
    isAvailable = json['isAvailable'] ?? '';
    floor = json['floor'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['roomtype'] = roomtype;
    map['roomno'] = roomno;
    map['rate'] = rate;
    map['image'] = image;
    map['isAvailable'] = isAvailable;
    map['floor'] = floor;
    return map;
  }

  RoomDetails copyWith({
    required String roomtype,
    required String roomno,
    required String rate,
    required String image,
    required bool isAvailable,
    required String floor,
  }) =>
      RoomDetails(
          roomtype: roomtype,
          roomno: roomno,
          rate: rate,
          image: image,
          isAvailable: isAvailable,
          floor: floor);

//test fo the filter button
  RoomDetails.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    roomno = snapshot.get('roomno');
    roomtype = snapshot.get('roomtype');
    rate = snapshot.get('rate');
    isAvailable = snapshot.get('isAvailable');
    image = snapshot.get('image');
    floor = snapshot.get('floor');
  }
}
