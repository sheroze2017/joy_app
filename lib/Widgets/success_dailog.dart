import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/home/navbar.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  bool showButton;
  bool isBookAppointment;
  Color? buttonColor;
  bool isDoctorForm;

  CustomDialog(
      {super.key,
      required this.title,
      required this.content,
      this.buttonColor,
      this.showButton = false,
      this.isBookAppointment = false,this.isDoctorForm=false});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, isBookAppointment),
    );
  }

  dialogContent(BuildContext context, isBookAppointment) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(48),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'Assets/images/accountcreated.svg',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 2.h),
              Text(title, style: CustomTextStyles.darkTextStyle()),
              SizedBox(height: 2.h),
              Text(
                content,
                style: CustomTextStyles.lightTextStyle(),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
              SizedBox(height: 2.h),
              showButton
                  ? Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                              text: 'Done',
                              onPressed: () {
                                Get.to(NavBarScreen());
                              },
                              backgroundColor: buttonColor != null
                                  ? Color(0xff1C2A3A)
                                  : isBookAppointment
                                      ? AppColors.darkBlueColor
                                      : AppColors.darkGreenColor,
                              textColor: AppColors.whiteColor),
                        ),
                      ],
                    )
                  : SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 50.0,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
