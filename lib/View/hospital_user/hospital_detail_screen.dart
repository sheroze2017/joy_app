import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../profile/my_profile.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Check whether the current theme is dark or light
    bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30.h,
                child: Hero(
                  tag: 'imageHero',
                  child: _buildRoundedImage(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg',
                      BoxFit.cover),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: (Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sunrise Health Clinic',
                      style: CustomTextStyles.darkHeadingTextStyle(
                          size: 30, color: Color(0xff383D44)),
                    ),
                    // LocationWidget(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     RoundedSVGContainer(
                    //       svgAsset: 'Assets/icons/profile-2user.svg',
                    //       numberText: '50+',
                    //       descriptionText: 'Doctors',
                    //     ),
                    //     RoundedSVGContainer(
                    //       svgAsset: 'Assets/icons/medal.svg',
                    //       numberText: '10+',
                    //       descriptionText: 'medal',
                    //     ),
                    //     RoundedSVGContainer(
                    //       svgAsset: 'Assets/icons/star.svg',
                    //       numberText: '5',
                    //       descriptionText: 'star',
                    //     ),
                    //     RoundedSVGContainer(
                    //       svgAsset: 'Assets/icons/messages.svg',
                    //       numberText: '1872',
                    //       descriptionText: 'reviews',
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 1.h),
                    // Heading(
                    //   title: 'About Hospital',
                    // ),
                    // SizedBox(height: 0.5.h),
                    // Text(
                    //     'Sunrise health clinic is renowned hospital working from last 12 years. It have all the modern machinery and all lab tests are available. ',
                    //     style: CustomTextStyles.lightTextStyle(
                    //         color: Color(0xff4B5563), size: 14)),
                    // SizedBox(height: 1.h),
                    // Heading(
                    //   title: 'Hospital Timings',
                    // ),
                    // SizedBox(height: 0.5.h),
                    // Text('Monday-Friday, 08.00 AM-18.00 pM',
                    //     style: CustomTextStyles.lightTextStyle(
                    //         color: Color(0xff4B5563), size: 14)),
                    // SizedBox(height: 0.5.h),
                    // SizedBox(height: 1.h),
                    // Heading(
                    //   title: 'Check up Fee',
                    // ),
                    // SizedBox(height: 0.5.h),
                    // Text('150',
                    //     style: CustomTextStyles.lightTextStyle(
                    //         color: Color(0xff4B5563), size: 14)),
                    // SizedBox(height: 1.h),
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
                    // Container(
                    //   width: 57.5.w,
                    //   decoration: BoxDecoration(
                    //       color: Color(0xffEEF5FF),
                    //       borderRadius: BorderRadius.circular(12)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(12.0),
                    //     child: Column(
                    //       children: [
                    //         ClipRRect(
                    //           borderRadius: BorderRadius.circular(12.0),
                    //           child: Image.network(
                    //             'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Hospital-de-Bellvitge.jpg/640px-Hospital-de-Bellvitge.jpg',
                    //             width: 51.28.w,
                    //             height: 27.9.w,
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 2.w,
                    //         ),
                    //         Container(
                    //           width: 51.28.w,
                    //           child: Padding(
                    //             padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                    //             child: Column(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text(
                    //                   'Dr. David Patel',
                    //                   style: CustomTextStyles
                    //                       .darkHeadingTextStyle(),
                    //                 ),
                    //                 Divider(
                    //                   color: Color(0xff6B7280),
                    //                   thickness: 0.05.h,
                    //                 ),
                    //                 Text(
                    //                   'Cardiologist',
                    //                   style: CustomTextStyles.w600TextStyle(
                    //                       size: 14, color: Color(0xff4B5563)),
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     SvgPicture.asset(
                    //                         'Assets/icons/location.svg'),
                    //                     SizedBox(
                    //                       width: 0.5.w,
                    //                     ),
                    //                     Text('Cardiology Center, USA',
                    //                         style:
                    //                             CustomTextStyles.lightTextStyle(
                    //                                 color: Color(0xff4B5563),
                    //                                 size: 14))
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     RatingBar.builder(
                    //                       itemSize: 15,
                    //                       initialRating: 6,
                    //                       minRating: 1,
                    //                       direction: Axis.horizontal,
                    //                       allowHalfRating: true,
                    //                       itemCount: 1,
                    //                       itemPadding: EdgeInsets.symmetric(
                    //                           horizontal: 0.0),
                    //                       itemBuilder: (context, _) => Icon(
                    //                         Icons.star,
                    //                         color: Colors.amber,
                    //                       ),
                    //                       onRatingUpdate: (rating) {
                    //                         print(rating);
                    //                       },
                    //                     ),
                    // Text('5',
                    //     style:
                    //         CustomTextStyles.lightTextStyle(
                    //             color: Color(0xff4B5563),
                    //             size: 12)),
                    // SizedBox(
                    //   width: 0.5.w,
                    // ),
                    //                     Text(' | 1,872 Reviews',
                    //                         style:
                    //                             CustomTextStyles.lightTextStyle(
                    //                                 color: Color(0xff6B7280),
                    //                                 size: 10.8)),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         )

                    //       ],
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          'Visit Our Pharmacy',
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
                      height: 0.5.h,
                    ),
                    MedicineCard(
                      imgUrl:
                          'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                      count: '10',
                      cost: '5',
                      name: 'Panadol',
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
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedImage(String imageUrl, BoxFit fit) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.network(
        imageUrl,
        fit: fit,
      ),
    );
  }
}

class UserRatingWidget extends StatelessWidget {
  final String docName;
  final String reviewText;
  final String rating;

  const UserRatingWidget(
      {super.key,
      required this.docName,
      required this.reviewText,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                'https://www.nebosh.org.uk/public/case-studies/shyam-susivrithan.jpg',
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
                    'Joe Doe',
                    style: CustomTextStyles.darkHeadingTextStyle(),
                  ),
                  Row(
                    children: [
                      Text('5.0',
                          style: CustomTextStyles.lightTextStyle(
                              color: Color(0xff4B5563), size: 12)),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      RatingBar.builder(
                        itemSize: 15,
                        initialRating: 6,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
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
        Text(
            'Dr. Patel is a true professional who genuinely cares about his patients. I highly recommend Dr. Patel to anyone seeking exceptional cardiac care.',
            style: CustomTextStyles.lightTextStyle(
                color: Color(0xff4B5563), size: 14)),
      ],
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String imgUrl;
  final String cost;
  final String count;
  final String name;

  const MedicineCard(
      {super.key,
      required this.imgUrl,
      required this.cost,
      required this.count,
      required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43.w,
      decoration: BoxDecoration(
          color: Color(0xffE2FFE3), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                        '${count} Tablets for ${cost}\$',
                        style: CustomTextStyles.w600TextStyle(
                            size: 14, color: Color(0xff4B5563)),
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
            Row(
              children: [
                Expanded(
                  child: RoundedButtonSmall(
                      isSmall: true,
                      text: "Add to Cart",
                      onPressed: () {},
                      backgroundColor: Color(0xff015104),
                      textColor: Color(0xffFFFFFF)),
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

  RoundedSVGContainer({
    required this.svgAsset,
    required this.numberText,
    required this.descriptionText,
    this.bgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // You can adjust the size as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: bgColor ??
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
        Text(descriptionText,
            style: CustomTextStyles.lightTextStyle(
                color: Color(0xff4B5563), size: 14)),
      ],
    );
  }
}
