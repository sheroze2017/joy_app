import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/modules/pharmacy/view/checkout/mycart_screen.dart';
import 'package:joy_app/modules/pharmacy/view/medicine_detail_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../social_media/friend_request/view/new_friend.dart';
import '../../../user_hospital/view/hospital_detail_screen.dart';
import 'add_medicine.dart';
import 'edit_product_sheet.dart';
import 'package:joy_app/widgets/loader/loader.dart';

class ProductScreen extends StatefulWidget {
  final String userId;
  final bool isAdmin;
  final bool isHospital;
  ProductScreen({required this.userId, required this.isAdmin, this.isHospital = false});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    // Defer API call until after the first frame to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear previous products and load new ones
      pharmacyController.pharmacyProducts.clear();
      pharmacyController.searchPharmacyProducts.clear();
      pharmacyController.getPharmacyProduct(true, widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Products',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            color: ThemeUtil.isDarkMode(context) ? AppColors.whiteColor : null,
            // height: 6.w,
            // width: .w,
          ),
          actions: [
            // Show cart icon in user mode, + icon in admin mode
            if (widget.isAdmin)
              InkWell(
                onTap: () async {
                  await Get.to(AddMedicine(), transition: Transition.native);
                  // Refresh products list when returning from Add Product screen
                  pharmacyController.getPharmacyProduct(true, widget.userId);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Color(0xffBABABA))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset('Assets/icons/plus.svg'),
                      )),
                ),
              )
            else if (!widget.isHospital)
              Obx(() => InkWell(
                    onTap: () {
                      Get.to(MyCartScreen(), transition: Transition.native);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'Assets/icons/cart.svg',
                            color: ThemeUtil.isDarkMode(context)
                                ? AppColors.lightGreenColoreb1
                                : null,
                          ),
                          if (pharmacyController.cartItems.isNotEmpty)
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 1.1.h,
                                  width: 1.1.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color(0xffD65B5B)),
                                  child: Center(
                                      child: Text(
                                    pharmacyController.cartItems.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 6),
                                  )),
                                ))
                        ],
                      ),
                    ),
                  )),
          ],
          showIcon: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedSearchTextField(
                hintText: 'Search Product',
                onChanged: (value) {
                  // Defer search to avoid setState during build
                  Future.microtask(() {
                    pharmacyController.searchByProduct(value);
                  });
                },
                controller: TextEditingController()),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: Obx(
              () {
                // Use pharmacyProducts directly, and sync searchPharmacyProducts if empty
                final allProducts = pharmacyController.pharmacyProducts;
                final searchProducts = pharmacyController.searchPharmacyProducts;
                
                // Use searchProducts if available and not empty, otherwise use allProducts
                final productsToShow = (searchProducts.isNotEmpty) 
                    ? searchProducts 
                    : allProducts;
                
                return pharmacyController.allProductLoader.value
                    ? Center(child: CircularProgressIndicator())
                    : productsToShow.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No products found',
                                  style: CustomTextStyles.darkHeadingTextStyle(),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Products loaded: ${allProducts.length}',
                                  style: CustomTextStyles.lightTextStyle(),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: widget.isAdmin ? 0.70 : 0.75, // Slightly more space for quantity controls
                            ),
                            itemCount: productsToShow.length,
                            itemBuilder: (context, index) {
                              final data = productsToShow[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: widget.isAdmin
                                  ? InkWell(
                                      onTap: () {
                                        // Navigate to product details screen
                                        Get.to(
                                          MedicineDetailScreen(
                                            product: data,
                                            isPharmacyAdmin: true,
                                            productId: data.productId?.toString() ?? '',
                                          ),
                                          transition: Transition.native,
                                        );
                                      },
                                      child: MedicineCard(
                                        isFromHospital: false,
                                        categoryId: data.categoryId ?? 1,
                                        isUserProductScreen: true,
                                        onPressed: () async {
                                          // Open bottom sheet for editing
                                          await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => EditProductSheet(product: data),
                                          );
                                          // Refresh products list when bottom sheet closes
                                          pharmacyController.getPharmacyProduct(true, widget.userId);
                                        },
                                        btnText: "Edit",
                                        imgUrl: data.image ?? '',
                                        count: data.quantity?.toString() ?? '0',
                                        cost: data.price ?? '0',
                                        name: data.name ?? '',
                                      ),
                                    )
                                  : _UserProductCard(
                                      product: data,
                                      pharmacyController: pharmacyController,
                                      isHospital: widget.isHospital,
                                    ),
                            );
                            });
              },
            ))
          ],
        ),
      ),
    );
  }
}

// Custom product card for user mode with quantity controls
class _UserProductCard extends StatefulWidget {
  final PharmacyProductData product;
  final AllPharmacyController pharmacyController;
  final bool isHospital;

  const _UserProductCard({
    required this.product,
    required this.pharmacyController,
    this.isHospital = false,
  });

  @override
  State<_UserProductCard> createState() => _UserProductCardState();
}

class _UserProductCardState extends State<_UserProductCard> {
  int getQuantity() {
    return widget.pharmacyController.getQuantityOfProduct(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final category = ['pills', 'syrupe', 'round_pills', 'capsule', 'injection'];
    final categoryId = widget.product.categoryId ?? 1;

    return InkWell(
      onTap: () {
        // Navigate to product details screen
        Get.to(
          MedicineDetailScreen(
            product: widget.product,
            isPharmacyAdmin: false,
            isHospital: widget.isHospital,
            productId: widget.product.productId?.toString() ?? '',
          ),
          transition: Transition.native,
        );
      },
      child: Container(
        width: 43.w,
        decoration: BoxDecoration(
            color: Color(0xffE2FFE3), borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: _buildProductImage(widget.product.image ?? ''),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name ?? '',
                              style: CustomTextStyles.darkHeadingTextStyle(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${widget.product.quantity ?? 0} ${category[categoryId - 1]} for ${widget.product.price ?? '0'}\Rs',
                              style: CustomTextStyles.w600TextStyle(
                                  size: 13, color: Color(0xff4B5563)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  Divider(
                    color: Color(0xff6B7280),
                    thickness: 0.05.h,
                  ),
                ],
              ),
            // Quantity controls and Add to Cart button - Always show for users
            Obx(() {
              final cartQuantity = getQuantity();
              return cartQuantity > 0
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {}, // Stop event propagation to parent InkWell
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              // Remove from cart (will handle not going below 0)
                              widget.pharmacyController.removeFromCart(widget.product);
                            },
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ),
                          ),
                          Text(
                            cartQuantity.toString(),
                            style: CustomTextStyles.darkHeadingTextStyle(
                                size: 16),
                          ),
                          InkWell(
                            onTap: () {
                              // Add to cart (validation is handled in the bloc method)
                              widget.pharmacyController.addToCart(
                                  widget.product, context);
                            },
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 4.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {}, // Stop event propagation to parent InkWell
                      child: RoundedButtonSmall(
                        isSmall: true,
                        text: "Add to Cart",
                        onPressed: () {
                          widget.pharmacyController.addToCart(
                              widget.product, context);
                        },
                        backgroundColor: ThemeUtil.isDarkMode(context)
                            ? Color(0xff1DAA61)
                            : AppColors.darkGreenColor,
                        textColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.blackColor
                            : AppColors.whiteColor),
                    );
            }),
          ],
        ),
      ),
      ),
    );
  }

  // Helper method to build product image with proper error handling
  Widget _buildProductImage(String imageUrl) {
    // Check if image URL is valid
    final isValidUrl = imageUrl.isNotEmpty &&
        imageUrl.contains('http') &&
        !imageUrl.contains('example.com') &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (!isValidUrl) {
      // Show default medicine icon
      return Container(
        width: 12.5.w,
        height: 12.5.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(
          Icons.medical_services_outlined,
          size: 6.w,
          color: Colors.grey[600],
        ),
      );
    }

    // Use CachedNetworkImage for valid URLs
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 12.5.w,
      height: 12.5.w,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 12.5.w,
        height: 12.5.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: LoadingWidget(),
        ),
      ),
      errorWidget: (context, url, error) {
        // Always show default medicine icon on error
        return Container(
          width: 12.5.w,
          height: 12.5.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            size: 6.w,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }
}
