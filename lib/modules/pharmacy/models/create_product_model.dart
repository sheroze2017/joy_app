class CreateProduct {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  CreateProduct({this.code, this.sucess, this.data, this.message});

  CreateProduct.fromJson(Map<String, dynamic> json) {
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
  dynamic productId; // Changed to dynamic to handle both _id (MongoDB) and product_id (legacy)
  String? name;
  String? shortDescription;
  dynamic categoryId; // Changed to dynamic to handle both string (MongoDB) and int (legacy)
  String? price;
  String? discount;
  dynamic pharmacyId; // Changed to dynamic to handle both String (MongoDB) and int (legacy)
  int? quantity;
  String? dosage;
  String? image;

  Data(
      {this.productId,
      this.name,
      this.shortDescription,
      this.categoryId,
      this.price,
      this.discount,
      this.pharmacyId,
      this.quantity,
      this.dosage,
      this.image});

  Data.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'product_id' (legacy) fields
    if (json['_id'] != null) {
      productId = json['_id'].toString(); // Store as string for MongoDB IDs
    } else {
      productId = json['product_id'];
    }
    
    name = json['name']?.toString();
    shortDescription = json['short_description']?.toString();
    
    // Handle category_id - can be string (MongoDB) or int (legacy)
    if (json['category_id'] != null) {
      categoryId = json['category_id'].toString();
    } else {
      categoryId = null;
    }
    
    // Handle price - can be int, double, or string
    if (json['price'] != null) {
      if (json['price'] is String) {
        price = json['price'];
      } else if (json['price'] is num) {
        price = json['price'].toString();
      } else {
        price = json['price']?.toString();
      }
    } else {
      price = null;
    }
    
    // Handle discount - can be int, double, or string
    if (json['discount'] != null) {
      if (json['discount'] is String) {
        discount = json['discount'];
      } else if (json['discount'] is num) {
        discount = json['discount'].toString();
      } else {
        discount = json['discount']?.toString();
      }
    } else {
      discount = null;
    }
    
    // Handle pharmacy_id - can be string (MongoDB) or int (legacy)
    if (json['pharmacy_id'] != null) {
      pharmacyId = json['pharmacy_id'].toString();
    } else {
      pharmacyId = null;
    }
    
    // Handle quantity
    if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        quantity = json['quantity'];
      } else {
        quantity = int.tryParse(json['quantity'].toString()) ?? 0;
      }
    } else {
      quantity = null;
    }
    
    dosage = json['dosage']?.toString();
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['pharmacy_id'] = this.pharmacyId;
    data['quantity'] = this.quantity;
    return data;
  }
}
