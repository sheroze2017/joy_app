import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';
import 'contact_donor_sheet.dart';

class DonorDetailSheet extends StatelessWidget {
  final BloodDonor donor;

  const DonorDetailSheet({Key? key, required this.donor}) : super(key: key);

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
            // Donor profile section
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (donor.image != null &&
                          donor.image!.isNotEmpty &&
                          donor.image!.contains('http') &&
                          !donor.image!.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                      ? Image.network(
                          donor.image!,
                          width: 23.74.w,
                          height: 23.74.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 23.74.w,
                              height: 23.74.w,
                              decoration: BoxDecoration(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff2A2A2A)
                                    : Color(0xffE5E5E5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 15.w,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff5A5A5A)
                                    : Color(0xffA5A5A5),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 23.74.w,
                          height: 23.74.w,
                          decoration: BoxDecoration(
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff2A2A2A)
                                : Color(0xffE5E5E5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 15.w,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff5A5A5A)
                                : Color(0xffA5A5A5),
                          ),
                        ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donor.name ?? 'Unknown',
                        style: CustomTextStyles.lightSmallTextStyle(
                            size: 24,
                            color: ThemeUtil.isDarkMode(context)
                                ? Colors.white
                                : Color(0xff1F2A37)),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'Assets/icons/donationcount.svg',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 0.5.w),
                          Text(
                            '${donor.totalDonations ?? 0}',
                            style: CustomTextStyles.lightSmallTextStyle(
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 0.5.w),
                          Text(
                            'Donations',
                            style: CustomTextStyles.lightSmallTextStyle(
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 3.h),
            // About section
            if (donor.about != null && donor.about!.isNotEmpty) ...[
              Text(
                'About',
                style: CustomTextStyles.darkHeadingTextStyle(size: 14),
              ),
              SizedBox(height: 0.5.h),
              Text(
                donor.about!,
                style: CustomTextStyles.lightTextStyle(size: 12),
              ),
              SizedBox(height: 3.h),
            ],
            // Blood Group
            Text(
              'Blood Group',
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            SizedBox(height: 0.5.h),
            Text(
              donor.bloodGroup ?? 'N/A',
              style: CustomTextStyles.lightTextStyle(size: 14.91),
            ),
            SizedBox(height: 3.h),
            // Age
            if (donor.age != null) ...[
              Text(
                'Age',
                style: CustomTextStyles.darkHeadingTextStyle(size: 14),
              ),
              SizedBox(height: 0.5.h),
              Text(
                donor.age.toString(),
                style: CustomTextStyles.lightTextStyle(size: 14.91),
              ),
              SizedBox(height: 3.h),
            ],
            // Location
            Text(
              'Location',
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '${donor.location ?? ''}${donor.city != null && donor.city!.isNotEmpty ? ', ${donor.city}' : ''}',
              style: CustomTextStyles.lightTextStyle(size: 14.91),
            ),
            SizedBox(height: 3.h),
            // Contact Donor button
            RoundedButton(
              text: 'Contact donor',
              onPressed: () {
                Navigator.pop(context); // Close this sheet
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ContactDonorSheet(
                    phone: donor.phone ?? '',
                    email: donor.email ?? '',
                  ),
                );
              },
              backgroundColor: AppColors.redColor,
              textColor: Color(0xffFFFFFF),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
