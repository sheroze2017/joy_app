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
  String? totalPrice;
  String? status;
  String? createdAt;
  String? quantity;
  String? location;
  String? lat;
  String? lng;
  String? placeId;
  List<Cart>? cart;

  PharmacyOrders(
      {this.orderId,
      this.userId,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.quantity,
      this.location,
      this.lat,
      this.lng,
      this.placeId,
      this.cart});

  PharmacyOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    totalPrice = json['total_price'] ?? '';
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
    quantity = json['quantity'] ?? '';
    location = json['location'] ?? '';
    lat = json['lat'] ?? '';
    lng = json['lng'] ?? '';
    placeId = json['place_id'] ?? '';
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart!.add(new Cart.fromJson(v));
      });
    } else {
      cart = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['place_id'] = this.placeId;
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
  String? qty;
  String? price;
  int? productId;
  String? productName;

  Cart({this.qty, this.price, this.productId, this.productName});

  Cart.fromJson(Map<String, dynamic> json) {
    qty = json['qty'] ?? '';
    ;
    price = json['price'] ?? '';
    ;
    productId = json['product_id'] ?? 0;
    productName = json['product_name'] ?? '';
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    return data;
  }
}
