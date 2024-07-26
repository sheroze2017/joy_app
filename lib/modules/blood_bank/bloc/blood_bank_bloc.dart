import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_api.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/blood_bank/model/blood_bank_details_model.dart';

import '../../auth/models/user.dart';

class BloodBankController extends GetxController {
  late DioClient dioClient;
  late BloodBankApi bloodBankApi;
  RxList<BloodDonor> allDonors = <BloodDonor>[].obs;
  RxList<BloodRequest> allBloodRequest = <BloodRequest>[].obs;
  RxList<BloodRequest> allPlasmaRequest = <BloodRequest>[].obs;
  RxList<BloodDonor> searchedDonors = <BloodDonor>[].obs;

  final _bloodBankDetails = Rxn<BloodBankDetails>();
  var appointmentLoader = false.obs;
  var bloodBankHomeLoader = false.obs;
  var editLoader = false.obs;
  var val = 0.0.obs;

  BloodBankDetails? get bloodBankDetail => _bloodBankDetails.value;
  ProfileController _profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    bloodBankApi = BloodBankApi(dioClient);
    if (_profileController.userRole.value == 'USER') {
      getallDonor();
    } else {
      getBloodBankDetail();
      getAllBloodRequest();
      getallDonor();
    }
  }

  void searchByBloodGroup(String bloodGroup) {
    searchedDonors.value = allDonors
        .where((donor) =>
            donor.bloodGroup!.toLowerCase().contains(bloodGroup.toLowerCase()))
        .toList();
    print(searchedDonors);
  }

  // avgrating() async {
  //   doctorDetail!.data!.reviews!.forEach((element) {
  //     val.value = val.value +
  //         (double.parse(element.rating!) / doctorDetail!.data!.reviews!.length);
  //   });
  // }

  Future<AllDonor> getallDonor() async {
    allDonors.clear();
    try {
      AllDonor response = await bloodBankApi.getAllDonor();
      if (response.data != null) {
        response.data!.forEach((element) {
          allDonors.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {
      searchedDonors.value = allDonors;
    }
  }

  Future<BloodBankDetails> getBloodBankDetail() async {
    bloodBankHomeLoader.value = true;

    try {
      UserHive? currentUser = await getCurrentUser();

      BloodBankDetails response =
          await bloodBankApi.getBloodBankDetail(currentUser!.userId.toString());
      if (response.data != null) {
        _bloodBankDetails.value = response;
        bloodBankHomeLoader.value = false;
      } else {
        bloodBankHomeLoader.value = false;
      }
      return response;
    } catch (error) {
      bloodBankHomeLoader.value = false;
      throw (error);
    } finally {
      bloodBankHomeLoader.value = false;
    }
  }

  Future<AllBloodRequest> getAllBloodRequest() async {
    allBloodRequest.clear();
    allPlasmaRequest.clear();
    try {
      AllBloodRequest response = await bloodBankApi.getAllBloodRequest();
      if (response.data != null) {
        response.data!.forEach((element) {
          if (element.type == 'Plasma') {
            allPlasmaRequest.add(element);
          } else {
            allBloodRequest.add(element);
          }
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }
}
