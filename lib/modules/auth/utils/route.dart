import 'package:get/get.dart';
import 'package:joy_app/view/home/navbar.dart';

void handleUserRoleNavigation(int userRole) {
  switch (userRole) {
    case 1:
      Get.offAll(() => NavBarScreen(isUser: true));
      break;
    case 2:
      Get.offAll(() => NavBarScreen(isDoctor: true));
      break;
    case 3:
      Get.offAll(() => NavBarScreen(isPharmacy: true));
      break;
    case 4:
      Get.offAll(() => NavBarScreen(isBloodBank: true));
      break;
    case 5:
      Get.offAll(() => NavBarScreen(isHospital: true));
      break;
    default:
      // Handle any unexpected user roles or errors
      Get.snackbar('Error', 'Unsupported user role');
      break;
  }
}
