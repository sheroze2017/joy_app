import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/add_medicine.dart';
import 'package:joy_app/modules/pharmacy/view/checkout/mycart_screen.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class MedicineDetailScreen extends StatefulWidget {
  final bool isPharmacyAdmin;
  PharmacyProductData product;
  final String productId;
  MedicineDetailScreen(
      {required this.isPharmacyAdmin,
      required this.productId,
      required this.product});
  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

int count = 0;

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    pharmacyController.getPharmacyProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Product Details',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            // height: 6.w,
            // width: .w,
            color: ThemeUtil.isDarkMode(context) ? Color(0xffE8E8E8) : null,
          ),
          actions: widget.isPharmacyAdmin
              ? []
              : [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Stack(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.to(MyCartScreen(),
                                  transition: Transition.native);
                            },
                            child: SvgPicture.asset('Assets/icons/cart.svg')),
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
                  )
                ],
          showIcon: true),
      body: SingleChildScrollView(
          child: Obx(
        () => pharmacyController.productDetailLoader.value
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.grey,
              ))
            : pharmacyController.productDetail.isEmpty
                ? Center(
                    child: Text(
                      'No Details Found',
                      style: CustomTextStyles.lightTextStyle(),
                    ),
                  )
                : Column(
                    children: [
                      Divider(
                        color: Color(0xffE5E7EB),
                        thickness: 0.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.product.image.toString(),
                                  height: 67.17.w,
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: LoadingWidget(),
                                  )),
                                  errorWidget: (context, url, error) => Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ErorWidget(),
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pharmacyController
                                                      .productDetail[0].name![0]
                                                      .toUpperCase() +
                                                  pharmacyController
                                                      .productDetail[0].name!
                                                      .substring(1) ??
                                              'Panadol',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(
                                                  size: 16,
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffE8E8E8)
                                                      : AppColors
                                                          .lightBlack393),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          "${pharmacyController.productDetail[0].quantity ?? 10} Tablets for ${pharmacyController.productDetail[0].price ?? 5}\$",
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 16,
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xffE8E8E8)
                                                      : AppColors
                                                          .lightBlack393),
                                        )
                                      ],
                                    ),
                                  ),
                                  widget.isPharmacyAdmin
                                      ? Container()
                                      : Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  pharmacyController
                                                      .removeFromCart(
                                                          widget.product);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: 7.6.w,
                                                  height: 7.6.w,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffBABABA)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                          'Assets/icons/minus.svg',
                                                          color: ThemeUtil
                                                                  .isDarkMode(
                                                                      context)
                                                              ? Color(
                                                                  0xffE8E8E8)
                                                              : null)),
                                                ),
                                              ),
                                            ),
                                            Obx(() {
                                              int quantity = pharmacyController
                                                  .getQuantityOfProduct(
                                                widget.product,
                                              );

                                              return Text(quantity.toString(),
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                          size: 16,
                                                          color: ThemeUtil
                                                                  .isDarkMode(
                                                                      context)
                                                              ? Color(
                                                                  0xffE8E8E8)
                                                              : Color(
                                                                  0xff000000)));
                                            }),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  pharmacyController.addToCart(
                                                      widget.product, context);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  width: 7.6.w,
                                                  height: 7.6.w,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffBABABA)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                      child: Icon(Icons.add)),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Description of product',
                                style: CustomTextStyles.w600TextStyle(
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffE8E8E8)
                                        : AppColors.lightBlack393),
                              ),
                              SizedBox(height: 1.h),
                              ReadMoreText(
                                pharmacyController
                                        .productDetail[0].shortDescription ??
                                    ''.toString(),
                                trimMode: TrimMode.Line,
                                trimLines: 5,
                                colorClickableText: AppColors.blackColor,
                                trimCollapsedText: ' view more',
                                trimExpandedText: ' view less',
                                style:
                                    CustomTextStyles.lightTextStyle(size: 14),
                                moreStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                lessStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 1.h),
                              widget.isPharmacyAdmin
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: RoundedButtonSmall(
                                              text: "Edit Product",
                                              onPressed: () {
                                                Get.to(
                                                    AddMedicine(
                                                      isEdit: true,
                                                      productDetail:
                                                          pharmacyController
                                                              .productDetail[0],
                                                    ),
                                                    transition:
                                                        Transition.native);
                                              },
                                              backgroundColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors
                                                          .lightGreenColoreb1
                                                      : AppColors
                                                          .darkGreenColor,
                                              textColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors.blackColor
                                                      : AppColors.whiteColor),
                                        )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: RoundedButtonSmall(
                                              text: "Add to Cart",
                                              onPressed: () {
                                                pharmacyController.addToCart(
                                                    widget.product, context);
                                              },
                                              backgroundColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xff1F2228)
                                                      : AppColors
                                                          .lightGreyColor,
                                              textColor: ThemeUtil.isDarkMode(
                                                      context)
                                                  ? AppColors.lightGreenColoreb1
                                                  : AppColors.darkGreenColor),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Expanded(
                                          child: RoundedButtonSmall(
                                              text: "Buy Now",
                                              onPressed: () {
                                                pharmacyController.addToCart(
                                                    widget.product, context);
                                                Get.to(MyCartScreen(),
                                                    transition:
                                                        Transition.native);
                                              },
                                              backgroundColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors
                                                          .lightGreenColoreb1
                                                      : AppColors
                                                          .darkGreenColor,
                                              textColor:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors.blackColor
                                                      : AppColors.whiteColor),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
      )),
    );
  }
}
