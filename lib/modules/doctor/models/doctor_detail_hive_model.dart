import 'package:hive/hive.dart';

part 'doctor_detail_hive_model.g.dart';

@HiveType(typeId: 1)
class DoctorDetailModel extends HiveObject {
  @HiveField(0)
  int? code;

  @HiveField(1)
  bool? success;

  @HiveField(2)
  DataModel? data;

  @HiveField(3)
  String? message;

  DoctorDetailModel({this.code, this.success, this.data, this.message});
}

@HiveType(typeId: 2)
class DataModel extends HiveObject {
  @HiveField(0)
  int? userId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? image;

  @HiveField(5)
  String? userRole;

  @HiveField(6)
  String? authType;

  @HiveField(7)
  String? phone;

  @HiveField(8)
  String? deviceToken;

  @HiveField(9)
  int? doctorDetailId;

  @HiveField(10)
  String? gender;

  @HiveField(11)
  String? expertise;

  @HiveField(12)
  String? location;

  @HiveField(13)
  String? consultationFee;

  @HiveField(14)
  String? qualifications;

  @HiveField(15)
  List<ReviewModel>? reviews;

  DataModel(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.image,
      this.userRole,
      this.authType,
      this.phone,
      this.deviceToken,
      this.doctorDetailId,
      this.gender,
      this.expertise,
      this.location,
      this.consultationFee,
      this.qualifications,
      this.reviews});
}

@HiveType(typeId: 3)
class ReviewModel extends HiveObject {
  @HiveField(0)
  String? rating;

  @HiveField(1)
  String? review;

  @HiveField(2)
  String? status;

  @HiveField(3)
  GiveByModel? giveBy;

  @HiveField(4)
  int? reviewId;

  @HiveField(5)
  String? createdAt;

  ReviewModel(
      {this.rating,
      this.review,
      this.status,
      this.giveBy,
      this.reviewId,
      this.createdAt});
}

@HiveType(typeId: 4)
class GiveByModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? image;

  GiveByModel({this.name, this.image});
}
