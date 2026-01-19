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
    searchResults.value = pharmacies
        .where((pharma) =>
            pharma.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addToCart(PharmacyProductData product, context) {
    print('🛒 [Cart] ========== ADD TO CART ==========');
    print('🛒 [Cart] Product Details:');
    print('   - Product ID: ${product.productId}');
    print('   - Product Name: ${product.name}');
    print('   - Price: ${product.price} Rs');
    print('   - Available Quantity: ${product.quantity}');
    print('   - Pharmacy ID: ${product.pharmacyId}');
    print('   - Category: ${product.category ?? "N/A"}');
    print('   - Dosage: ${product.dosage ?? "N/A"}');
    
    // Log current cart state before adding
    print('🛒 [Cart] Current Cart State:');
    print('   - Total Items in Cart: ${cartItems.length}');
    if (cartItems.isNotEmpty) {
      print('   - Current Cart Items:');
      for (int i = 0; i < cartItems.length; i++) {
        final item = cartItems[i];
        print('     ${i + 1}. ${item.name} (ID: ${item.productId}) - Qty: ${item.cartQuantity ?? 0} - Price: ${item.price} Rs');
      }
    } else {
      print('   - Cart is empty');
    }
    
    // Check if cart has items from a different pharmacy
    if (cartItems.isNotEmpty) {
      final currentPharmacyId = cartItems.first.pharmacyId;
      if (currentPharmacyId != product.pharmacyId) {
        print('❌ [Cart] Different pharmacy detected!');
        print('   - Current pharmacy in cart: $currentPharmacyId');
        print('   - New product pharmacy: ${product.pharmacyId}');
        print('   - Cannot add product from different pharmacy');
        Get.snackbar(
          'Error',
          'You already have items in cart with another pharmacy. Please empty the cart first to add from other pharmacy.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        print('🛒 [Cart] ======================================');
        return; // Exit early, don't add the product
      }
    }
    
    int index =
        cartItems.indexWhere((item) => item.productId == product.productId);
    
    // Get current quantity in cart
    final currentQuantity = index != -1 ? (cartItems[index].cartQuantity ?? 0) : 0;
    final availableStock = product.quantity ?? 0;
    
    print('🛒 [Cart] Quantity Check:');
    print('   - Current quantity in cart: $currentQuantity');
    print('   - Available stock: $availableStock');
    
    // Check if we can add more (don't exceed available stock)
    if (currentQuantity >= availableStock) {
      print('❌ [Cart] Cannot add more - Stock limit reached');
      print('   - Current in cart: $currentQuantity');
      print('   - Available stock: $availableStock');
      Get.snackbar('Error', 'Cannot add more. Only $availableStock available');
      return;
    }
    
    if (index != -1) {
      // Item already in cart, increment quantity and reassign to trigger reactive update
      print('➕ [Cart] Item already in cart - Incrementing quantity');
      final updatedItem = cartItems[index];
      final oldQuantity = updatedItem.cartQuantity ?? 0;
      updatedItem.cartQuantity = oldQuantity + 1;
      cartItems[index] = updatedItem; // Reassign to trigger reactive update
      print('✅ [Cart] Quantity updated: $oldQuantity → ${updatedItem.cartQuantity}');
    } else {
      // New item, add to cart and show message
      print('🆕 [Cart] New item - Adding to cart');
      product.cartQuantity = 1;
      cartItems.add(product);
      print('✅ [Cart] Product added to cart');
      showSuccessMessage(context, '${product.name} added into cart');
    }
    
    // Log final cart state
    print('🛒 [Cart] Final Cart State:');
    print('   - Total Items in Cart: ${cartItems.length}');
    if (cartItems.isNotEmpty) {
      print('   - Cart Items:');
      for (int i = 0; i < cartItems.length; i++) {
        final item = cartItems[i];
        print('     ${i + 1}. ${item.name} (ID: ${item.productId}) - Qty: ${item.cartQuantity ?? 0} - Price: ${item.price} Rs - Total: ${(item.cartQuantity ?? 0) * double.parse(item.price?.toString() ?? '0')} Rs');
      }
      print('   - Grand Total: ${calculateGrandTotal()} Rs');
    }
    print('🛒 [Cart] ======================================');
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

  // Check if cart is empty
  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  // Get the pharmacy ID of items currently in cart (returns null if cart is empty)
  String? getCartPharmacyId() {
    if (cartItems.isEmpty) {
      return null;
    }
    return cartItems.first.pharmacyId?.toString();
  }

  // Check if user can navigate to a pharmacy (cart must be empty or same pharmacy)
  bool canNavigateToPharmacy(String pharmacyId) {
    if (cartItems.isEmpty) {
      return true; // Cart is empty, can navigate to any pharmacy
    }
    // Cart has items, can only navigate to the same pharmacy
    final currentPharmacyId = getCartPharmacyId();
    return currentPharmacyId == pharmacyId;
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
