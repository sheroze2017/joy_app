import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class MedicineDetailScreen extends StatefulWidget {
  const MedicineDetailScreen({super.key});

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

int count = 0;

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: 'Product Details',
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
                            style: TextStyle(color: Colors.white, fontSize: 6),
                          ),
                        ),
                      ))
                ],
              ),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Color(0xffE5E7EB),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Panadol',
                                style: CustomTextStyles.lightSmallTextStyle(
                                    size: 16, color: AppColors.lightBlack393),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "10 Tablets for 5\$",
                                style: CustomTextStyles.w600TextStyle(
                                    size: 16, color: AppColors.lightBlack393),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  count--;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 7.6.w,
                                  height: 7.6.w,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffBABABA)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: SvgPicture.asset(
                                          'Assets/icons/minus.svg')),
                                ),
                              ),
                            ),
                            Text(count.toString(),
                                style: CustomTextStyles.lightTextStyle(
                                    size: 16, color: Color(0xff000000))),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () {
                                  count = count + 1;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 7.6.w,
                                  height: 7.6.w,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffBABABA)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: Icon(Icons.add)),
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
                          color: AppColors.lightBlack393),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit. viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla e',
                      style: CustomTextStyles.lightTextStyle(
                          color: AppColors.lightBlack393, size: 12),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RoundedButtonSmall(
                              text: "Add to Cart",
                              onPressed: () {},
                              backgroundColor: AppColors.lightGreyColor,
                              textColor: AppColors.darkGreenColor),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Expanded(
                          child: RoundedButtonSmall(
                              text: "Buy Now",
                              onPressed: () {},
                              backgroundColor: AppColors.darkGreenColor,
                              textColor: AppColors.whiteColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
