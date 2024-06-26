import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/modules/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/mycart_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class MedicineDetailScreen extends StatefulWidget {
  final bool isPharmacyAdmin;
  final String productId;
  MedicineDetailScreen(
      {required this.isPharmacyAdmin, required this.productId});
  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

int count = 0;

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  final pharmacyController = Get.put(AllPharmacyController());

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
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 6),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
          showIcon: true),
      body: SingleChildScrollView(
          child: Obx(
        () => pharmacyController.productDetailLoader.value
            ? CircularProgressIndicator()
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
                                child: Image.network(
                                  height: 67.17.w,
                                  width: 100.w,
                                  'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                  fit: BoxFit.cover,
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
                                                  .productDetail[0].name ??
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
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            count--;
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: SvgPicture.asset(
                                                    'Assets/icons/minus.svg',
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? Color(0xffE8E8E8)
                                                        : null)),
                                          ),
                                        ),
                                      ),
                                      Text(count.toString(),
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 16,
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffE8E8E8)
                                                      : Color(0xff000000))),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            count = count + 1;
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                Center(child: Icon(Icons.add)),
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
                                              onPressed: () {},
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
                                              onPressed: () {},
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
                                                Get.to(MyCartScreen());
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
