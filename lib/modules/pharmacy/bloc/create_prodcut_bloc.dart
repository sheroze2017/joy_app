import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_product_api.dart';
import 'package:joy_app/modules/pharmacy/models/all_category.dart';
import 'package:joy_app/modules/pharmacy/models/all_orders.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';

import '../../../core/network/request.dart';
import '../../auth/models/user.dart';
import '../../auth/utils/auth_hive_utils.dart';

class ProductController extends GetxController {
  late DioClient dioClient;
  late CreateProductApi createProductApi;
  var createProLoader = false.obs;
  var changeStatusLoader = false.obs;
  final pharmacyController = Get.find<AllPharmacyController>();
  RxList<PharmacyOrders> pharmaciesOrder = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> pendingOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> confirmedOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> onTheWayOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> deliveredOrders = <PharmacyOrders>[].obs;
  RxList<PharmacyOrders> cancelledOrders = <PharmacyOrders>[].obs;
  RxList<Category> categoriesList = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    createProductApi = CreateProductApi(dioClient);
    allCategory();
  }

  Future<CreateProduct> createProduct(
      medName,
      shortDesc,
      categoryId,
      price,
      discount,
      pharmacyId,
      quantity,
      dosage,
      imgUrl,
      BuildContext context) async {
    createProLoader.value = true;
    UserHive? currentUser = await getCurrentUser();

    try {
      CreateProduct response = await createProductApi.createProduct(
          medName.toString(),
          shortDesc.toString(),
          categoryId.toString(),
          price.toString(),
          discount.toString(),
          currentUser!.userId.toString(),
          quantity.toString(),
          dosage.toString(),
          imgUrl.toString());

      if (response.data != null) {
        showSuccessMessage(context, 'Medicine Added');

        Get.offAll(NavBarScreen(
          isPharmacy: true,
        ));
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

  // New method to create product with category as string (matches edit product format)
  Future<CreateProduct?> createProductWithCategory(
      String medName,
      String shortDesc,
      String category, // Category as string (e.g., "Anesthesiologist", "PILL")
      String price,
      String discount,
      String pharmacyId,
      String quantity,
      String dosage,
      String imgUrl,
      BuildContext context) async {
    createProLoader.value = true;
    try {
      CreateProduct response = await createProductApi.createProductWithCategory(
        medName,
        shortDesc,
        category,
        price,
        discount,
        pharmacyId,
        quantity,
        dosage,
        imgUrl,
      );

      if (response.data != null) {
        // Don't show success message here - let the calling widget handle it
        // This prevents AnimationController errors when context is disposed
        return response;
      } else {
        showErrorMessage(context, response.message.toString());
        return null;
      }
    } catch (error) {
      print(error);
      showErrorMessage(context, 'Failed to create product: ${error.toString()}');
      return null;
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
      UserHive? currentUser = await getCurrentUser();

      CreateProduct response = await createProductApi.editProduct(
        medName,
        shortDesc,
        categoryId.toString(),
        price,
        discount,
        currentUser!.userId.toString(),
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
      print(error);
      createProLoader.value = false;

      throw (error);
    } finally {
      createProLoader.value = false;
    }
  }

  // New method to edit product with category as string (matches user's API requirements)
  Future<CreateProduct?> editProductWithCategory(
      String medName,
      String shortDesc,
      String category, // Category as string (e.g., "PILL", "SYRUP")
      String price,
      String discount,
      String pharmacyId,
      String quantity,
      String dosage,
      String productId,
      BuildContext context) async {
    createProLoader.value = true;
    try {
      CreateProduct response = await createProductApi.editProductWithCategory(
        medName,
        shortDesc,
        category,
        price,
        discount,
        pharmacyId,
        quantity,
        dosage,
        productId,
      );

      if (response.data != null) {
        // Don't show success message here - let the calling widget handle it
        return response;
      } else {
        // Show error message
        showErrorMessage(context, response.message.toString());
        return null;
      }
    } catch (error) {
      print(error);
      showErrorMessage(context, 'Failed to update product: ${error.toString()}');
      return null;
    } finally {
      createProLoader.value = false;
    }
  }

  Future<AllOrders> allOrders(userId, BuildContext? context) async {
    try {
      UserHive? currentUser = await getCurrentUser();

      AllOrders response =
          await createProductApi.getAllOrders(currentUser!.userId.toString());

      if (response.data != null) {
        pendingOrders.clear();
        confirmedOrders.clear();
        onTheWayOrders.clear();
        deliveredOrders.clear();
        cancelledOrders.clear();
        pharmaciesOrder.clear();
        response.data!.forEach((element) {
          pharmaciesOrder.add(element);
          String status = element.status?.toUpperCase() ?? '';
          if (status == 'PENDING') {
            pendingOrders.add(element);
          } else if (status == 'CONFIRMED') {
            confirmedOrders.add(element);
          } else if (status == 'SHIPPED' || status == 'OUT_FOR_DELIVERY' || status == 'ON THE WAY') {
            onTheWayOrders.add(element);
          } else if (status == 'DELIVERED') {
            deliveredOrders.add(element);
          } else if (status == 'CANCELLED') {
            cancelledOrders.add(element);
          } else {
            // Fallback: treat unknown statuses as pending
            pendingOrders.add(element);
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
        // Show success message using Get.context to avoid deactivated widget issues
        try {
          final ctx = Get.context ?? context;
          showSuccessMessage(ctx, response.message.toString());
        } catch (e) {
          // Context might be deactivated, ignore toast error
          print('Could not show success message: $e');
        }
        // Refresh orders list - await to ensure it completes
        await allOrders(null, null);
      } else {
        try {
          final ctx = Get.context ?? context;
          showErrorMessage(ctx, response.message.toString());
        } catch (e) {
          // Context might be deactivated, ignore toast error
          print('Could not show error message: $e');
        }
      }
      return response;
    } catch (error) {
      changeStatusLoader.value = false;
      // Show error message if context is available
      try {
        final ctx = Get.context ?? context;
        showErrorMessage(ctx, 'Failed to update order status: ${error.toString()}');
      } catch (e) {
        // Context might be deactivated, ignore toast error
        print('Could not show error message: $e');
      }
      rethrow;
    } finally {
      changeStatusLoader.value = false;
    }
  }
}
