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
        data!.add(new PharmacyProductData.fromJson(v));
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
  int? productId;
  String? name;
  String? shortDescription;
  int? categoryId;
  int? subCategoryId;
  String? price;
  String? discount;
  int? pharmacyId;
  int? quantity;

  PharmacyProductData(
      {this.productId,
      this.name,
      this.shortDescription,
      this.categoryId,
      this.subCategoryId,
      this.price,
      this.discount,
      this.pharmacyId,
      this.quantity});

  PharmacyProductData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    shortDescription = json['short_description'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    price = json['price'];
    discount = json['discount'];
    pharmacyId = json['pharmacy_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['pharmacy_id'] = this.pharmacyId;
    data['quantity'] = this.quantity;
    return data;
  }
}
