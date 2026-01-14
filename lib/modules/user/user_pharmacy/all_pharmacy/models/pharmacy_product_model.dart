class PharmacyProductModel {
  int? code;
  bool? sucess;
  List<PharmacyProductData>? data;
  String? message;

  PharmacyProductModel({this.code, this.sucess, this.data, this.message});

  PharmacyProductModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <PharmacyProductData>[];
      json['data'].forEach((v) {
        try {
          data!.add(new PharmacyProductData.fromJson(v));
        } catch (e) {
          print('Error parsing product: $e');
          print('Product data: $v');
          // Continue with next product instead of failing completely
        }
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

class PharmacyProductData {
  dynamic productId; // Changed to dynamic to handle both String (_id from MongoDB) and int (legacy)
  String? name;
  String? shortDescription;
  int? categoryId;
  String? category; // Added to store category string from API (e.g., "SYRUP")
  String? price;
  String? discount;
  dynamic pharmacyId; // Changed to dynamic to handle both String (MongoDB) and int (legacy)
  int? cartQuantity;
  int? quantity;
  String? dosage;
  String? image;

  PharmacyProductData(
      {this.productId,
      this.name,
      this.shortDescription,
      this.categoryId,
      this.category,
      this.price,
      this.discount,
      this.pharmacyId,
      this.quantity,
      this.cartQuantity = 1,
      this.dosage,
      this.image});

  PharmacyProductData.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'product_id' (legacy) fields
    // MongoDB uses _id as string, so we'll store it as string
    if (json['_id'] != null) {
      productId = json['_id'].toString(); // Store as string for MongoDB IDs
    } else if (json['product_id'] != null) {
      productId = json['product_id']; // Can be int or string
    } else {
      productId = null;
    }
    
    name = json['name']?.toString();
    shortDescription = json['short_description']?.toString();
    
    // Handle category - API sends category as string (e.g., "SYRUP") or category_id as MongoDB ID
    category = json['category']?.toString();
    
    // Handle category_id - can be MongoDB ID string or int
    if (json['category_id'] != null) {
      // If category_id is a MongoDB ID string, we can't use it as int
      // So we'll just store it but not use it for categoryId mapping
      final catIdValue = json['category_id'];
      if (catIdValue is int) {
        categoryId = catIdValue;
      } else if (catIdValue is String) {
        // MongoDB ID string - can't convert to int, so we'll map based on category if available
        categoryId = null;
      }
    }
    
    // Map category string to categoryId for MedicineCard compatibility
    // Default categoryId based on category string
    if (category != null) {
      final catLower = category!.toLowerCase();
      if (catLower.contains('syrup') || catLower.contains('liquid')) {
        categoryId = 3; // syrupe in category array
      } else if (catLower.contains('tablet') || catLower.contains('pill')) {
        categoryId = 1; // pills in category array
      } else if (catLower.contains('capsule')) {
        categoryId = 2; // round_pills in category array (approximation)
      } else {
        categoryId = 1; // default to pills
      }
    } else if (categoryId == null) {
      categoryId = 1; // Default to 1 (pills) if no category info
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
      // MongoDB uses string IDs, so store as string
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
      quantity = 0;
    }
    
    cartQuantity = 1;
    dosage = json['dosage']?.toString();
    image = json['image']?.toString() ?? '';
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
    data['dosage'] = this.dosage;
    return data;
  }
}
