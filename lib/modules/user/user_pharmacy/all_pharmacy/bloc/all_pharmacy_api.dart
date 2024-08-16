import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';

import '../models/all_pharmacy_model.dart';
import '../models/product_purchase_model.dart';

class PharmacyApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  PharmacyApi(this._dioClient);

  Future<PharmacyModel> getAllPharmacy() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllPharmacy);
      return PharmacyModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PharmacyProductModel> getAllPharmacyProducts(String userId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getPharmacyProduct + '?user_id=$userId');
      return PharmacyProductModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PharmacyProductModel> getPhamracyProductDetails(
      String productId) async {
    try {
      final result = await _dioClient
          .get(Endpoints.getPharmacyProductDetails + '?product_id=$productId');
      return PharmacyProductModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ProductPurchaseModel> placeOrder(
      String userId,
      String totalPrice,
      String status,
      String quantity,
      String location,
      String lat,
      String lng,
      String placeId,
      List<Map<String, dynamic>> cart,String pharmacyId) async {
    try {
      final result = await _dioClient.post(Endpoints.placeOrder, data: {
        "user_id": userId,
        "total_price": totalPrice,
        "status": status,
        "quantity": quantity,
        "location": location,
        "lat": lat,
        "lng": lng,
        "place_id": placeId,
        "pharmacy_id": pharmacyId,
        "cart": cart
      });
      return ProductPurchaseModel.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
