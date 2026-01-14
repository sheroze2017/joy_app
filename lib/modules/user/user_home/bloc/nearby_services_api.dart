import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_home/model/nearby_services_model.dart';

class NearbyServicesApi {
  final DioClient _dioClient;

  NearbyServicesApi(this._dioClient);

  Future<NearbyServicesAndBookings> getNearbyServicesAndBookings(userId) async {
    try {
      final url = "${Endpoints.getNearbyServicesAndBookings}?user_id=${userId.toString()}";
      print("🌐 [NearbyServicesApi] GET $url");
      final result = await _dioClient.get(url);
      print("✅ [NearbyServicesApi] Nearby services response: code=${result['code']}, success=${result['sucess'] ?? result['success']}, message=${result['message']}");
      return NearbyServicesAndBookings.fromJson(result);
    } catch (e) {
      print("❌ [NearbyServicesApi] Error: ${e.toString()}");
      throw e;
    }
  }
}
