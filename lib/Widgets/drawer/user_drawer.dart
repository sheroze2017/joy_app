import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/view/manage_booking.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/user_all_order.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController _profileController = Get.put(ProfileController());

    return Drawer(
      backgroundColor: AppColors.darkBlueColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: <Widget>[
              Obx(() => Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: (_profileController.image.value.isNotEmpty &&
                                _profileController.image.value.contains('http') &&
                                !_profileController.image.value
                                    .contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                            ? Image.network(
                                _profileController.image.value,
                                width: 12.8.w,
                                height: 12.8.w,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 12.8.w,
                                    height: 12.8.w,
                                    color: Color(0xff2A2A2A),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 12.8.w,
                                    height: 12.8.w,
                                    color: Color(0xff2A2A2A),
                                    child: Icon(
                                      Icons.person,
                                      size: 6.w,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 12.8.w,
                                height: 12.8.w,
                                color: Color(0xff2A2A2A),
                                child: Icon(
                                  Icons.person,
                                  size: 6.w,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _profileController.firstName.value.isNotEmpty
                                  ? _profileController.firstName.value
                                  : 'User',
                              style: CustomTextStyles.w600TextStyle(
                                size: 15.59,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _profileController.email.value.isNotEmpty
                                  ? _profileController.email.value
                                  : '',
                              style: CustomTextStyles.lightSmallTextStyle(
                                color: Color(0xffC8D3E0),
                                size: 12.47,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 5.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    UserAllOrderScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: DrawerItem(
                  isBloodBank: false,
                  isBooking: true,
                  bookingText: 'My Orders',
                  bookingAsset: 'Assets/icons/pharmacy.svg',
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    ManageAllAppointmentUser(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: DrawerItem(
                  isBloodBank: false,
                  isBooking: true,
                  bookingText: 'My Bookings',
                  bookingAsset: 'Assets/icons/calendar.svg',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final bool isBooking;
  final String bookingText;
  final String bookingAsset;
  final isBloodBank;
  const DrawerItem({
    required this.isBooking,
    required this.bookingText,
    required this.bookingAsset,
    required this.isBloodBank,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(62),
        color: isBooking
            ? Colors.white
            : isBloodBank
                ? AppColors.redColor
                : AppColors.darkBlueColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: SvgPicture.asset(
                bookingAsset,
              ),
              height: 6.w,
              width: 6.w,
            ),
            SizedBox(width: 3.w),
            Flexible(
              child: Text(
                bookingText,
                style: CustomTextStyles.w600TextStyle(
                    size: 16,
                    color: isBooking ? Color(0xff1F1F29) : Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
