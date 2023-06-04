class CouponModel {
  late int id;
  late String name;
  late String description;
  late String place;
  late String expired;

  CouponModel({
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.expired,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    place = json['place'];
    expired = json['expired'];
  }
}
