import 'package:hive/hive.dart';
part 'user.g.dart';
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int userId;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String? image;

  @HiveField(5)
  int userRole;

  @HiveField(6)
  int authType;

  @HiveField(7)
  String phone;

  @HiveField(8)
  String lastName;

  @HiveField(9)
  String deviceToken;

  User({
    required this.userId,
    required this.firstName,
    required this.email,
    required this.password,
    this.image,
    required this.userRole,
    required this.authType,
    required this.phone,
    required this.lastName,
    required this.deviceToken,
  });
}
