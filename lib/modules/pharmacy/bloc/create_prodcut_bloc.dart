import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_product_api.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';
import 'package:joy_app/view/home/navbar.dart';

import '../../../core/network/request.dart';

class ProductController extends GetxController {
  late DioClient dioClient;
  late CreateProductApi createProductApi;
  var createProLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    createProductApi = CreateProductApi(dioClient);
  }

  Future<CreateProduct> createProduct(
      medName,
      shortDesc,
      categoryId,
      subCategoryId,
      price,
      discount,
      pharmacyId,
      quantity,
      BuildContext context) async {
    createProLoader.value = true;
    try {
      CreateProduct response = await createProductApi.createProduct(
          medName,
          shortDesc,
          categoryId,
          subCategoryId,
          price,
          discount,
          pharmacyId,
          quantity);

      if (response.data != null) {
        showSuccessMessage(context, 'Medicine Added');

        Get.offAll(NavBarScreen(
          isPharmacy: true,
        ));
        showSuccessMessage(context, 'Login Successfully');
        // if (response.data!.userRole == 1) {
        //   Get.offAll(NavBarScreen(isUser: true));
        // }
      } else {
        showSuccessMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      createProLoader.value = false;

      throw (error);
    } finally {
      createProLoader.value = false;
    }
  }
}
