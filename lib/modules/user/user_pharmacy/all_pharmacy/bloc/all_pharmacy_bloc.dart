import 'package:get/get.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_api.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/widgets/flutter_toast_message.dart';

class AllPharmacyController extends GetxController {
  late DioClient dioClient;
  late PharmacyApi pharmacyApi;
  RxList<PharmacyModelData> pharmacies = <PharmacyModelData>[].obs;
  RxList<PharmacyProductData> pharmacyProducts = <PharmacyProductData>[].obs;
  RxList<PharmacyProductData> productDetail = <PharmacyProductData>[].obs;
  RxList<PharmacyProductData> cartList = <PharmacyProductData>[].obs;

  var loginLoader = false.obs;
  var registerLoader = false.obs;
  var productDetailLoader = false.obs;
  var allProductLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient.getInstance();
    pharmacyApi = PharmacyApi(dioClient);
  }

  void addToCart(PharmacyProductData product, context) {
    cartList.add(product);

    showSuccessMessage(context, '${product.name} added into cart');
  }

  void removeFromCart(PharmacyProductData product) {
    cartList.remove(product);
  }

  void removeproductCart(PharmacyProductData product) {
    cartList.removeWhere((element) => element.productId == product.productId);
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
    allProductLoader.value = true;
    try {
      pharmacyProducts.clear();
      PharmacyProductModel response =
          await pharmacyApi.getAllPharmacyProducts(userId);
      if (response.data != null) {
        response.data!.forEach((element) {
          pharmacyProducts.add(element);
          print(pharmacyProducts.length);
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
}
