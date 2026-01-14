import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/textfield/single_select_dropdown.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:sizer/sizer.dart';

class EditProductSheet extends StatefulWidget {
  final PharmacyProductData product;

  const EditProductSheet({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final productsController = Get.find<ProductController>();
  final pharmacyController = Get.find<AllPharmacyController>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _dosageController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _categoryController;
  
  List<String> categoryOptions = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current product values
    _nameController = TextEditingController(text: widget.product.name ?? '');
    _descController = TextEditingController(text: widget.product.shortDescription ?? '');
    _dosageController = TextEditingController(text: widget.product.dosage ?? '');
    _stockController = TextEditingController(text: widget.product.quantity?.toString() ?? '0');
    _priceController = TextEditingController(text: widget.product.price ?? '0');
    _discountController = TextEditingController(text: widget.product.discount ?? '0');
    
    // Load categories from API
    _loadCategories();
    
    // Set category from product (will be set after categories load)
    selectedCategory = widget.product.category;
    _categoryController = TextEditingController(text: selectedCategory ?? '');
  }

  Future<void> _loadCategories() async {
    try {
      // Fetch categories from API
      await productsController.allCategory();
      
      // Update category options list
      setState(() {
        categoryOptions = productsController.categoriesList
            .map((category) => category.name ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
        
        // If product has a category, try to match it with the loaded categories
        if (widget.product.category != null && categoryOptions.isNotEmpty) {
          // Try to find exact match (case-insensitive)
          final matchedCategory = categoryOptions.firstWhere(
            (cat) => cat.toLowerCase() == widget.product.category!.toLowerCase(),
            orElse: () => categoryOptions.first,
          );
          selectedCategory = matchedCategory;
          _categoryController.text = matchedCategory;
        } else if (categoryOptions.isNotEmpty) {
          // Default to first category if no match found
          selectedCategory = categoryOptions.first;
          _categoryController.text = categoryOptions.first;
        }
      });
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback to default categories if API fails
      setState(() {
        categoryOptions = ['PILL', 'SYRUP', 'TABLET', 'CAPSULE', 'INJECTION'];
        selectedCategory = widget.product.category ?? categoryOptions.first;
        _categoryController.text = selectedCategory ?? categoryOptions.first;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _dosageController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    try {
      // Get current user for pharmacy_id
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        Get.snackbar('Error', 'User not found');
        return;
      }

      // Validate category is selected
      if (selectedCategory == null || selectedCategory!.isEmpty) {
        Get.snackbar('Error', 'Please select a category');
        return;
      }

      // Call the edit API with the correct format
      final response = await productsController.editProductWithCategory(
        _nameController.text.trim(),
        _descController.text.trim(),
        selectedCategory!, // Use selected category name
        _priceController.text.trim(),
        _discountController.text.trim(),
        currentUser.userId.toString(),
        _stockController.text.trim(),
        _dosageController.text.trim(),
        widget.product.productId?.toString() ?? '',
        context,
      );

      if (response != null) {
        // Close the sheet first before showing snackbar
        Get.back(); // Close the sheet
        // Wait a bit for the sheet to close
        await Future.delayed(Duration(milliseconds: 300));
        // Refresh products list
        await pharmacyController.getPharmacyProduct(true, currentUser.userId.toString());
        // Show success message after sheet is closed
        Get.snackbar('Success', 'Product updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff1F2937)
            : AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 40.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                  color: ThemeUtil.isDarkMode(context)
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ],
            ),
          ),
          Divider(),
          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _nameController,
                      hintText: 'Product Name',
                      icon: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _descController,
                      hintText: 'Short Description',
                      icon: '',
                      maxlines: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    categoryOptions.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 2.w,
                                  height: 2.w,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Loading categories...',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : SearchSingleDropdown(
                            hintText: 'Select Category',
                            items: categoryOptions,
                            value: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value;
                                _categoryController.text = value ?? (categoryOptions.isNotEmpty ? categoryOptions.first : '');
                              });
                            },
                            icon: '',
                          ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _priceController,
                      hintText: 'Price',
                      icon: '',
                      textInputType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _discountController,
                      hintText: 'Discount',
                      icon: '',
                      textInputType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter discount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid discount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _stockController,
                      hintText: 'Quantity (Stock)',
                      icon: '',
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),
                    RoundedBorderTextField(
                      controller: _dosageController,
                      hintText: 'Dosage',
                      icon: '',
                      maxlines: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter dosage';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => RoundedButton(
                        showLoader: productsController.createProLoader.value,
                        text: 'Save Changes',
                        onPressed: _handleSave,
                        backgroundColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.lightGreenColoreb1
                            : AppColors.darkGreenColor,
                        textColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
