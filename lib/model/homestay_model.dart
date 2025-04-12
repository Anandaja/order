import 'package:cloud_firestore/cloud_firestore.dart';

class HomestayDetails {
  String name = '';
  String rate = '';
  String image = '';
  late bool isAvailable;

  HomestayDetails({
    required this.name,
    required this.rate,
    required this.image,
    required this.isAvailable,
  });

  HomestayDetails.fromJson(dynamic json) {
    name = json['name'] ?? '';
    rate = json['rate'] ?? '';
    image = json['image'] ?? '';
    isAvailable = json['isAvailable'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['rate'] = rate;
    map['name'] = name;
    map['image'] = image;
    map['isAvailable'] = isAvailable;
    return map;
  }

  HomestayDetails copyWith({
    required String name,
    required String rate,
    required String image,
    required bool isAvailable,
  }) =>
      HomestayDetails(
          name: name, rate: rate, image: image, isAvailable: isAvailable);
//test fo the filter button
  HomestayDetails.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    name = snapshot.get('name');
    rate = snapshot.get('rate');
    isAvailable = snapshot.get('isAvailable');
    image = snapshot.get('image');
  }
}
