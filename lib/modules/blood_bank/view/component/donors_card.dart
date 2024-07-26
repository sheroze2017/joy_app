import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/utils/constant/constant.dart';
import 'package:joy_app/modules/social_media/chat/bloc/chat_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorsCardWidget extends StatelessWidget {
  final String imgUrl;
  final String Category;
  final String docName;
  final String loction;
  final Color color;
  final String phoneNo;
  final int donId;

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
                  child: Image.network(
                    imgUrl.contains('http')
                        ? imgUrl
                        : CustomConstant.nullUserImage,
                    height: 26.w,
                    width: 35.71.w,
                    fit: BoxFit.cover,
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
                      _chatController.createConvo(donId, docName);
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
  var url = Uri.parse("tel:${phoneNo}");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

List bgColors = [AppColors.redLightColor, AppColors.yellowLightColor];
List fgColors = [AppColors.redLightDarkColor, AppColors.yellowLightDarkColor];
