import 'package:get/get.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';

void handleUserRoleNavigation(String userRole) {
  switch (userRole) {
    case 'USER':
      Get.offAll(() => NavBarScreen(isUser: true));
      break;
    case 'DOCTOR':
      Get.offAll(() => NavBarScreen(isDoctor: true));
      break;
    case 'PHARMACY':
      Get.offAll(() => NavBarScreen(isPharmacy: true));
      break;
    case 'BLOODBANK':
      Get.offAll(() => NavBarScreen(isBloodBank: true));
      break;
    case 'HOSPITAL':
      Get.offAll(() => NavBarScreen(isHospital: true));
      break;
    default:
      Get.snackbar('Error', 'Unsupported user role');
      break;
  }
}
