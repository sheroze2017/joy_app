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
  String? userName; // User name from API
  String? userEmail; // User email from API
  String? userPhone; // User phone from API
  String? userImage; // User image from API

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
      this.review,
      this.userName,
      this.userEmail,
      this.userPhone,
      this.userImage});

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
    
    // Handle user information fields - handle null and "null" string cases
    final userNameRaw = json['user_name'];
    final userEmailRaw = json['user_email'];
    final userPhoneRaw = json['user_phone'];
    final userImageRaw = json['user_image'];
    
    userName = (userNameRaw != null && userNameRaw.toString().toLowerCase() != 'null' && userNameRaw.toString().trim().isNotEmpty)
        ? userNameRaw.toString().trim()
        : null;
    userEmail = (userEmailRaw != null && userEmailRaw.toString().toLowerCase() != 'null' && userEmailRaw.toString().trim().isNotEmpty)
        ? userEmailRaw.toString().trim()
        : null;
    userPhone = (userPhoneRaw != null && userPhoneRaw.toString().toLowerCase() != 'null' && userPhoneRaw.toString().trim().isNotEmpty)
        ? userPhoneRaw.toString().trim()
        : null;
    userImage = (userImageRaw != null && userImageRaw.toString().toLowerCase() != 'null' && userImageRaw.toString().trim().isNotEmpty)
        ? userImageRaw.toString().trim()
        : null;
    
    // Debug logging for user fields
    print('📦 [PharmacyOrders] Parsing user fields:');
    print('   - user_name (raw): $userNameRaw');
    print('   - user_name (parsed): $userName');
    print('   - user_email (raw): $userEmailRaw');
    print('   - user_email (parsed): $userEmail');
    print('   - user_phone (raw): $userPhoneRaw');
    print('   - user_phone (parsed): $userPhone');
    print('   - user_image (raw): $userImageRaw');
    print('   - user_image (parsed): $userImage');
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
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['user_image'] = this.userImage;
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
