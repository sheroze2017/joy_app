import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/pharmacy_product_model.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/checkout/checkout_detail.dart';
import 'package:joy_app/view/user_flow/pharmacy_user/medicine_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

final pharmacyController = Get.find<AllPharmacyController>();

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'My Cart',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            // height: 6.w,
            // width: .w,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'Assets/icons/cart.svg',
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.lightGreenColoreb1
                        : null,
                  ),
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
                            child: Obx(
                          () => Text(
                            pharmacyController.cartItems.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 6),
                          ),
                        )),
                      ))
                ],
              ),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            children: [
              Divider(
                color: Color(0xffE5E7EB),
                thickness: 0.5,
              ),
              SizedBox(height: 2.h),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pharmacyController.cartItems.length,
                  itemBuilder: ((context, index) {
                    PharmacyProductData data =
                        pharmacyController.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.lightGreenColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                      width: 12.5.w,
                                      height: 12.5.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name.toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(),
                                        ),
                                        Text(
                                          '${data.quantity} Tablets for ${data.price}\$',
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 14,
                                              color: Color(0xff4B5563)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Divider(
                                color: AppColors.lightGreyColor,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RoundedButtonSmall(
                                        isBold: true,
                                        isSmall: true,
                                        text:
                                            "Total ${double.parse(data.price.toString()) * data.cartQuantity!.toInt()}\$",
                                        onPressed: () {},
                                        backgroundColor:
                                            ThemeUtil.isDarkMode(context)
                                                ? Color(0xff1F2228)
                                                : AppColors.lightGreyColor,
                                        textColor: ThemeUtil.isDarkMode(context)
                                            ? AppColors.lightGreenColoreb1
                                            : AppColors.darkGreenColor),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 16),
                                        child: InkWell(
                                          onTap: () {
                                            pharmacyController
                                                .removeFromCart(data);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff1F2228)
                                                    : AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: SvgPicture.asset(
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? AppColors.whiteColor
                                                        : null,
                                                    'Assets/icons/minus.svg')),
                                          ),
                                        ),
                                      ),
                                      Text(data.cartQuantity.toString(),
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 16,
                                                  color: Color(0xff000000))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 16),
                                        child: InkWell(
                                          onTap: () {
                                            pharmacyController.addToCart(
                                                data, context);
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff1F2228)
                                                    : AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                Center(child: Icon(Icons.add)),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          pharmacyController
                                              .removeproductCart(data);
                                        },
                                        child: SvgPicture.asset(
                                            'Assets/icons/trash-2.svg'),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))),
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pharmacyController.cartItems.length,
                  itemBuilder: ((context, index) {
                    PharmacyProductData data =
                        pharmacyController.cartItems[index];
                    return NameCharges(
                      medName: data.name.toString(),
                      charges: (double.parse(data.price.toString()) *
                              double.parse(data.cartQuantity.toString()))
                          .toString(),
                    );
                  }))),
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    NameCharges(
                      medName: 'Delivery Charges',
                      charges: '2\$',
                    ),
                    Obx(
                      () => NameCharges(
                        medName: 'Grand Total',
                        charges: (pharmacyController.calculateGrandTotal() + 2)
                                .toString() +
                            '\$',
                        isTotal: true,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                            isBold: true,
                            isSmall: true,
                            text: 'Proceed to Check Out',
                            onPressed: () {
                              Get.to(CheckoutForm());
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.lightGreenColoreb1
                                : AppColors.darkGreenColor,
                            textColor: ThemeUtil.isDarkMode(context)
                                ? Color(0xff1F2228)
                                : Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NameCharges extends StatelessWidget {
  final String medName;
  final String charges;
  bool isTotal;

  NameCharges(
      {super.key,
      required this.medName,
      required this.charges,
      this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              medName,
              style: isTotal
                  ? CustomTextStyles.darkHeadingTextStyle(
                      size: 18, color: AppColors.lightBlack393)
                  : CustomTextStyles.lightSmallTextStyle(
                      size: 18, color: AppColors.lightBlack393),
            ),
            Spacer(),
            Text(
              charges,
              style: isTotal
                  ? CustomTextStyles.darkHeadingTextStyle(
                      size: 18, color: AppColors.lightBlack393)
                  : CustomTextStyles.lightSmallTextStyle(
                      size: 18, color: AppColors.lightBlack393),
            ),
          ],
        ),
        !isTotal
            ? Divider(
                color: Color(0xffE5E7EB),
                thickness: ThemeUtil.isDarkMode(context) ? 0.2 : 1,
              )
            : Container()
      ],
    );
  }
}
