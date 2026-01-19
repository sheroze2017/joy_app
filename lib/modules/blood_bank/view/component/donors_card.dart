import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/modules/social_media/chat/view/direct_chat.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorsCardWidget extends StatelessWidget {
  final String imgUrl;
  final String Category;
  final String docName;
  final String loction;
  final Color color;
  final String phoneNo;
  final dynamic donId;

  DonorsCardWidget({
    super.key,
    required this.imgUrl,
    required this.Category,
    required this.docName,
    required this.loction,
    required this.color,
    required this.phoneNo,
    required this.donId,
  });
  final _chatController = Get.find<ChatController>();
  ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: (imgUrl.contains('http') &&
                          !imgUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                      ? Image.network(
                          imgUrl,
                          height: 22.w,
                          width: 35.71.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 22.w,
                              width: 35.71.w,
                              decoration: BoxDecoration(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff2A2A2A)
                                    : Color(0xffE5E5E5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 16.w,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff5A5A5A)
                                    : Color(0xffA5A5A5),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 22.w,
                          width: 35.71.w,
                          decoration: BoxDecoration(
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff2A2A2A)
                                : Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 16.w,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff5A5A5A)
                                : Color(0xffA5A5A5),
                          ),
                        )),
            ),
            SizedBox(
              height: 0.8.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    docName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.darkHeadingTextStyle(size: 14),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.to(DirectMessageScreen(
                        userName: docName,
                        friendId: donId.toString(),
                        userId: _profileController.userId.value,
                        userAsset: _profileController.image.toString(),
                        // conversationId:
                        //     result.data!.sId.toString(),
                      ));

                      // _chatController.createConvo(donId, docName);
                    },
                    child: SvgPicture.asset(
                      'Assets/images/sms-notification.svg',
                      width: 4.w,
                      height: 4.w,
                    )),
                SizedBox(
                  width: 1.5.w,
                ),
                InkWell(
                    onTap: () {
                      makingPhoneCall(phoneNo);
                    },
                    child: SvgPicture.asset(
                      'Assets/images/call-add.svg',
                      width: 4.w,
                      height: 4.w,
                    ))
              ],
            ),
            SizedBox(height: 0.3.h),
            Divider(
              color: AppColors.lightGreyColor,
              thickness: 0.5,
            ),
            SizedBox(height: 0.3.h),
            Text(
              Category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.w600TextStyle(
                  size: 12, color: Color(0xff4B5563)),
            ),
            SizedBox(height: 0.3.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'Assets/icons/location.svg',
                  width: 3.w,
                  height: 3.w,
                ),
                SizedBox(
                  width: 0.5.w,
                ),
                Expanded(
                  child: Text(loction,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff4B5563), size: 11)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

makingPhoneCall(String phoneNo) async {
  // Guard against null/empty/"null" values to avoid tel:null errors
  if (phoneNo.trim().isEmpty || phoneNo.toLowerCase() == 'null') {
    print('⚠️ [makingPhoneCall] Phone number is empty or null-like, aborting call.');
    return;
  }

  final cleaned = phoneNo.trim();
  print('📞 [makingPhoneCall] Attempting to call: $cleaned');
  var url = Uri.parse("tel:$cleaned");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

List bgColors = [AppColors.redLightColor, AppColors.yellowLightColor];
List fgColors = [AppColors.redLightDarkColor, AppColors.yellowLightDarkColor];
