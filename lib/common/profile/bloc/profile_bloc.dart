import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';

class ProfileController extends GetxController {
  var userId = "".obs;
  var firstName = "".obs;
  var email = "".obs;
  var password = "".obs;
  var image = "".obs;
  var userRole = "".obs;
  var authType = "".obs;
  var phone = "".obs;
  var lastName = "".obs;
  var deviceToken = "".obs;

  void onInit() {
    super.onInit();
    updateUserDetal();
  }

  updateUserDetal() async {
    UserHive? currentUser = await getCurrentUser();
    if (currentUser != null) {
      firstName.value = currentUser.firstName;
      email.value = currentUser.email;
      lastName.value = currentUser.lastName;
      phone.value = currentUser.phone;
      image.value = currentUser.image.toString()!;
      userId.value = currentUser.userId.toString();
      deviceToken.value = currentUser.deviceToken.toString();
      userRole.value = currentUser.userRole.toString();
    }
  }
}
