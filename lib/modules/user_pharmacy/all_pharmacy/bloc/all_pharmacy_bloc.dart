import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/bloc/all_pharmacy_api.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/view/home/navbar.dart';

class AllPharmacyController extends GetxController {
  late DioClient dioClient;
  late PharmacyApi pharmacyApi;
  RxList<PharmacyModelData> pharmacies = <PharmacyModelData>[].obs;
  RxList<PharmacyProductData> pharmacyProducts = <PharmacyProductData>[].obs;
  RxList<PharmacyProductData> productDetail = <PharmacyProductData>[].obs;

  var loginLoader = false.obs;
  var registerLoader = false.obs;
  var productDetailLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    pharmacyApi = PharmacyApi(dioClient);
  }

  Future<PharmacyModel> getAllPharmacy() async {
    try {
      pharmacies.clear();
      PharmacyModel response = await pharmacyApi.getAllPharmacy();
      if (response.data != null) {
        response.data!.forEach((element) {
          pharmacies.add(element);
        });
        //showSuccessMessage(context, response.message.toString());
      } else {
        //showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<PharmacyProductModel> getPharmacyProduct(userId) async {
    try {
      pharmacyProducts.clear();
      PharmacyProductModel response =
          await pharmacyApi.getAllPharmacyProducts(userId);
      if (response.data != null) {
        response.data!.forEach((element) {
          pharmacyProducts.add(element);
          print(pharmacyProducts.length);
        });
        //showSuccessMessage(context, response.message.toString());
      } else {
        //showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<PharmacyProductModel> getPharmacyProductDetails(productId) async {
    productDetailLoader.value = true;
    try {
      productDetail.clear();
      PharmacyProductModel response =
          await pharmacyApi.getPhamracyProductDetails(productId);
      if (response.data != null) {
        response.data!.forEach((element) {
          productDetail.add(element);
        });
        //showSuccessMessage(context, response.message.toString());
      } else {
        //showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      productDetailLoader.value = false;

      throw (error);
    } finally {
      productDetailLoader.value = false;
    }
  }
}
