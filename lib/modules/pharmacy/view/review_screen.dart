import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:sizer/sizer.dart';

import '../../../modules/user/user_doctor/model/all_user_appointment.dart';
import '../../../styles/custom_textstyle.dart';

class ReviewScreen extends StatefulWidget {
  Color buttonBgColor;
  UserAppointment? details;
  bool isPharmacy;
  String? pharmacyId;
  ReviewScreen(
      {required this.buttonBgColor,
      this.details,
      this.isPharmacy = false,
      this.pharmacyId});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final _userdoctorController = Get.find<UserDoctorController>();
  final _formKey = GlobalKey<FormState>();
  double starRating = 0;

  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                  Text("Your Order Has been Delivered",
                      style: CustomTextStyles.lightSmallTextStyle(
                        size: 16,
                        color: ThemeUtil.isDarkMode(context)
                            ? Color(0xffAAAAAA)
                            : Color(0xff757575),
                      )),
                  SizedBox(height: 2.h),
                  RoundedBorderTextField(
                    controller: _reviewController,
                    hintText: 'How was your experience ?',
                    icon: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your experience';
                      } else {
                        return null;
                      }
                    },
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
                      initialRating: 0,
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
                        starRating = rating;
                      },
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Obx(
                          () => RoundedButton(
                              showLoader:
                                  _userdoctorController.reviewLoader.value,
                              text: "Submit",
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) {
                                } else {
                                  if (starRating < 1) {
                                    showErrorMessage(
                                        context, 'Please give rating');
                                  } else {
                                    _userdoctorController.createReview(
                                        widget.isPharmacy
                                            ? widget.pharmacyId.toString()
                                            : widget.details!.doctorUserId
                                                .toString(),
                                        '',
                                        starRating.toString(),
                                        _reviewController.text,
                                        context);
                                  }
                                }
                              },
                              isReview: true,
                              backgroundColor: widget.buttonBgColor,
                              textColor: ThemeUtil.isDarkMode(context)
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
