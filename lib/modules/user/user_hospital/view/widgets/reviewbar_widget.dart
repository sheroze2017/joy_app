import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

class ReviewBar extends StatelessWidget {
  int count;
  String rating;
  ReviewBar({super.key, required this.count, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(rating,
            style: CustomTextStyles.w600TextStyle(
                color: Color(0xff6B7280), size: 10.8)),
        RatingBar.builder(
          itemSize: 15,
          initialRating: double.parse(rating),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          tapOnlyMode: true,
          itemCount: 5,
          updateOnDrag: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        SizedBox(
          width: 0.5.w,
        ),
        Text('(${count} Reviews)',
            style: CustomTextStyles.lightTextStyle(
                color: Color(0xff6B7280), size: 10.8)),
      ],
    );
  }
}
