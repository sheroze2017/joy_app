import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/doctor/bloc/doctor_api.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';
import 'user_hospital_api.dart';

class UserHospitalController extends GetxController {
  late DioClient dioClient;
  late UserHospitalApi userHospitalApi;
  late DoctorApi doctorApi;
  RxList<Hospital> hospitalList = <Hospital>[].obs;
  RxList<Hospital> searchResults = <Hospital>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    dioClient = DioClient.getInstance();
    userHospitalApi = UserHospitalApi(dioClient);
  }

  void searchHospital(String query) {
    searchQuery.value = query;
    searchResults.value = hospitalList.value
        .where((hosp) => hosp.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<AllHospital> getAllHospitals() async {
    try {
      hospitalList.clear();
      AllHospital response = await userHospitalApi.getAllHospitals();
      if (response.data != null) {
        response.data!.forEach((element) {
          hospitalList.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }
}
