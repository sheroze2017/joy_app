import 'package:joy_app/core/constants/endpoints.dart';
import 'package:joy_app/core/network/request.dart';
import 'package:joy_app/modules/pharmacy/models/all_orders.dart';
import 'package:joy_app/modules/pharmacy/models/create_product_model.dart';

import '../models/all_category.dart';

class CreateProductApi {
  final DioClient _dioClient;
  //final LocationService _locationService = LocationService.getInstance();

  CreateProductApi(this._dioClient);

  Future<CreateProduct> createProduct(
      String medName,
      String shortDesc,
      String categoryId,
      String price,
      String discount,
      String pharmacyId,
      String quantity,
      String dosage,
      String imgUrl) async {
    try {
      final result = await _dioClient.post(Endpoints.createProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category_id": categoryId,
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": quantity,
        "dosage": dosage,
        "image": imgUrl
      });
      return CreateProduct.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // New method to create product with category as string (matches edit product format)
  Future<CreateProduct> createProductWithCategory(
    String medName,
    String shortDesc,
    String category, // Category as string (e.g., "Anesthesiologist", "PILL")
    String price,
    String discount,
    String pharmacyId,
    String quantity,
    String dosage,
    String imgUrl,
  ) async {
    try {
      final result = await _dioClient.post(Endpoints.createProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category": category, // Use category as string
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": int.tryParse(quantity) ?? 0, // Quantity as int, default to 0 if parsing fails
        "dosage": dosage,
        "image": imgUrl
      });
      return CreateProduct.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<CreateProduct> editProduct(
    String medName,
    String shortDesc,
    String categoryId,
    String price,
    String discount,
    String pharmacyId,
    String quantity,
    String dosage,
    String productId,
  ) async {
    try {
      final result =
          await _dioClient.post(Endpoints.editPharmacyProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category_id": categoryId,
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": quantity,
        "dosage": dosage,
        "product_id": productId
      });
      return CreateProduct.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  // Method to edit product with category as string (matches user's API requirements)
  Future<CreateProduct> editProductWithCategory(
    String medName,
    String shortDesc,
    String category, // Category as string (e.g., "PILL", "SYRUP")
    String price,
    String discount,
    String pharmacyId,
    String quantity,
    String dosage,
    String productId,
  ) async {
    try {
      final result =
          await _dioClient.post(Endpoints.editPharmacyProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category": category, // Use category as string
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": int.tryParse(quantity) ?? 0, // Convert to int
        "dosage": dosage,
        "product_id": productId
      });
      return CreateProduct.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllOrders> getAllOrders(userId) async {
    try {
      final result =
          await _dioClient.get(Endpoints.getAllOrders + '?user_id=${userId}');
      return AllOrders.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<AllCategory> getAllCategory() async {
    try {
      final result = await _dioClient.get(Endpoints.getAllCategories);
      return AllCategory.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<OrderStatus> updateOrderStatusById(
      String orderId, String orderStatus) async {
    try {
      final result = await _dioClient.post(Endpoints.updateOrderStatus,
          data: {"order_id": orderId, "status": orderStatus});
      return OrderStatus.fromJson(result);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}

class OrderStatus {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  OrderStatus({this.code, this.sucess, this.data, this.message});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  dynamic orderId; // Changed to dynamic to handle MongoDB _id (string) or order_id (int)
  dynamic userId; // Changed to dynamic to handle MongoDB string IDs
  dynamic productId; // Changed to dynamic to handle MongoDB string IDs
  String? totalPrice;
  String? status;
  String? createdAt;
  String? quantity;
  String? location;
  String? lat;
  String? lng;
  String? placeId;

  Data(
      {this.orderId,
      this.userId,
      this.productId,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.quantity,
      this.location,
      this.lat,
      this.lng,
      this.placeId});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both _id (MongoDB) and order_id (legacy)
    if (json['_id'] != null) {
      orderId = json['_id'].toString();
    } else {
      orderId = json['order_id']?.toString() ?? json['order_id'];
    }
    
    // Handle user_id - can be string (MongoDB) or int (legacy)
    if (json['user_id'] != null) {
      userId = json['user_id'].toString();
    } else {
      userId = null;
    }
    
    // Handle product_id - can be string (MongoDB) or int (legacy)
    if (json['product_id'] != null) {
      productId = json['product_id'].toString();
    } else {
      productId = null;
    }
    
    // Handle total_price - can be int, double, or string
    if (json['total_price'] != null) {
      if (json['total_price'] is String) {
        totalPrice = json['total_price'];
      } else if (json['total_price'] is num) {
        totalPrice = json['total_price'].toString();
      } else {
        totalPrice = json['total_price']?.toString();
      }
    } else {
      totalPrice = null;
    }
    
    status = json['status']?.toString() ?? '';
    createdAt = json['created_at']?.toString() ?? '';
    
    // Handle quantity - can be int or string
    if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        quantity = json['quantity'].toString();
      } else {
        quantity = json['quantity']?.toString();
      }
    } else {
      quantity = null;
    }
    
    location = json['location']?.toString() ?? '';
    lat = json['lat']?.toString() ?? '';
    lng = json['lng']?.toString() ?? '';
    placeId = json['place_id']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.orderId?.toString();
    data['order_id'] = this.orderId?.toString();
    data['user_id'] = this.userId?.toString();
    data['product_id'] = this.productId?.toString();
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['place_id'] = this.placeId;
    return data;
  }
}
