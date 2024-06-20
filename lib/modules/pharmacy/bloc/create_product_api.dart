import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';

class CreateProductApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  CreateProductApi(this._dioClient);

  Future<CreateProduct> createProduct(
      String medName,
      String shortDesc,
      String categoryId,
      String subCategoryId,
      String price,
      String discount,
      String pharmacyId,
      String quantity) async {
    try {
      final result = await _dioClient.post(Endpoints.createProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": quantity
      });
      return CreateProduct.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
