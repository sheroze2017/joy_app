import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
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
      String dosage) async {
    try {
      final result = await _dioClient.post(Endpoints.createProduct, data: {
        "name": medName,
        "short_description": shortDesc,
        "category_id": categoryId,
        "price": price,
        "discount": discount,
        "pharmacy_id": pharmacyId,
        "quantity": quantity,
        "dosage": dosage
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

  Future<AllOrders> getAllOrders(userId) async {
    try {
      final result =
          await _dioClient.get(Endpoints.getAllOrders + '?user_id=15');
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
  int? orderId;
  int? userId;
  int? productId;
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
    orderId = json['order_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    totalPrice = json['total_price'];
    status = json['status'];
    createdAt = json['created_at'];
    quantity = json['quantity'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
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
