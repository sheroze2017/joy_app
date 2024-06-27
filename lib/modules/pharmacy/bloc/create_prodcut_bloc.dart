import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:joy_app/Widgets/flutter_toast_message.dart';
import 'package:joy_app/modules/auth/bloc/auth_api.dart';
import 'package:joy_app/modules/auth/models/auth.model.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_product_api.dart';
import 'package:joy_app/modules/pharmacy/models/all_category.dart';
import 'package:joy_app/modules/pharmacy/models/all_orders.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/view/home/navbar.dart';

import '../../../core/network/request.dart';

class ProductController extends GetxController {
  late DioClient dioClient;
  late CreateProductApi createProductApi;
  var createProLoader = false.obs;
  var changeStatusLoader = false.obs;
  final pharmacyController = Get.find<AllPharmacyController>();
  RxList<PharmacyOrders> pharmaciesOrder = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> pendingOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> onTheWayOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> deliveredOrders = <PharmacyOrders>[].obs;
  RxList<Category> categoriesList = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    createProductApi = CreateProductApi(dioClient);
    allCategory();
  }

  Future<CreateProduct> createProduct(medName, shortDesc, categoryId, price,
      discount, pharmacyId, quantity, dosage, BuildContext context) async {
    createProLoader.value = true;
    try {
      CreateProduct response = await createProductApi.createProduct(medName,
          shortDesc, categoryId, price, discount, pharmacyId, quantity, dosage);

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

  Future<CreateProduct> editProduct(
      medName,
      shortDesc,
      categoryId,
      price,
      discount,
      pharmacyId,
      quantity,
      dosage,
      productId,
      BuildContext context) async {
    createProLoader.value = true;
    try {
      CreateProduct response = await createProductApi.editProduct(
        medName,
        shortDesc,
        categoryId,
        price,
        discount,
        pharmacyId,
        quantity,
        dosage,
        productId,
      );

      if (response.data != null) {
        showSuccessMessage(context, 'Medicine Edit Successfully');

        Get.offAll(NavBarScreen(
          isPharmacy: true,
        ));
        // if (response.data!.userRole == 1) {
        //   Get.offAll(NavBarScreen(isUser: true));
        // }
      } else {
        showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      createProLoader.value = false;

      throw (error);
    } finally {
      createProLoader.value = false;
    }
  }

  Future<AllOrders> allOrders(userId, BuildContext context) async {
    try {
      AllOrders response = await createProductApi.getAllOrders(userId);

      if (response.data != null) {
        pendingOrders.clear();
        onTheWayOrders.clear();
        deliveredOrders.clear();
        response.data!.forEach((element) {
          if (element.status == 'Pending') {
            pendingOrders.add(element);
          } else if (element.status == 'On the way') {
            onTheWayOrders.add(element);
          } else {
            deliveredOrders.add(element);
          }
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<AllCategory> allCategory() async {
    categoriesList.clear();
    try {
      AllCategory response = await createProductApi.getAllCategory();

      if (response.data != null) {
        response.data!.forEach((element) {
          categoriesList.add(element);
        });
      } else {}
      return response;
    } catch (error) {
      throw (error);
    } finally {}
  }

  Future<OrderStatus> updateOrderStatus(
      String orderId, String orderStatus, BuildContext context) async {
    try {
      changeStatusLoader.value = true;
      OrderStatus response =
          await createProductApi.updateOrderStatusById(orderId, orderStatus);

      if (response.data != null) {
        showSuccessMessage(context, response.message.toString());
        allOrders('1', context);
      } else {
        showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      changeStatusLoader.value = false;
      throw (error);
    } finally {
      changeStatusLoader.value = false;
    }
  }
}
