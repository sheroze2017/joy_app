import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joy_app/Widgets/appbar.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/rounded_button.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> userNames = ['User 1', 'User 2', 'User 3', 'User 4', 'User 5'];
    List<String> userAssets = [
      'Assets/images/accountcreated.svg',
      'Assets/images/accountcreated.svg',
      'Assets/images/accountcreated.svg',
      'Assets/images/accountcreated.svg',
      'Assets/images/accountcreated.svg',
    ];
    return Scaffold(
      appBar: HomeAppBar(
        title: 'My Profile',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SvgPicture.asset('Assets/icons/edit-2.svg'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset('Assets/icons/setting-2.svg'),
          )
        ],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffFAFAFA)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '1K',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            color: Color(0xff000000),
                                            size: 15.41),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    'Posts',
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff000000), size: 13.21),
                                  )
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    '2000',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            color: Color(0xff000000),
                                            size: 15.41),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    'Friends',
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff000000), size: 13.21),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 65,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            'Sheroze Rehman',
                            style:
                                CustomTextStyles.darkHeadingTextStyle(size: 14),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                            isSmall: true,
                            text: "Message",
                            onPressed: () {},
                            backgroundColor: Color(0xffE5E7EB),
                            textColor: Color(0xff1C2A3A)),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: RoundedButtonSmall(
                            isSmall: true,
                            text: "Add Friend",
                            onPressed: () {},
                            backgroundColor: Color(0xff1C2A3A),
                            textColor: Color(0xffFFFFFF)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Heading(
                  title: 'About me',
                ),
                SizedBox(height: 1.h),
                Text(
                  'I’m Alexa David, diagnosed with Cancer last year. Starting getting chemotherapeutic treatment and now i’m getting better day by day.',
                  style: CustomTextStyles.lightTextStyle(),
                ),
                SizedBox(height: 2.h),
                Heading(
                  title: 'My Friends',
                ),
                SizedBox(height: 1.h),
                //   UserSlider(userNames: userNames, userAssets: userAssets),
                Row(
                  children: [
                    Text(
                      'Photos',
                      style: CustomTextStyles.darkHeadingTextStyle(),
                    ),
                    Spacer(),
                    Text(
                      'See All',
                      style: CustomTextStyles.lightSmallTextStyle(),
                    ),
                  ],
                ),
                // Container(
                //   child: Row(children: [
                //     Image(
                //         height: 20.h,
                //         width: 60.w,
                //         image: NetworkImage(
                //             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s')),
                //     Container(
                //       child: Column(
                //         children: [
                //           Image(
                //             height: 9.5.h,
                //             width: 30.w,
                //             image: NetworkImage(
                //                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'),
                //           ),
                //           SizedBox(
                //             height: 1.h,
                //           ),
                //           Image(
                //               height: 9.5.h,
                //               width: 30.w,
                //               image: NetworkImage(
                //                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'))
                //         ],
                //       ),
                //     )
                //   ]),
                // )
                SizedBox(
                  height: 2.h,
                ),
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

                PostHeader(),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Hey pals ! Had my third day of chemo. feeling much better. Hey pals ! Had my third day of chemo. feeling much better.',
                  style: CustomTextStyles.lightTextStyle(
                      color: Color(0xff2D3F7B), size: 11.56),
                ),
                ReactionCount(
                  comment: '3.4k',
                  share: '46',
                ),

                Row(
                  children: [
                    CircleButton(
                      color: Color(0xff000000),
                    ),
                    Spacer(),
                    LikeCount(
                      like: '32.1K',
                      name: 'Ali',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReactionCount extends StatelessWidget {
  final String comment;
  final String share;

  const ReactionCount({
    super.key,
    required this.comment,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${comment} Comments . ${share} Shares',
      style: CustomTextStyles.lightTextStyle(size: 8.25),
    );
  }
}

class LikeCount extends StatelessWidget {
  final String name;
  final String like;

  const LikeCount({
    super.key,
    required this.name,
    required this.like,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${name} & ${like} others',
          style: CustomTextStyles.lightTextStyle(size: 8.25),
        ),
        SizedBox(
          width: 1.w,
        ),
        SvgPicture.asset('Assets/icons/likereact.svg')
      ],
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyF78CgXqp5uX0g-SvGy4uLB2Qlg8Up3fhYYVlx9Vag&s'),
        ),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sheroze',
              style: CustomTextStyles.w600TextStyle(
                  size: 13.21, color: Color(0xff19295C)),
            ),
            Row(
              children: [
                SvgPicture.asset('Assets/icons/world.svg'),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  '2 Hours ago',
                  style: CustomTextStyles.lightTextStyle(size: 8.25),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class Heading extends StatelessWidget {
  final String title;

  const Heading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.w600TextStyle(size: 20, color: Color(0xff1F2A37)),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff4B5563), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          '1 New',
          style: CustomTextStyles.w600TextStyle(
              color: Color(0xffFFFFFF), size: 14),
        ),
      ),
    );
  }
}

class UserSlider extends StatelessWidget {
  final List<String> userNames;
  final List<String> userAssets;

  const UserSlider({
    Key? key,
    required this.userNames,
    required this.userAssets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: userNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(userAssets[index]),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    userNames[index],
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;

  const CircleButton({
    Key? key,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
