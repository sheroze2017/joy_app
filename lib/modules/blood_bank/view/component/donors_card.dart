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
      // height: 100.h,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: (imgUrl.contains('http') &&
                          !imgUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab'))
                      ? Image.network(
                          imgUrl,
                          height: 26.w,
                          width: 35.71.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 26.w,
                              width: 35.71.w,
                              decoration: BoxDecoration(
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff2A2A2A)
                                    : Color(0xffE5E5E5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                Icons.person,
                                size: 20.w,
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff5A5A5A)
                                    : Color(0xffA5A5A5),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 26.w,
                          width: 35.71.w,
                          decoration: BoxDecoration(
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff2A2A2A)
                                : Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 20.w,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff5A5A5A)
                                : Color(0xffA5A5A5),
                          ),
                        )),
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    docName,
                    style: CustomTextStyles.darkHeadingTextStyle(size: 15),
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
                    )),
                SizedBox(
                  width: 2.w,
                ),
                InkWell(
                    onTap: () {
                      makingPhoneCall(phoneNo);
                    },
                    child: SvgPicture.asset(
                      'Assets/images/call-add.svg',
                    ))
              ],
            ),
            Divider(
              color: AppColors.lightGreyColor,
            ),
            Text(
              Category,
              maxLines: 1,
              style: CustomTextStyles.w600TextStyle(
                  size: 13, color: Color(0xff4B5563)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('Assets/icons/location.svg'),
                SizedBox(
                  width: 0.5.w,
                ),
                Expanded(
                  child: Text(loction,
                      maxLines: 2,
                      style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff4B5563), size: 13)),
                )
              ],
            )
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
