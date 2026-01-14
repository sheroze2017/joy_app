import 'package:flutter/material.dart';
import 'package:joy_app/modules/blood_bank/view/component/donors_card.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class ContactDonorSheet extends StatelessWidget {
  final String phone;
  final String email;

  const ContactDonorSheet({
    Key? key,
    required this.phone,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff1F1F1F)
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Title
            Text(
              'Contact Donor',
              style: CustomTextStyles.darkHeadingTextStyle(size: 20),
            ),
            SizedBox(height: 3.h),
            // Phone number section
            if (phone.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: AppColors.redColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          phone,
                          style: CustomTextStyles.lightTextStyle(size: 16),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.phone_outlined,
                      color: AppColors.redColor,
                    ),
                    onPressed: () {
                      makingPhoneCall(phone);
                    },
                  ),
                ],
              ),
              SizedBox(height: 3.h),
            ],
            // Email section
            if (email.isNotEmpty) ...[
              Row(
                children: [
                  Icon(
                    Icons.email,
                    color: AppColors.redColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          email,
                          style: CustomTextStyles.lightTextStyle(size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
            if (phone.isEmpty && email.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Center(
                  child: Text(
                    'No contact information available',
                    style: CustomTextStyles.lightTextStyle(size: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
