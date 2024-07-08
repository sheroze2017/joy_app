class editProduct {
  int? code;
  bool? sucess;
  Data? data;
  String? message;

  editProduct({this.code, this.sucess, this.data, this.message});

  editProduct.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  String? name;
  String? shortDescription;
  int? categoryId;
  String? price;
  String? discount;
  int? pharmacyId;
  int? quantity;
  String? dosage;

  Data(
      {this.productId,
      this.name,
      this.shortDescription,
      this.categoryId,
      this.price,
      this.discount,
      this.pharmacyId,
      this.quantity,
      this.dosage});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    shortDescription = json['short_description'];
    categoryId = json['category_id'];
    price = json['price'];
    discount = json['discount'];
    pharmacyId = json['pharmacy_id'];
    quantity = json['quantity'];
    dosage = json['dosage'];
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
