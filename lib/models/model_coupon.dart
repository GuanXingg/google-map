class CouponModel {
  late int id;
  late String name;
  late String description;
  late String place;

  CouponModel({required this.id, required this.name, required this.description, required this.place});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    place = json['place'];
  }
}
