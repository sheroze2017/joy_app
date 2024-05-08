import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 35, right: 35, bottom: 20),
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
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
              Text('Congratulations!', style: CustomTextStyles.darkTextStyle()),
              SizedBox(height: 2.h),
              Text(
                'Your account is ready to use. You will be redirected to the dashboard in a few seconds...',
                style: CustomTextStyles.lightTextStyle(),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
              SizedBox(height: 2.h),
              SpinKitFadingCircle(
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
