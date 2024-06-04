import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/home/profile_screen.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/rounded_button.dart';
import 'editprofile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  bool? myProfile;
  MyProfileScreen({this.myProfile = false});
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
        showIcon: true,
        title: 'My Profile',
        actions: [
          InkWell(
            onTap: () {
              Get.to(EditProfile());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SvgPicture.asset('Assets/icons/edit-2.svg'),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ProfileScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SvgPicture.asset('Assets/icons/setting-2.svg'),
            ),
          )
        ],
        leading: InkWell(onTap: () {}, child: Icon(Icons.arrow_back)),
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              '1K',
                              style: CustomTextStyles.darkHeadingTextStyle(
                                  color: Color(0xff000000), size: 15.41),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              'Posts',
                              style: CustomTextStyles.lightTextStyle(
                                  color: Color(0xff000000), size: 13.21),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      AssetImage('Assets/images/onboard3.png')),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                'Sheroze Rehman',
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    size: 14),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              '2000',
                              style: CustomTextStyles.darkHeadingTextStyle(
                                  color: Color(0xff000000), size: 15.41),
                            ),
                            SizedBox(
                              height: 0.5.h,
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
                SizedBox(
                  height: 2.h,
                ),
                myProfile == true
                    ? Padding(
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
                      )
                    : Container(),
                myProfile == true ? SizedBox(height: 2.h) : Container(),
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
                UserSlider(userNames: userNames, userAssets: userAssets),
                Row(
                  children: [
                    Text(
                      'My Photos',
                      style: CustomTextStyles.darkHeadingTextStyle(),
                    ),
                    Spacer(),
                    Text(
                      'See All',
                      style: CustomTextStyles.lightSmallTextStyle(),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Image.asset('Assets/images/onboard1.png'),
                //     Column(
                //       children: [
                //         Image.asset('Assets/images/onboard1.png'),
                //         Image.asset('Assets/images/onboard1.png'),
                //       ],
                //     ),
                //   ],
                // ),

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
                SizedBox(
                  height: 1.h,
                ),

                MyCustomWidget(
                  isReply: true,
                  showImg: true,
                  text:
                      'Hey pals ! Had my third day of chemo. feeling much better.',
                ),
                SizedBox(
                  height: 3.h,
                ),
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
      height: 14.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(userAssets[index]),
                ),
                SizedBox(height: 1.h),
                Text(userNames[index],
                    style: CustomTextStyles.lightSmallTextStyle(
                        size: 9.4, color: Color(0xff99A1BE))),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;
  final String img;
  bool isActive;
  

  CircleButton(
      {Key? key,
      required this.color,
      this.onPressed,
      required this.img,
      this.isActive = false})
      : super(key: key);

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              img,
              color: isActive ? AppColors.whiteColor : Color(0xff1C2A3A),
            ),
          ),
        ),
      ),
    );
  }
}
