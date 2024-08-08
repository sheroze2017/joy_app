import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/auth/utils/auth_utils.dart';
import 'package:joy_app/common/utils/file_selector.dart';
import 'package:joy_app/widgets/textfield/single_select_dropdown.dart';
import 'package:pinput/pinput.dart';

import 'package:sizer/sizer.dart';

class AddMedicine extends StatefulWidget {
  bool isEdit;
  PharmacyProductData? productDetail;
  AddMedicine({this.productDetail, this.isEdit = false});
  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  String? selectedValue;
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final TextEditingController _descController = TextEditingController();
  List<String> category = [];

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final mediaController = Get.find<MediaPostController>();
  String? _selectedImage;

  Future<void> _pickImage() async {
    final List<String?> paths = await pickSingleFile();
    if (paths.isNotEmpty) {
      final String path = await paths.first!;
      String profileImg =
          await mediaController.uploadProfilePhoto(path, context);
      setState(() {
        _selectedImage = profileImg;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final productsController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    productsController.categoriesList.forEach((element) {
      category!.add(element.name!);
    });
    if (widget.isEdit == true) {
      final data = widget.productDetail!;
      _nameController.setText(data.name!);
      _descController.setText(data.shortDescription!);
      _dosageController.setText(data.dosage.toString());
      _stockController.setText(data.quantity.toString());
      _priceController.setText(data.price!);
      _categoryController.setText(
          category[data.productId!.toInt() > 3 ? 1 : data.productId!.toInt()]);
      _selectedImage = data.image.toString();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Product' : 'Add Product',
        icon: Icons.arrow_back_sharp,
        onPressed: () {
          Get.back();
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: _selectedImage == null ||
                                  !_selectedImage!.contains('http')
                              ? Center(
                                  child: SvgPicture.asset(
                                      'Assets/images/profile-circle.svg'),
                                )
                              : Center(
                                  child: Container(
                                    width: 43.w,
                                    height: 43.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Add this line
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 1), // Optional
                                    ),
                                    child: Center(
                                      child: Container(
                                        child: ClipOval(
                                          // Add this widget
                                          child: Image.network(
                                            fit: BoxFit.cover,
                                            _selectedImage!,
                                            width: 43.w,
                                            height: 43.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      Positioned(
                        bottom: 20,
                        right: 100,
                        child: Container(
                            decoration: BoxDecoration(
                                color: ThemeUtil.isDarkMode(context)
                                    ? AppColors.lightGreenColoreb1
                                    : AppColors.darkGreenColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'Assets/icons/pen.svg',
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      } else {
                        return null;
                      }
                    },
                    controller: _nameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'Product Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    maxlines: true,
                    controller: _descController,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hintText: 'Description',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SearchSingleDropdown(
                    hintText: 'Select Category',
                    items: category,
                    value: widget.isEdit ? _categoryController.text : null,
                    onChanged: (String? value) {
                      _categoryController.setText(value.toString());
                    },
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _dosageController,
                    focusNode: _focusNode4,
                    nextFocusNode: _focusNode5,
                    hintText: 'Dosage',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dosage';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _stockController,
                    focusNode: _focusNode5,
                    nextFocusNode: _focusNode6,
                    hintText: 'Stock',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter stock';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      controller: _priceController,
                      focusNode: _focusNode6,
                      nextFocusNode: _focusNode7,
                      hintText: 'Price',
                      icon: '',
                      validator: validateCurrencyAmount),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Obx(
                        () => RoundedButton(
                            showLoader:
                                productsController.createProLoader.value,
                            text: 'Save',
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              if (!_formKey.currentState!.validate()) {
                              } else {
                                if (widget.isEdit) {
                                  productsController.editProduct(
                                      _nameController.text.toString(),
                                      _descController.text.toString(),
                                      (category.indexOf(_categoryController
                                                      .text) +
                                                  1)
                                              .toString() ??
                                          '0',
                                      _priceController.text.toString(),
                                      '0',
                                      '',
                                      _stockController.text.toString(),
                                      _dosageController.text.toString(),
                                      widget.productDetail!.productId
                                          .toString(),
                                      context);
                                } else {
                                  productsController.createProduct(
                                      _nameController.text.toString(),
                                      _descController.text.toString(),
                                      (category.indexOf(_categoryController
                                                      .text) +
                                                  1)
                                              .toString() ??
                                          '0',
                                      _priceController.text.toString(),
                                      '0',
                                      '',
                                      _stockController.text.toString(),
                                      _dosageController.text.toString(),
                                      _selectedImage.toString().contains('http')
                                          ? _selectedImage.toString()
                                          : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                      context);
                                }
                              }
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return CustomDialog(
                              //       showButton: true,
                              //       title: 'Congratulations!',
                              //       content:
                              //           'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                              //     );
                              //   },
                              // );
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.lightGreenColoreb1
                                : AppColors.darkGreenColor,
                            textColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : AppColors.whiteColor),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
