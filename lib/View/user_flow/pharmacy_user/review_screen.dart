import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/view/home/navbar.dart';
import 'package:sizer/sizer.dart';

import '../../../styles/custom_textstyle.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: 7.h),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SvgPicture.asset(
                    'Assets/images/applogo.svg',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Your Order Has been Delivered",
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'How was your experience ?',
                  icon: '',
                ),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Star Rating",
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.borderColor),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: RatingBar.builder(
                    itemSize: 25,
                    initialRating: 6,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: "Submit",
                          onPressed: () {
                            Get.offAll(NavBarScreen(
                              isUser: true,
                            ));
                          },
                          backgroundColor: AppColors.darkGreenColor,
                          textColor: AppColors.whiteColor),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
