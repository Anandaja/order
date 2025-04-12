import 'package:cloud_firestore/cloud_firestore.dart';

class DormitoryDetails {
  String dormitoryno = '';
  String perHeadRate = '';
  String image = '';
  String floor = '';
  late bool isAvailable;

  DormitoryDetails(
      {required this.dormitoryno,
      required this.perHeadRate,
      required this.image,
      required this.isAvailable,
      required this.floor});

  DormitoryDetails.fromJson(dynamic json) {
    dormitoryno = json['dormitoryno'] ?? '';
    perHeadRate = json['perHeadRate'] ?? '';
    image = json['image'] ?? '';
    isAvailable = json['isAvailable'] ?? '';
    floor = json['floor'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['perHeadRate'] = perHeadRate;
    map['dormitoryno'] = dormitoryno;
    map['image'] = image;
    map['isAvailable'] = isAvailable;
    map['floor'] = floor;
    return map;
  }

  DormitoryDetails copyWith({
    required String dormitoryno,
    required String perHeadRate,
    required String image,
    required bool isAvailable,
    required String floor,
  }) =>
      DormitoryDetails(
          dormitoryno: dormitoryno,
          perHeadRate: perHeadRate,
          image: image,
          isAvailable: isAvailable,
          floor: floor);
//test fo the filter button
  DormitoryDetails.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    dormitoryno = snapshot.get('dormitoryno');
    perHeadRate = snapshot.get('perHeadRate');
    isAvailable = snapshot.get('isAvailable');
    image = snapshot.get('image');
    floor = snapshot.get('floor');
  }
}
