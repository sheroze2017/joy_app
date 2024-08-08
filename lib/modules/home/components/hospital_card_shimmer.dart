import 'package:flutter/material.dart';
import 'package:joy_app/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerListViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 59.4.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffE5E7EB),
          width: ThemeUtil.isDarkMode(context) ? 0.1 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Color.fromARGB(31, 185, 182, 182),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                width: 59.4.w,
                height: 31.w,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: 40.w,
                height: 10,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: 30.w,
                height: 10,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: 20.w,
                height: 10,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Divider(
                color: Color(0xffE5E7EB),
                thickness: ThemeUtil.isDarkMode(context) ? 0.2 : 0.6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 0.5.w),
                  Container(
                    width: 15.w,
                    height: 10,
                    color: Colors.grey,
                  ),
                  Spacer(),
                  Container(
                    width: 10.w,
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 0.5.w),
                  Container(
                    width: 10.w,
                    height: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
