import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/navbar/view/navbar.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_api.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/widgets/dailog/success_dailog.dart';

import '../models/product_purchase_model.dart';

class AllPharmacyController extends GetxController {
  late DioClient dioClient;
  late PharmacyApi pharmacyApi;
  RxList<PharmacyModelData> pharmacies = <PharmacyModelData>[].obs;
  RxList<PharmacyModelData> searchResults = <PharmacyModelData>[].obs;

  RxList<PharmacyProductData> pharmacyProducts = <PharmacyProductData>[].obs;
  RxList<PharmacyProductData> searchPharmacyProducts =
      <PharmacyProductData>[].obs;

  RxList<PharmacyProductData> productDetail = <PharmacyProductData>[].obs;
  RxList<PharmacyProductData> cartList = <PharmacyProductData>[].obs;
  final cartItems = RxList<PharmacyProductData>();
  var loginLoader = false.obs;
  var registerLoader = false.obs;
  var productDetailLoader = false.obs;
  var allProductLoader = false.obs;
  var placeOrderLoader = false.obs;
  RxString searchQuery = ''.obs;
  var fetchPharmacyLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    pharmacyApi = PharmacyApi(dioClient);
  }

  double calculateGrandTotal() {
    return cartItems.fold(
        0.0,
        (total, item) =>
            total + (item.cartQuantity! * double.parse(item.price.toString())));
  }

  void searchPharmacy(String query) {
    searchQuery.value = query;
    searchResults.value = pharmacies.value
        .where((pharma) =>
            pharma.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addToCart(PharmacyProductData product, context) {
    if (cartItems.isNotEmpty) {
      if (cartItems.any((item) => item.pharmacyId != product.pharmacyId)) {
        cartItems.clear();
      }
    }
    int index =
        cartItems.indexWhere((item) => item.productId == product.productId);
    if (index != -1) {
      cartItems[index].cartQuantity = cartItems[index].cartQuantity! + 1;
    } else {
      product.cartQuantity = 1;
      cartItems.add(product);
      showSuccessMessage(context, '${product.name} added into cart');
    }
    update();
  }

  void removeFromCart(PharmacyProductData product) {
    int index =
        cartItems.indexWhere((item) => item.productId == product.productId);
    if (index != -1) {
      cartItems[index].cartQuantity = cartItems[index].cartQuantity! - 1;
      if (cartItems[index].cartQuantity! <= 0) {
        cartItems.removeAt(index);
      }
    }
    update();
  }

  int getQuantityOfProduct(PharmacyProductData product) {
    int quantity = 0;
    for (var item in cartItems.value) {
      if (item.productId == product.productId) {
        quantity = item.cartQuantity!;
        break;
      }
    }
    return quantity;
  }

  void removeproductCart(PharmacyProductData product) {
    cartItems.removeWhere((element) => element.productId == product.productId);
  }

  List<Map<String, dynamic>> cartItemsToJson() {
    List<Map<String, dynamic>> jsonList = [];
    cartItems.forEach((product) {
      jsonList.add({
        'product_id': product.productId.toString(),
        'product_name': product.name ?? '',
        'qty': product.cartQuantity.toString(),
        'price': product.price ?? '',
      });
    });
    return jsonList;
  }

  Future<PharmacyModel> getAllPharmacy() async {
    fetchPharmacyLoader.value = true;
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
      fetchPharmacyLoader.value = false;
      return response;
    } catch (error) {
      fetchPharmacyLoader.value = false;
      throw (error);
    } finally {
      fetchPharmacyLoader.value = false;
    }
  }

  Future<PharmacyProductModel> getPharmacyProduct(bool isUser, userId) async {
    allProductLoader.value = true;
    UserHive? currentUser = await getCurrentUser();

    try {
      pharmacyProducts.clear();
      PharmacyProductModel response = await pharmacyApi.getAllPharmacyProducts(
          isUser ? userId : currentUser!.userId.toString());
      if (response.data != null) {
        response.data!.forEach((element) {
          pharmacyProducts.add(element);
        });
        allProductLoader.value = false;

        //showSuccessMessage(context, response.message.toString());
      } else {
        allProductLoader.value = false;

        //showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      allProductLoader.value = false;

      throw (error);
    } finally {
      allProductLoader.value = false;
      searchPharmacyProducts.value = pharmacyProducts;
    }
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

  void searchByProduct(String query) {
    if (query.isEmpty) {
      searchPharmacyProducts.value = pharmacyProducts;
    }
    searchPharmacyProducts.value = pharmacyProducts
        .where((product) =>
            product.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<ProductPurchaseModel> placeOrderPharmacy(context, grandTotal, status,
      quantity, location, lat, lng, placeId, cart, pharmacyId) async {
    placeOrderLoader.value = true;
    try {
      UserHive? currentUser = await getCurrentUser();
      List<Map<String, dynamic>> cartlist = await cartItemsToJson();
      print(cartlist);

      ProductPurchaseModel response = await pharmacyApi.placeOrder(
        currentUser!.userId.toString(),
        grandTotal.toString(),
        status.toString(),
        quantity.toString(),
        location.toString(),
        lat.toString(),
        lng.toString(),
        placeId.toString(),
        cartlist,
        pharmacyId.toString(),
      );
      if (response.data != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              pharmacyId: pharmacyId.toString(),
              isPharmacyCheckout: true,
              title: 'Congratulations!',
              content: 'Your Order has been placed !',
              showButton: true,
              isBookAppointment: false,
            );
          },
        );

        // showSuccessMessage(context, response.message.toString());

        placeOrderLoader.value = false;
        // Get.offAll(NavBarScreen(
        //   isUser: true,
        // ));
      } else {
        showErrorMessage(context, response.message.toString());
      }
      return response;
    } catch (error) {
      placeOrderLoader.value = false;

      throw (error);
    } finally {
      placeOrderLoader.value = false;
    }
  }
}
