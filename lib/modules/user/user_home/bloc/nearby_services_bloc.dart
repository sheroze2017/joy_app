import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/user/user_home/bloc/nearby_services_api.dart';
import 'package:joy_app/modules/user/user_home/model/nearby_services_model.dart';

class NearbyServicesController extends GetxController {
  late DioClient dioClient;
  late NearbyServicesApi nearbyServicesApi;
  
  RxList<NearbyPharmacy> pharmacies = <NearbyPharmacy>[].obs;
  RxList<NearbyHospital> hospitals = <NearbyHospital>[].obs;
  RxList<NearbyDoctor> doctors = <NearbyDoctor>[].obs;
  RxList<BloodDonor> bloodDonors = <BloodDonor>[].obs;
  RxList<Booking> bookings = <Booking>[].obs;
  
  var fetchLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    nearbyServicesApi = NearbyServicesApi(dioClient);
    getNearbyServicesAndBookings();
  }

  Future<NearbyServicesAndBookings> getNearbyServicesAndBookings() async {
    fetchLoader.value = true;
    try {
      UserHive? currentUser = await getCurrentUser();
      if (currentUser == null) {
        fetchLoader.value = false;
        return NearbyServicesAndBookings(
          code: 401,
          sucess: false,
          message: 'User not logged in',
        );
      }

      NearbyServicesAndBookings response =
          await nearbyServicesApi.getNearbyServicesAndBookings(currentUser.userId);
      
      if (response.data != null) {
        // Populate pharmacies
        if (response.data!.pharmacies != null) {
          pharmacies.clear();
          pharmacies.addAll(response.data!.pharmacies!);
        }
        
        // Populate hospitals
        if (response.data!.hospitals != null) {
          hospitals.clear();
          hospitals.addAll(response.data!.hospitals!);
        }
        
        // Populate doctors
        if (response.data!.doctors != null) {
          doctors.clear();
          doctors.addAll(response.data!.doctors!);
        }
        
        // Populate blood donors
        if (response.data!.bloodDonors != null) {
          bloodDonors.clear();
          bloodDonors.addAll(response.data!.bloodDonors!);
        }
        
        // Populate bookings
        if (response.data!.bookings != null) {
          bookings.clear();
          bookings.addAll(response.data!.bookings!);
        }
      }
      
      fetchLoader.value = false;
      return response;
    } catch (error) {
      fetchLoader.value = false;
      print('❌ [NearbyServicesController] Error: $error');
      throw error;
    }
  }
}
