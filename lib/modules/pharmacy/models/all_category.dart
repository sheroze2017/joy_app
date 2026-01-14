class AllCategory {
  int? code;
  bool? sucess;
  List<Category>? data;
  String? message;

  AllCategory({this.code, this.sucess, this.data, this.message});

  AllCategory.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sucess = json['sucess'];
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(new Category.fromJson(v));
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

class Category {
  dynamic categoryId; // Changed to dynamic to handle both _id (MongoDB) and category_id (legacy)
  String? name;
  dynamic createdAt;
  String? status;
  int? parentCategoryId;

  Category(
      {this.categoryId,
      this.name,
      this.createdAt,
      this.status,
      this.parentCategoryId});

  Category.fromJson(Map<String, dynamic> json) {
    // Handle both '_id' (MongoDB) and 'category_id' (legacy) fields
    if (json['_id'] != null) {
      categoryId = json['_id'].toString(); // Store as string for MongoDB IDs
    } else {
      categoryId = json['category_id'];
    }
    name = json['name']?.toString();
    createdAt = json['created_at'];
    status = json['status']?.toString();
    parentCategoryId = json['parent_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['parent_category_id'] = this.parentCategoryId;
    return data;
  }
}
