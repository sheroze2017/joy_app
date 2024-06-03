import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../home/my_profile.dart';
import '../user_flow/hospital_user/hospital_detail_screen.dart';

class HospitalHomeScreen extends StatelessWidget {
  bool? isHospital;
  bool? isUser;

  HospitalHomeScreen({this.isHospital = false, this.isUser = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0, // Height of the app bar when it's expanded.
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(
                    'Assets/images/hospitalcover.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 30.0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Text(
                      'Hospital Details',
                      style: CustomTextStyles.darkTextStyle(
                          color: Color(0xff374151)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  // height: 500.0, // Adjust height as needed
                  // color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: SvgPicture.asset(
                                  'Assets/icons/joy-icon-small.svg'),
                            ),
                            Spacer(),
                            SvgPicture.asset('Assets/icons/searchbg.svg'),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 0.0, left: 8),
                              child: SvgPicture.asset(
                                  'Assets/icons/messagebg.svg'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                cursorColor: AppColors.borderColor,
                                style: CustomTextStyles.lightTextStyle(
                                    color: AppColors.borderColor),
                                decoration: InputDecoration(
                                  hintText: "What's on your mind, Hashem?",
                                  hintStyle: CustomTextStyles.lightTextStyle(
                                      color: AppColors.borderColor),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(54),
                                color: AppColors.whiteColorf9f,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('Assets/icons/camera.svg'),
                                    SizedBox(width: 2.w),
                                    Text(
                                      "Photo",
                                      style: CustomTextStyles.lightTextStyle(
                                        color: AppColors.borderColor,
                                        size: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Sunrise Health Clinic',
                          style: CustomTextStyles.darkHeadingTextStyle(
                              size: 30, color: Color(0xff383D44)),
                        ),
                        LocationWidget(),
                        SizedBox(
                          height: 1.h,
                        ),
                        Divider(
                          color: Color(0xffE5E7EB),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedSVGContainer(
                              svgAsset: 'Assets/icons/profile-2user.svg',
                              numberText: '50+',
                              descriptionText: 'Doctors',
                            ),
                            RoundedSVGContainer(
                              svgAsset: 'Assets/icons/medal.svg',
                              numberText: '10+',
                              descriptionText: 'Experience',
                            ),
                            RoundedSVGContainer(
                              svgAsset: 'Assets/icons/star.svg',
                              numberText: '5',
                              descriptionText: 'Rating',
                            ),
                            RoundedSVGContainer(
                              svgAsset: 'Assets/icons/messages.svg',
                              numberText: '1872',
                              descriptionText: 'Reviews',
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Heading(
                          title: 'About Hospital',
                        ),
                        SizedBox(height: 0.5.h),
                        ReadMoreText(
                          "Sunrise health clinic is renowned hospital working from last 12 years. It have all the modern machinery and all lab tests are available. It have all the modern machinery and all lab tests are available",
                          trimMode: TrimMode.Line,
                          trimLines: 3,
                          colorClickableText: AppColors.blackColor,
                          trimCollapsedText: ' view more',
                          trimExpandedText: ' view less',
                          style: CustomTextStyles.lightTextStyle(size: 14),
                          moreStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          lessStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 1.h),
                        Heading(
                          title: 'Hospital Timings',
                        ),
                        SizedBox(height: 0.5.h),
                        Text('Monday-Friday, 08.00 AM-18.00 pM',
                            style: CustomTextStyles.lightTextStyle(
                                color: Color(0xff4B5563), size: 14)),
                        SizedBox(height: 1.h),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Text(
                              'Our Doctors',
                              style: CustomTextStyles.darkHeadingTextStyle(),
                            ),
                            Spacer(),
                            Text(
                              'See All',
                              style: CustomTextStyles.lightSmallTextStyle(),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 57.5.w,
                          decoration: BoxDecoration(
                              color: Color(0xffEEF5FF),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg',
                                    width: 51.28.w,
                                    height: 27.9.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Container(
                                  width: 51.28.w,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. David Patel',
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(),
                                        ),
                                        Divider(
                                          color: Color(0xff6B7280),
                                          thickness: 0.05.h,
                                        ),
                                        Text(
                                          'Cardiologist',
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 14,
                                              color: Color(0xff4B5563)),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'Assets/icons/location.svg'),
                                            SizedBox(
                                              width: 0.5.w,
                                            ),
                                            Text('Cardiology Center, USA',
                                                style: CustomTextStyles
                                                    .lightTextStyle(
                                                        color:
                                                            Color(0xff4B5563),
                                                        size: 14))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              itemSize: 15,
                                              initialRating: 6,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 1,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            Text('5',
                                                style: CustomTextStyles
                                                    .lightTextStyle(
                                                        color:
                                                            Color(0xff4B5563),
                                                        size: 12)),
                                            SizedBox(
                                              width: 0.5.w,
                                            ),
                                            Text(' | 1,872 Reviews',
                                                style: CustomTextStyles
                                                    .lightTextStyle(
                                                        color:
                                                            Color(0xff6B7280),
                                                        size: 10.8)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Text(
                              'Visit Our Pharmacy',
                              style: CustomTextStyles.darkHeadingTextStyle(),
                            ),
                            Spacer(),
                            Text(
                              isHospital == true ? 'Edit' : 'See All',
                              style: CustomTextStyles.lightSmallTextStyle(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MedicineCard(
                                onPressed: () {},
                                btnText: "Add to Cart",
                                imgUrl:
                                    'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                count: '10',
                                cost: '5',
                                name: 'Panadol',
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: MedicineCard(
                                onPressed: () {},
                                btnText: "Add to Cart",
                                imgUrl:
                                    'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                count: '10',
                                cost: '5',
                                name: 'Panadol',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Heading(
                          title: 'Reviews',
                        ),
                        SizedBox(height: 1.h),
                        UserRatingWidget(
                          docName: 'Emily Anderson',
                          reviewText: '',
                          rating: '5',
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Text(
                              'My Posts',
                              style: CustomTextStyles.darkHeadingTextStyle(),
                            ),
                            Spacer(),
                            Text(
                              'See All',
                              style: CustomTextStyles.lightSmallTextStyle(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        PostHeader(),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'Our Hospital Complete 100 Surgeries today',
                          style: CustomTextStyles.lightTextStyle(
                              color: Color(0xff2D3F7B), size: 11.56),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          height: 20.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage('Assets/images/hospital.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ReactionCount(
                          comment: '3.4k',
                          share: '46',
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          children: [
                            CircleButton(
                              isActive: true,
                              img: 'Assets/images/like.png',
                              color: Color(0xff000000),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            CircleButton(
                              img: 'Assets/images/message.png',
                              color: Color(0xFFF9FAFB),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            CircleButton(
                              img: 'Assets/images/send.png',
                              color: Color(0xFFF9FAFB),
                            ),
                            Spacer(),
                            LikeCount(
                              like: '32.1K',
                              name: 'Ali',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
