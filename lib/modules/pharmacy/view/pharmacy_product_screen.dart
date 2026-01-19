import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'medicine_detail_screen.dart';
import 'checkout/mycart_screen.dart';

class PharmacyProductScreen extends StatefulWidget {
  final String userId;
  bool isHospital;
  PharmacyProductScreen({required this.userId, this.isHospital = false});

  @override
  State<PharmacyProductScreen> createState() => _PharmacyProductScreenState();
}

class _PharmacyProductScreenState extends State<PharmacyProductScreen> {
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    pharmacyController.getPharmacyProduct(true, widget.userId);
  }

  @override
  void dispose() {
    pharmacyController.searchPharmacyProducts.value =
        pharmacyController.pharmacyProducts.value;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Products',
          leading: Image(
            image: AssetImage(
              'Assets/icons/arrow-left.png',
            ),

            // height: 6.w,
            // width: .w,
          ),
          actions: [
            InkWell(
                    onTap: () {
                      Get.to(MyCartScreen(), transition: Transition.native);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Stack(
                        children: [
                          SvgPicture.asset('Assets/icons/cart.svg'),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 1.5.h,
                                width: 1.5.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xffD65B5B)),
                                child: Center(
                                    child: Obx(
                                  () => Text(
                                    pharmacyController.cartItems.length
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 6),
                                  ),
                                )),
                              ))
                        ],
                      ),
                    ),
                  )
          ],
          showIcon: true),
      body: RefreshIndicator(
        onRefresh: () async {
          pharmacyController.getPharmacyProduct(true, widget.userId);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RoundedSearchTextField(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: pharmacyController.searchByProduct,
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                  child: Obx(
                () => pharmacyController.allProductLoader.value
                    ? Center(child: CircularProgressIndicator())
                    : pharmacyController.searchPharmacyProducts.length == 0
                        ? Center(
                            child: Text(
                              "No products found",
                              style: CustomTextStyles.lightTextStyle(),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 3.0,
                              mainAxisSpacing: 3,
                              childAspectRatio: widget.isHospital
                                  ? 1
                                  : 0.75, // Set the aspect ratio of the children
                            ),
                            itemCount: pharmacyController
                                .searchPharmacyProducts.length,
                            itemBuilder: (context, index) {
                              final data = pharmacyController
                                  .searchPharmacyProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _UserProductCard(
                                  product: data,
                                  pharmacyController: pharmacyController,
                                  isHospital: widget.isHospital,
                                ),
                              );
                            }),
              ))
            ],
          ),
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
      placeholder: (context, url) => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
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
      ),
    );
  }
}
