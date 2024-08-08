import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class LocationWidget extends StatelessWidget {
  bool isBloodbank;
  String? location;
  LocationWidget({this.isBloodbank = false, this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('Assets/icons/location.svg'),
        SizedBox(
          width: 0.5.w,
        ),
        Expanded(
          child: Text(location ?? 'null',
              style: CustomTextStyles.lightTextStyle(
                  color: isBloodbank
                      ? ThemeUtil.isDarkMode(context)
                          ? Color(0xff6B7280)
                          : Color(0xff383D44)
                      : Color(0xff6B7280),
                  size: 10.8)),
        )
      ],
    );
  }
}
