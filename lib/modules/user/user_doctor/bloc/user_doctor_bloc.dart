import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_api.dart';
import 'package:joy_app/modules/doctor/models/doctor_detail_model.dart';
import 'package:joy_app/widgets/dailog/success_dailog.dart';
import '../model/all_doctor_model.dart';
import '../model/all_user_appointment.dart';
import '../model/doctor_categories_model.dart';
import 'user_doctor_api.dart';
// ignore: depend_on_referenced_packages

class UserDoctorController extends GetxController {
  late DioClient dioClient;
  late UserDoctorApi userDoctorApi;
  late DoctorApi doctorApi;
  var showLoader = false.obs;
  var reviewLoader = false.obs;
  var createAppointmentLoader = false.obs;
  var appointmentLoader = false.obs;
  var detailLoader = false.obs;
  var rescheduleLoader = false.obs;
  final _doctorDetail = Rxn<DoctorDetail>();
  var val = 0.0.obs;

  DoctorDetail? get doctorDetail => _doctorDetail.value;
  RxList<Doctor> doctorsList = <Doctor>[].obs;
  RxList<Doctor> searchDoctorsList = <Doctor>[].obs;
  RxList<DoctorCategory> doctorCategories = <DoctorCategory>[].obs;
  Rxn<DoctorCategory> selectedCategory = Rxn<DoctorCategory>();
  final Rx<List<List<String>>> daysAvailable = Rx<List<List<String>>>([]);

  var doctorAvailabilityText = 'No dates available'.obs;
  RxList<UserAppointment> userAppointment = <UserAppointment>[].obs;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    userDoctorApi = UserDoctorApi(dioClient);
    doctorApi = DoctorApi(dioClient);
  }

  void _setAvailabilityText() {
    doctorAvailabilityText.value =
        _doctorDetail.value!.data!.availability!.map((availability) {
      if (availability.times!.isEmpty) {
        return '${availability.day}:\nNo available times';
      } else {
        return '${availability.day}:\n${availability.times!.replaceAll(',', ', ')}';
      }
    }).join('\n\n');
  }

  List<List<String>> storeAvailabilityTimes() {
    daysAvailable.value = [];

    _doctorDetail.value!.data!.availability!.forEach((availability) {
      if (availability.times!.isNotEmpty) {
        List<String> timesList =
            availability.times!.split(',').map((time) => time.trim()).toList();
        daysAvailable.value.add(timesList);
      } else {
        daysAvailable.value
            .add([]); // add an empty list for days with no available times
      }
    });
    return daysAvailable.value;
  }

  Future<AllDoctor> getAllDoctors() async {
    try {
      doctorsList.clear();
      AllDoctor response = await userDoctorApi.getAllDoctors();
      if (response.data != null) {
        response.data!.forEach((element) {
          doctorsList.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {
      searchDoctorsList.value = doctorsList;
    }
  }

  Future<AllUserAppointment> getAllUserAppointment() async {
    UserHive? currentUser = await getCurrentUser();
    userAppointment.clear();
    try {
      AllUserAppointment response = await userDoctorApi
          .getAllUserAppointment(currentUser!.userId.toString());
      if (response.data != null) {
        response.data!.forEach((element) {
          userAppointment.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<AllUserAppointment> getUserAppointmentsByStatus() async {
    UserHive? currentUser = await getCurrentUser();
    appointmentLoader.value = true;
    userAppointment.clear();
    try {
      AllUserAppointment response = await userDoctorApi
          .getUserAppointmentsByStatus(currentUser!.userId.toString());
      if (response.data != null) {
        response.data!.forEach((element) {
          userAppointment.add(element);
        });
      } else {}
      appointmentLoader.value = false;
      return response;
    } catch (error) {
      appointmentLoader.value = false;
      throw (error);
    } finally {
      appointmentLoader.value = false;
    }
  }

  Future<bool> createReview(String appointmentId, String rating,
      String review, context) async {
    reviewLoader.value = true;
    try {
      bool response = await userDoctorApi.CreateReview(
          appointmentId, rating, review);
      if (response == true) {
        final ratingValue = int.tryParse(rating) ??
            double.tryParse(rating) ??
            rating;
        final index = userAppointment.indexWhere(
            (element) => element.appointmentId.toString() == appointmentId.toString());
        if (index != -1) {
          userAppointment[index].rating = ratingValue;
          userAppointment[index].review = review;
          userAppointment[index].reviewCreatedAt =
              DateTime.now().toIso8601String();
          userAppointment.refresh();
        }
        showSuccessMessage(context, 'Review created sucessfully !');
        // Refresh appointments to show the new review
        getUserAppointmentsByStatus();
        Get.back(); // Go back to bookings screen
        reviewLoader.value = false;
      } else {
        showErrorMessage(context, 'Error creating review !');
        reviewLoader.value = false;
      }
      return response;
    } catch (error) {
      reviewLoader.value = false;
      throw (error);
    } finally {
      reviewLoader.value = false;
    }
  }

  updateAppointment(String appointmentId, String status, String remarks,
      BuildContext context, doctorId) async {
    appointmentLoader.value = true;
    try {
      bool response = await userDoctorApi.updateAppointmentStatus(
          appointmentId, status, remarks);

      if (response == true) {
        showSuccessMessage(context, 'Appointment ${status}');
        // Remove cancelled appointments from the list
        if (status.toUpperCase() == 'CANCELLED') {
          userAppointment.removeWhere(
              (element) => element.appointmentId?.toString() == appointmentId);
        } else {
          getUserAppointmentsByStatus();
        }
      } else {
        showErrorMessage(context, 'Error updating appointment');
      }
    } catch (error) {
      appointmentLoader.value = false;
      throw (error);
    } finally {
      appointmentLoader.value = false;
    }
  }

  Future<bool> rescheduleAppointment(
      String appointmentId, String date, String time, BuildContext context) async {
    rescheduleLoader.value = true;
    try {
      final response = await userDoctorApi.rescheduleAppointment(appointmentId, date, time);
      if (response) {
        showSuccessMessage(context, 'Appointment rescheduled successfully!');
        getUserAppointmentsByStatus(); // Refresh appointments list
        return true;
      } else {
        showErrorMessage(context, 'Error rescheduling appointment');
        return false;
      }
    } catch (error) {
      rescheduleLoader.value = false;
      showErrorMessage(context, 'Error rescheduling appointment: ${error.toString()}');
      return false;
    } finally {
      rescheduleLoader.value = false;
    }
  }

  Future<bool> cancelAppointment(
      String appointmentId, BuildContext context) async {
    try {
      final response = await userDoctorApi.updateAppointmentStatus(
        appointmentId,
        'CANCELLED',
        'Appointment cancelled by user.',
      );
      if (response) {
        showSuccessMessage(context, 'Appointment cancelled successfully!');
        // Remove cancelled appointment from the list
        userAppointment.removeWhere(
            (element) => element.appointmentId?.toString() == appointmentId);
        return true;
      } else {
        showErrorMessage(context, 'Error cancelling appointment');
        return false;
      }
    } catch (error) {
      showErrorMessage(context, 'Error cancelling appointment: ${error.toString()}');
      return false;
    }
  }

  Future<DoctorDetail> getDoctorDetail(userId) async {
    detailLoader.value = true;
    _doctorDetail.value = null;
    try {
      DoctorDetail response = await doctorApi.getDoctorDetail(userId);

      if (response.data != null) {
        _doctorDetail.value = response;
        _setAvailabilityText();
        detailLoader.value = false;
      } else {
        //   Box<DoctorDetail> box = Hive.box<DoctorDetail>('doctor_details');
        // _doctorDetail.value = box.get(0);
        detailLoader.value = false;
      }
      return response;
    } catch (error) {
      detailLoader.value = false;

      throw (error);
    } finally {
      avgrating();
      detailLoader.value = false;
    }
  }

  Future<bool> createAppoinemntWithDoctor(
      userId,
      doctorId,
      date,
      time,
      complain,
      symptoms,
      location,
      status,
      age,
      gender,
      patientName,
      certificateUrl,
      doctorName,
      context) async {
    createAppointmentLoader.value = true;
    UserHive? currentUser = await getCurrentUser();
    try {
      bool response = await userDoctorApi.createAppointment(
          currentUser!.userId.toString(),
          doctorId,
          date,
          time,
          complain,
          symptoms,
          location,
          status,
          age,
          gender,
          patientName,
          certificateUrl);
      if (response == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: 'Congratulations!',
              content:
                  'Your appointment with ${doctorName} is confirmed for ${date} at ${time}.',
              showButton: true,
              isBookAppointment: true,
            );
          },
        );

        createAppointmentLoader.value = false;
      } else {
        showErrorMessage(context, 'Error booking doctor !');
        createAppointmentLoader.value = false;
      }
      return response;
    } catch (error) {
      createAppointmentLoader.value = false;
      throw (error);
    } finally {
      createAppointmentLoader.value = false;
    }
  }

  avgrating() async {
    if (doctorDetail?.data?.reviews != null && doctorDetail!.data!.reviews!.isNotEmpty) {
      val.value = 0.0; // Reset value before calculating
      doctorDetail!.data!.reviews!.forEach((element) {
        if (element.rating != null) {
          try {
            final ratingValue = element.rating is int 
                ? (element.rating as int).toDouble() 
                : double.parse(element.rating.toString());
            val.value = val.value + (ratingValue / doctorDetail!.data!.reviews!.length);
          } catch (e) {
            // Skip invalid ratings
            print('Error parsing rating: $e');
          }
        }
      });
    }
  }

  void searchByName(String docName) {
    if (docName.isEmpty) {
      searchDoctorsList.value = doctorsList;
    }
    searchDoctorsList.value = doctorsList
        .where((doctor) =>
            doctor.name!.toLowerCase().contains(docName.toLowerCase()))
        .toList();
  }

  Future<DoctorCategoriesWithDoctors> getDoctorCategoriesWithDoctors() async {
    try {
      showLoader.value = true;
      DoctorCategoriesWithDoctors response = await userDoctorApi.getDoctorCategoriesWithDoctors();
      if (response.data != null) {
        doctorCategories.clear();
        // Filter only ACTIVE categories
        final activeCategories = response.data!.where((cat) => cat.status == 'ACTIVE').toList();
        doctorCategories.assignAll(activeCategories);
        
        // If no category is selected, select the first one with doctors
        if (selectedCategory.value == null && activeCategories.isNotEmpty) {
          final categoryWithDoctors = activeCategories.firstWhere(
            (cat) => cat.doctors != null && cat.doctors!.isNotEmpty,
            orElse: () => activeCategories.first,
          );
          selectCategory(categoryWithDoctors);
        }
      }
      showLoader.value = false;
      return response;
    } catch (error) {
      showLoader.value = false;
      throw (error);
    }
  }

  void selectCategory(DoctorCategory category) {
    selectedCategory.value = category;
    doctorsList.clear();
    if (category.doctors != null && category.doctors!.isNotEmpty) {
      doctorsList.assignAll(category.doctors!);
    }
    searchDoctorsList.assignAll(doctorsList);
  }
}
