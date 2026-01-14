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
  dynamic orderId; // Changed to dynamic to handle MongoDB _id (string) or order_id (int)
  dynamic userId; // Changed to dynamic to handle MongoDB string IDs
  String? totalPrice;
  String? status;
  String? createdAt;
  String? quantity;
  String? location;
  String? lat;
  String? lng;
  String? placeId;
  List<Cart>? cart;
  List<Cart>? items; // New field for items array
  dynamic review; // Review can be null or an object

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
      this.cart,
      this.items,
      this.review});

  PharmacyOrders.fromJson(Map<String, dynamic> json) {
    // Handle both _id (MongoDB) and order_id (legacy)
    if (json['_id'] != null) {
      orderId = json['_id'].toString();
    } else {
      orderId = json['order_id']?.toString() ?? '0';
    }
    
    // Handle user_id - can be string (MongoDB) or int (legacy)
    if (json['user_id'] != null) {
      userId = json['user_id'].toString();
    } else {
      userId = null;
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
    
    // Handle items array (new API structure)
    if (json['items'] != null) {
      items = <Cart>[];
      json['items'].forEach((v) {
        items!.add(new Cart.fromJson(v));
      });
    } else {
      items = [];
    }
    
    // Handle cart array (legacy, fallback to items if cart is null)
    if (json['cart'] != null) {
      cart = <Cart>[];
      json['cart'].forEach((v) {
        cart!.add(new Cart.fromJson(v));
      });
    } else if (items != null && items!.isNotEmpty) {
      cart = items; // Use items as cart if cart is null
    } else {
      cart = [];
    }
    
    // Handle review field
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.orderId?.toString();
    data['order_id'] = this.orderId?.toString();
    data['user_id'] = this.userId?.toString();
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['quantity'] = this.quantity;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['place_id'] = this.placeId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    data['review'] = this.review;
    return data;
  }
}

class Cart {
  String? qty;
  String? price;
  dynamic productId; // Changed to dynamic to handle MongoDB string IDs
  String? productName;
  String? status; // Added status field from items

  Cart({this.qty, this.price, this.productId, this.productName, this.status});

  Cart.fromJson(Map<String, dynamic> json) {
    // Handle qty - can be int or string
    if (json['qty'] != null) {
      if (json['qty'] is int) {
        qty = json['qty'].toString();
      } else {
        qty = json['qty']?.toString() ?? '';
      }
    } else {
      qty = '';
    }
    
    // Handle price - can be int, double, or string
    if (json['price'] != null) {
      if (json['price'] is String) {
        price = json['price'];
      } else if (json['price'] is num) {
        price = json['price'].toString();
      } else {
        price = json['price']?.toString() ?? '';
      }
    } else {
      price = '';
    }
    
    // Handle product_id - can be string (MongoDB) or int (legacy)
    if (json['product_id'] != null) {
      productId = json['product_id'].toString();
    } else {
      productId = null;
    }
    
    productName = json['product_name']?.toString() ?? '';
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['product_id'] = this.productId?.toString();
    data['product_name'] = this.productName;
    data['status'] = this.status;
    return data;
  }
}
