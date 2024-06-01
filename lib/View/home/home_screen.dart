import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:joy_app/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<String> imageList = [
    'https://s3-alpha-sig.figma.com/img/6e76/389f/b8c80d0899c8c8ea2b2d81ea6e01642f?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=QEMQW2OdZWg8GfBZQoP251jT20zgMrPRTHON2tI4AvdrJyNj4QUuh5PMoGuby6znM9iEHfcnP1eJYnIaAGOCZOPQPf2I9HccnbsdhaWo0UYAgZceYHedobBIUlH26nhcEQ8Mn3mluMc0We0zcaMGLqx3WF2R6fxMfYYHltkb8rCVFMBkrJcG5HpQu45c-HbHqqsqrLcAcbDcg6wV8ELOs9zoSneVG87byI34MOZ90O4fBZsjeUWUhwykUvmqzOcdIkzhO09TioPIUcFflVIkG9oUaWi4pasxxdKkIlEGDw3thlNBaRmmb7D61aJKSUxnI2taM2EbwDk8f7xiPtHeEA__',
    'https://s3-alpha-sig.figma.com/img/6e76/389f/b8c80d0899c8c8ea2b2d81ea6e01642f?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=QEMQW2OdZWg8GfBZQoP251jT20zgMrPRTHON2tI4AvdrJyNj4QUuh5PMoGuby6znM9iEHfcnP1eJYnIaAGOCZOPQPf2I9HccnbsdhaWo0UYAgZceYHedobBIUlH26nhcEQ8Mn3mluMc0We0zcaMGLqx3WF2R6fxMfYYHltkb8rCVFMBkrJcG5HpQu45c-HbHqqsqrLcAcbDcg6wV8ELOs9zoSneVG87byI34MOZ90O4fBZsjeUWUhwykUvmqzOcdIkzhO09TioPIUcFflVIkG9oUaWi4pasxxdKkIlEGDw3thlNBaRmmb7D61aJKSUxnI2taM2EbwDk8f7xiPtHeEA__',
    'https://s3-alpha-sig.figma.com/img/6e76/389f/b8c80d0899c8c8ea2b2d81ea6e01642f?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=QEMQW2OdZWg8GfBZQoP251jT20zgMrPRTHON2tI4AvdrJyNj4QUuh5PMoGuby6znM9iEHfcnP1eJYnIaAGOCZOPQPf2I9HccnbsdhaWo0UYAgZceYHedobBIUlH26nhcEQ8Mn3mluMc0We0zcaMGLqx3WF2R6fxMfYYHltkb8rCVFMBkrJcG5HpQu45c-HbHqqsqrLcAcbDcg6wV8ELOs9zoSneVG87byI34MOZ90O4fBZsjeUWUhwykUvmqzOcdIkzhO09TioPIUcFflVIkG9oUaWi4pasxxdKkIlEGDw3thlNBaRmmb7D61aJKSUxnI2taM2EbwDk8f7xiPtHeEA__',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 1.w),
                Row(
                  children: [
                    SvgPicture.asset('Assets/icons/pindrop.svg'),
                    SizedBox(width: 1.w),
                    Text(
                      'Seattle, USA',
                      style: CustomTextStyles.w600TextStyle(
                          size: 14, color: Color(0xff374151)),
                    ),
                  ],
                )
              ],
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xffF3F4F6)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('Assets/icons/notification-bing.svg'),
                ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedSearchTextField(
                hintText: 'Search doctor...',
                controller: TextEditingController()),
            SizedBox(
              height: 2.h,
            ),
            CarouselSlider(
              options: CarouselOptions(
                //height: 20.h,
                // enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 8,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1,
              ),
              items: imageList.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
