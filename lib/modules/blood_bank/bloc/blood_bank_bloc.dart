import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
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

  final _bloodBankDetails = Rxn<BloodBankDetails>();
  var appointmentLoader = false.obs;
  var bloodBankHomeLoader = false.obs;
  var editLoader = false.obs;
  var val = 0.0.obs;

  BloodBankDetails? get bloodBankDetail => _bloodBankDetails.value;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    bloodBankApi = BloodBankApi(dioClient);
    UserHive? currentUser = await getCurrentUser();
    getBloodBankDetail(currentUser!.userId.toString());

    getAllBloodRequest();
    getallDonor();
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
    } finally {}
  }

  Future<BloodBankDetails> getBloodBankDetail(userId) async {
    bloodBankHomeLoader.value = true;

    try {
      BloodBankDetails response = await bloodBankApi.getBloodBankDetail(userId);
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

  // updateDoctor(
  //     String userId,
  //     String name,
  //     String email,
  //     String password,
  //     String location,
  //     String deviceToken,
  //     String gender,
  //     String userRole,
  //     String authType,
  //     String phone,
  //     String expertise,
  //     String consultationFee,
  //     String qualifications,
  //     String document,
  //     BuildContext context) async {
  //   try {
  //     bool response = await doctorApi.updateDoctor(
  //       userId,
  //       name,
  //       email,
  //       password,
  //       location,
  //       deviceToken,
  //       gender,
  //       userRole,
  //       authType,
  //       phone,
  //       expertise,
  //       consultationFee,
  //       qualifications,
  //       document,
  //     );

  //     if (response == true) {
  //       showSuccessMessage(context, 'Profile Updated');
  //     } else {
  //       showErrorMessage(context, 'Error updating Profile');
  //     }
  //   } catch (error) {
  //     throw (error);
  //   } finally {}
  // }

  // updateAppointment(String appointmentId, String status, String remarks,
  //     BuildContext context, doctorId) async {
  //   appointmentLoader.value = true;
  //   try {
  //     bool response = await doctorApi.updateAppointmentStatus(
  //         appointmentId, status, remarks);

  //     if (response == true) {
  //       showSuccessMessage(context, 'Appointment ${status}');
  //       Get.offAll(DoctorHomeScreen());
  //       AllAppointments('44');
  //     } else {
  //       showErrorMessage(context, 'Error updating Profile');
  //     }
  //   } catch (error) {
  //     appointmentLoader.value = false;
  //     throw (error);
  //   } finally {
  //     appointmentLoader.value = false;
  //   }
  // }

  // Future<bool> doctorRegister(
  //     firstName,
  //     location,
  //     phoneNo,
  //     deviceToken,
  //     authType,
  //     userRole,
  //     String email,
  //     String password,
  //     gender,
  //     expertise,
  //     qualification,
  //     documentUrl,
  //     consultationFees,
  //     BuildContext context) async {
  //   try {
  //     UserHive? currentUser = await getCurrentUser();

  //     editLoader.value = true;
  //     final response = await doctorApi.EditDoctor(
  //         firstName,
  //         email,
  //         password,
  //         location,
  //         deviceToken,
  //         gender,
  //         phoneNo,
  //         authType,
  //         userRole,
  //         expertise,
  //         consultationFees,
  //         qualification,
  //         documentUrl,
  //         currentUser!.userId.toString());
  //     if (response.data != null) {
  //       saveUserDetailInLocal(
  //           response.data!.userId!,
  //           response.data!.name!.toString(),
  //           email,
  //           password,
  //           response.data!.image.toString(),
  //           response.data!.userRole.toString(),
  //           response.data!.authType.toString(),
  //           response.data!.phone.toString(),
  //           '',
  //           response.data!.deviceToken.toString());
  //       showSuccessMessage(context, 'Profile Edit Successfully');
  //       return true;
  //     } else {
  //       showErrorMessage(context, response.message.toString());
  //       return false;
  //     }

  //     // return response;
  //   } catch (error) {
  //     editLoader.value = false;

  //     throw (error);
  //   } finally {
  //     editLoader.value = false;
  //   }
  // }

  // saveUserDetailInLocal(
  //     int userId,
  //     String firstName,
  //     String email,
  //     String password,
  //     String image,
  //     String userRole,
  //     String authType,
  //     String phone,
  //     String lastName,
  //     String deviceToken) async {
  //   var user = User(
  //       userId: userId,
  //       firstName: firstName,
  //       email: email,
  //       password: password,
  //       userRole: userRole,
  //       authType: authType,
  //       phone: phone,
  //       lastName: lastName,
  //       deviceToken: deviceToken);
  //   await Hive.openBox<User>('users');
  //   final userBox = await Hive.openBox<User>('users');
  //   await userBox.put('current_user', user);
  // }
}
