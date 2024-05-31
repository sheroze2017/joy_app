import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

int count = 0;

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
                  SvgPicture.asset('Assets/icons/cart.svg'),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 1.3.h,
                        width: 1.3.h,
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
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.lightGreenColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                          'Panadol',
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(),
                                        ),
                                        Text(
                                          '${count} Tablets for 5\$',
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
                                        text: "Total 25\$",
                                        onPressed: () {},
                                        backgroundColor:
                                            AppColors.lightGreyColor,
                                        textColor: AppColors.darkGreenColor),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 16),
                                        child: InkWell(
                                          onTap: () {
                                            count--;
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: SvgPicture.asset(
                                                    'Assets/icons/minus.svg')),
                                          ),
                                        ),
                                      ),
                                      Text(count.toString(),
                                          style:
                                              CustomTextStyles.lightTextStyle(
                                                  size: 16,
                                                  color: Color(0xff000000))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 16),
                                        child: InkWell(
                                          onTap: () {
                                            count = count + 1;
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 7.6.w,
                                            height: 7.6.w,
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                border: Border.all(
                                                    color: Color(0xffBABABA)),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                Center(child: Icon(Icons.add)),
                                          ),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                          'Assets/icons/trash-2.svg')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      NameCharges(
                        medName: 'Panadol',
                        charges: '25\$',
                      ),
                      NameCharges(
                        medName: 'Delivery Charges',
                        charges: '2\$',
                      ),
                      NameCharges(
                        medName: 'Grand Total',
                        charges: '27\$',
                        isTotal: true,
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
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     return CustomDialog();
                                  //   },
                                  // );
                                },
                                backgroundColor: AppColors.darkGreenColor,
                                textColor: Color(0xffFFFFFF)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
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
              )
            : Container()
      ],
    );
  }
}
