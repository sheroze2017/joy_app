import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:sizer/sizer.dart';

class HosipitalCardWidget extends StatelessWidget {
  String? name;
  String? location;
  HosipitalCardWidget({this.name, this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 59.4.w,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE5E7EB)),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg',
              width: 59.4.w,
              height: 31.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: HospitalName(),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: LocationWidget(),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ReviewBar(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              color: Color(0xffE5E7EB),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/routing.svg'),
                    SizedBox(
                      width: 0.5.w,
                    ),
                    Text('2.5 km/40min',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 10.8))
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/hospital.svg'),
                    SizedBox(
                      width: 0.5.w,
                    ),
                    Text('Hospital',
                        style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff6B7280), size: 10.8))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
