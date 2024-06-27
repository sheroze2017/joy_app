class AllOrders {
  int? code;
  bool? sucess;
  List<PharmacyOrders>? data;
  String? message;

  AllOrders({this.code, this.sucess, this.data, this.message});

  AllOrders.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <PharmacyOrders>[];
      json['data'].forEach((v) {
        data!.add(new PharmacyOrders.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['sucess'] = this.sucess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class PharmacyOrders {
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

  PharmacyOrders(
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

  PharmacyOrders.fromJson(Map<String, dynamic> json) {
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
