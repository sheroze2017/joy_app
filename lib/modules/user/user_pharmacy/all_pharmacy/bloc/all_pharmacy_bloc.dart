import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/auth/models/user.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_api.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';

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
            total + ((item.cartQuantity ?? 0) * double.parse(item.price?.toString() ?? '0')));
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
    
    // Get current quantity in cart
    final currentQuantity = index != -1 ? (cartItems[index].cartQuantity ?? 0) : 0;
    final availableStock = product.quantity ?? 0;
    
    // Check if we can add more (don't exceed available stock)
    if (currentQuantity >= availableStock) {
      Get.snackbar('Error', 'Cannot add more. Only $availableStock available');
      return;
    }
    
    if (index != -1) {
      // Item already in cart, increment quantity and reassign to trigger reactive update
      final updatedItem = cartItems[index];
      updatedItem.cartQuantity = (updatedItem.cartQuantity ?? 0) + 1;
      cartItems[index] = updatedItem; // Reassign to trigger reactive update
    } else {
      // New item, add to cart and show message
      product.cartQuantity = 1;
      cartItems.add(product);
      showSuccessMessage(context, '${product.name} added into cart');
    }
    // cartItems is RxList, so changes are automatically reactive
  }

  void removeFromCart(PharmacyProductData product) {
    int index =
        cartItems.indexWhere((item) => item.productId == product.productId);
    if (index != -1) {
      final currentQuantity = cartItems[index].cartQuantity ?? 0;
      // Don't allow quantity to go below 0
      if (currentQuantity > 0) {
        final updatedItem = cartItems[index];
        updatedItem.cartQuantity = currentQuantity - 1;
        // Remove from cart if quantity reaches 0
        if (updatedItem.cartQuantity! <= 0) {
          cartItems.removeAt(index);
        } else {
          // Reassign to trigger reactive update
          cartItems[index] = updatedItem;
        }
      }
    }
    // cartItems is RxList, so changes are automatically reactive
  }

  int getQuantityOfProduct(PharmacyProductData product) {
    int quantity = 0;
    for (var item in cartItems) {
      if (item.productId == product.productId) {
        quantity = item.cartQuantity ?? 0;
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
      searchPharmacyProducts.clear();
      PharmacyProductModel response = await pharmacyApi.getAllPharmacyProducts(
          isUser ? userId : currentUser!.userId.toString());
      if (response.data != null && response.data!.isNotEmpty) {
        // Use assignAll to update the list atomically instead of forEach + add
        pharmacyProducts.assignAll(response.data!);
        searchPharmacyProducts.assignAll(response.data!);
        print('Loaded ${pharmacyProducts.length} products');
      } else {
        print('No products in response data');
      }
      allProductLoader.value = false;
      return response;
    } catch (error) {
      print('Error loading products: $error');
      allProductLoader.value = false;
      // Don't throw, just return empty response
      return PharmacyProductModel();
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
      searchPharmacyProducts.assignAll(pharmacyProducts);
    } else {
      searchPharmacyProducts.assignAll(pharmacyProducts
          .where((product) =>
              product.name!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
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
        // Clear cart after successful order
        cartItems.clear();
        
        placeOrderLoader.value = false;
        
        // Close the cart screen first
        Get.back();
        
        // Wait a bit for navigation to complete, then show success message
        Future.delayed(Duration(milliseconds: 300), () {
          Get.snackbar(
            'Success',
            'Your Order has been placed successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.darkGreenColor,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        });
      } else {
        placeOrderLoader.value = false;
        showErrorMessage(context, response.message?.toString() ?? 'Failed to place order');
      }
      return response;
    } catch (error) {
      placeOrderLoader.value = false;
      showErrorMessage(context, 'Failed to place order: ${error.toString()}');
      return ProductPurchaseModel(); // Return empty model on error
    }
  }
}
