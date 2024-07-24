import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../home/my_profile.dart';

// class ImagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverAppBar(
//           expandedHeight: 20.h, // Height of the app bar when it's expanded.
//           flexibleSpace: Stack(
//             children: <Widget>[
//               Positioned.fill(
//                 child: Image.asset(
//                   'Assets/images/hospitalcover.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 30.0,
//                 right: 0,
//                 left: 0,
//                 child: Center(
//                   child: Text(
//                     'Hospital Details',
//                     style: CustomTextStyles.darkTextStyle(
//                         color: Color(0xff374151)),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0.0,
//                 right: 0,
//                 left: 0,
//                 child: Container(
//                   height: 5.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildListDelegate(
//             [
//               Container(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Sunrise Health Clinic',
//                         style: CustomTextStyles.darkHeadingTextStyle(
//                             size: 30, color: Color(0xff383D44)),
//                       ),
//                       LocationWidget(),
//                       SizedBox(
//                         height: 1.h,
//                       ),
//                       Divider(
//                         color: Color(0xffE5E7EB),
//                       ),
//                       SizedBox(
//                         height: 1.h,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           RoundedSVGContainer(
//                             svgAsset: 'Assets/icons/profile-2user.svg',
//                             numberText: '50+',
//                             descriptionText: 'Doctors',
//                           ),
//                           RoundedSVGContainer(
//                             svgAsset: 'Assets/icons/medal.svg',
//                             numberText: '10+',
//                             descriptionText: 'Experience',
//                           ),
//                           RoundedSVGContainer(
//                             svgAsset: 'Assets/icons/star.svg',
//                             numberText: '5',
//                             descriptionText: 'Rating',
//                           ),
//                           RoundedSVGContainer(
//                             svgAsset: 'Assets/icons/messages.svg',
//                             numberText: '1872',
//                             descriptionText: 'Reviews',
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 1.h),
//                       Heading(
//                         title: 'About Hospital',
//                       ),
//                       SizedBox(height: 0.5.h),
//                       ReadMoreText(
//                         "Sunrise health clinic is renowned hospital working from last 12 years. It have all the modern machinery and all lab tests are available. It have all the modern machinery and all lab tests are available",
//                         trimMode: TrimMode.Line,
//                         trimLines: 3,
//                         colorClickableText: AppColors.blackColor,
//                         trimCollapsedText: ' view more',
//                         trimExpandedText: ' view less',
//                         style: CustomTextStyles.lightTextStyle(size: 14),
//                         moreStyle: TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         lessStyle: TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 1.h),
//                       Heading(
//                         title: 'Hospital Timings',
//                       ),
//                       SizedBox(height: 0.5.h),
//                       Text('Monday-Friday, 08.00 AM-18.00 pM',
//                           style: CustomTextStyles.lightTextStyle(
//                               color: Color(0xff4B5563), size: 14)),
//                       SizedBox(height: 1.h),
//                       SizedBox(height: 1.h),
//                       Row(
//                         children: [
//                           Text(
//                             'Our Doctors',
//                             style: CustomTextStyles.darkHeadingTextStyle(),
//                           ),
//                           Spacer(),
//                           Text(
//                             'See All',
//                             style: CustomTextStyles.lightSmallTextStyle(),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 0.5.h),
//                       Container(
//                         width: 57.5.w,
//                         decoration: BoxDecoration(
//                             color: Color(0xffEEF5FF),
//                             borderRadius: BorderRadius.circular(12)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 child: Image.network(
//                                   'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg',
//                                   width: 51.28.w,
//                                   height: 27.9.w,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 2.w,
//                               ),
//                               Container(
//                                 width: 51.28.w,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(8, 8, 0, 0),
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Dr. David Patel',
//                                         style: CustomTextStyles
//                                             .darkHeadingTextStyle(),
//                                       ),
//                                       Divider(
//                                         color: Color(0xff6B7280),
//                                         thickness: 0.05.h,
//                                       ),
//                                       Text(
//                                         'Cardiologist',
//                                         style: CustomTextStyles.w600TextStyle(
//                                             size: 14, color: Color(0xff4B5563)),
//                                       ),
//                                       Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                               'Assets/icons/location.svg'),
//                                           SizedBox(
//                                             width: 0.5.w,
//                                           ),
//                                           Text('Cardiology Center, USA',
//                                               style: CustomTextStyles
//                                                   .lightTextStyle(
//                                                       color: Color(0xff4B5563),
//                                                       size: 14))
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           RatingBar.builder(
//                                             itemSize: 15,
//                                             initialRating: 6,
//                                             minRating: 1,
//                                             direction: Axis.horizontal,
//                                             allowHalfRating: true,
//                                             itemCount: 1,
//                                             itemPadding: EdgeInsets.symmetric(
//                                                 horizontal: 0.0),
//                                             itemBuilder: (context, _) => Icon(
//                                               Icons.star,
//                                               color: Colors.amber,
//                                             ),
//                                             onRatingUpdate: (rating) {
//                                               print(rating);
//                                             },
//                                           ),
//                                           Text('5',
//                                               style: CustomTextStyles
//                                                   .lightTextStyle(
//                                                       color: Color(0xff4B5563),
//                                                       size: 12)),
//                                           SizedBox(
//                                             width: 0.5.w,
//                                           ),
//                                           Text(' | 1,872 Reviews',
//                                               style: CustomTextStyles
//                                                   .lightTextStyle(
//                                                       color: Color(0xff6B7280),
//                                                       size: 10.8)),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Row(
//                         children: [
//                           Text(
//                             'Visit Our Pharmacy',
//                             style: CustomTextStyles.darkHeadingTextStyle(),
//                           ),
//                           Spacer(),
//                           Text(
//                             'See All',
//                             style: CustomTextStyles.lightSmallTextStyle(),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 0.5.h,
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: MedicineCard(
//                               onPressed: () {},
//                               btnText: "Add to Cart",
//                               imgUrl:
//                                   'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
//                               count: '10',
//                               cost: '5',
//                               name: 'Panadol',
//                             ),
//                           ),
//                           SizedBox(
//                             width: 2.w,
//                           ),
//                           Expanded(
//                             child: MedicineCard(
//                               onPressed: () {},
//                               btnText: "Add to Cart",
//                               imgUrl:
//                                   'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
//                               count: '10',
//                               cost: '5',
//                               name: 'Panadol',
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 1.h),
//                       Heading(
//                         title: 'Reviews',
//                       ),
//                       SizedBox(height: 1.h),
//                       UserRatingWidget(
//                         docName: 'Emily Anderson',
//                         reviewText: '',
//                         rating: '5',
//                       ),
//                       SizedBox(height: 2.h),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRoundedImage(String imageUrl, BoxFit fit) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20.0),
//       child: Image.network(
//         imageUrl,
//         fit: fit,
//       ),
//     );
//   }
// }

class UserRatingWidget extends StatelessWidget {
  final String docName;
  final String reviewText;
  final String rating;
  final String image;

  const UserRatingWidget(
      {super.key,
      required this.docName,
      required this.reviewText,
      required this.rating,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                image.contains('http')
                    ? image
                    : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                width: 14.5.w,
                height: 14.5.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    docName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : null),
                  ),
                  Row(
                    children: [
                      Text(rating,
                          style: CustomTextStyles.lightTextStyle(
                              color: ThemeUtil.isDarkMode(context)
                                  ? null
                                  : Color(0xff4B5563),
                              size: 12)),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      RatingBar.builder(
                        tapOnlyMode: true,
                        itemSize: 15,
                        initialRating: double.parse(rating) ?? 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(reviewText,
            style: CustomTextStyles.lightTextStyle(
                color: ThemeUtil.isDarkMode(context) ? null : Color(0xff4B5563),
                size: 14)),
      ],
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String imgUrl;
  final String cost;
  final String count;
  final String name;
  final String btnText;
  final VoidCallback onPressed;
  bool isUserProductScreen;
  int categoryId;

  MedicineCard(
      {super.key,
      required this.imgUrl,
      required this.cost,
      required this.count,
      required this.name,
      required this.btnText,
      this.isUserProductScreen = false,
      this.categoryId = 1,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43.w,
      decoration: BoxDecoration(
          color: Color(0xffE2FFE3), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        imgUrl,
                        width: 12.5.w,
                        height: 12.5.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? 'Panadol',
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          Text(
                            '${count} ${category[categoryId - 1]} for ${cost}\$',
                            style: CustomTextStyles.w600TextStyle(
                                size: 13, color: Color(0xff4B5563)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 2.w,
                ),
                Divider(
                  color: Color(0xff6B7280),
                  thickness: 0.05.h,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                      isSmall: true,
                      text: btnText,
                      onPressed: onPressed,
                      backgroundColor: ThemeUtil.isDarkMode(context)
                          ? isUserProductScreen
                              ? Color(0xff1DAA61)
                              : AppColors.lightGreenColoreb1
                          : AppColors.darkGreenColor,
                      textColor: ThemeUtil.isDarkMode(context)
                          ? AppColors.blackColor
                          : AppColors.whiteColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoundedSVGContainer extends StatelessWidget {
  final String svgAsset;
  final String numberText;
  final String descriptionText;
  final Color? bgColor;
  final Color? iconColor;
  bool isDoctor;

  RoundedSVGContainer({
    required this.svgAsset,
    required this.numberText,
    required this.descriptionText,
    this.bgColor,
    this.iconColor,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isDoctor
                ? null
                : ThemeUtil.isDarkMode(context)
                    ? Color(0xff171717)
                    : bgColor ??
                        Color(0xffF3F4F6), // Background color of the container
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                color: iconColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 0.2.h),
        Text(numberText,
            style: CustomTextStyles.w600TextStyle(
                color: Color(0xff4B5563), size: 14)),
        Text(descriptionText, style: CustomTextStyles.lightTextStyle(size: 14)),
      ],
    );
  }
}

List<String> category = ['pills', 'round_pills', 'syrupe'];
