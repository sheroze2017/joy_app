import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
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
    List<String> userNames = [
      'Erina',
      'Willia',
      'Millie',
      'Rachael',
      'Kate m.'
    ];
    List<String> userAssets = [
      'https://s3-alpha-sig.figma.com/img/2e2c/f1b6/f441c6f28c3b0e1e0eb4863eb80b7401?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OyHaSwq3RQUwqVyFeX-s0TPwdVl3MyspHk4ha5TuocQQlfrZslhYWSc0Dt6SNY9t8cBucIE9M-yN0wL4hIMWEXnjcUoXiCV0qSnDl0PdCg6csLGUvC54HxbCR13nV9CWzIjXJ1GTEEwezdirXYAo8zxUvxA~NfBU7JSFvNku~xEBKBuiaejwOZBVcCIr-ZugxpQNLEPAfnKBubrSY3OLD3Ab6hS1pt-kZbX55g3efEA7Qea~PVNIYAgyl56P6nWFMYcxOBc560XVAtXCYszZSwyo-pVi1V5lnCW1fAr1xzQ4mAlrDUEQ0AS9RrS~shD4coWqimFOAN2KuBN6k~dMuA__',
      'https://s3-alpha-sig.figma.com/img/2e2c/f1b6/f441c6f28c3b0e1e0eb4863eb80b7401?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OyHaSwq3RQUwqVyFeX-s0TPwdVl3MyspHk4ha5TuocQQlfrZslhYWSc0Dt6SNY9t8cBucIE9M-yN0wL4hIMWEXnjcUoXiCV0qSnDl0PdCg6csLGUvC54HxbCR13nV9CWzIjXJ1GTEEwezdirXYAo8zxUvxA~NfBU7JSFvNku~xEBKBuiaejwOZBVcCIr-ZugxpQNLEPAfnKBubrSY3OLD3Ab6hS1pt-kZbX55g3efEA7Qea~PVNIYAgyl56P6nWFMYcxOBc560XVAtXCYszZSwyo-pVi1V5lnCW1fAr1xzQ4mAlrDUEQ0AS9RrS~shD4coWqimFOAN2KuBN6k~dMuA__',
      'https://s3-alpha-sig.figma.com/img/504b/c691/102d8a6217d1fc1f8e79a810b1842a0d?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Yd7Pi3bm~RQDDgnpWNarZdcqX5a-J9FbtvT63l5XLxLN2VSsDsMVn2kT2mb1PsKdZlBieZoJ6XoRVzDA~UkcqvdHMvd35qVGVR26M~DEOLWuWmbAmiCuq6KmQFurraqQxFoVQ9nI1GOJ5daoBF115ufImWcW6APxDftNToo2AszZ55MZssJ1Gxh9z7XoyxPTLuXsnPQ45vZ3bqRS7z20isaNyxI2eX1~6G2B7rFkMPpAv~opNaU9OxxN1NGq~9n-~0dVqZgzAM97ASPb-6h88Toavx4XLF7Mx4bp~RGj~mUdPpuc4hdFJnuGBjemLR1OBK4Ku-3J16V5DuHxXsK3FQ__',
      'https://s3-alpha-sig.figma.com/img/2e2c/f1b6/f441c6f28c3b0e1e0eb4863eb80b7401?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OyHaSwq3RQUwqVyFeX-s0TPwdVl3MyspHk4ha5TuocQQlfrZslhYWSc0Dt6SNY9t8cBucIE9M-yN0wL4hIMWEXnjcUoXiCV0qSnDl0PdCg6csLGUvC54HxbCR13nV9CWzIjXJ1GTEEwezdirXYAo8zxUvxA~NfBU7JSFvNku~xEBKBuiaejwOZBVcCIr-ZugxpQNLEPAfnKBubrSY3OLD3Ab6hS1pt-kZbX55g3efEA7Qea~PVNIYAgyl56P6nWFMYcxOBc560XVAtXCYszZSwyo-pVi1V5lnCW1fAr1xzQ4mAlrDUEQ0AS9RrS~shD4coWqimFOAN2KuBN6k~dMuA__',
      'https://s3-alpha-sig.figma.com/img/2e2c/f1b6/f441c6f28c3b0e1e0eb4863eb80b7401?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OyHaSwq3RQUwqVyFeX-s0TPwdVl3MyspHk4ha5TuocQQlfrZslhYWSc0Dt6SNY9t8cBucIE9M-yN0wL4hIMWEXnjcUoXiCV0qSnDl0PdCg6csLGUvC54HxbCR13nV9CWzIjXJ1GTEEwezdirXYAo8zxUvxA~NfBU7JSFvNku~xEBKBuiaejwOZBVcCIr-ZugxpQNLEPAfnKBubrSY3OLD3Ab6hS1pt-kZbX55g3efEA7Qea~PVNIYAgyl56P6nWFMYcxOBc560XVAtXCYszZSwyo-pVi1V5lnCW1fAr1xzQ4mAlrDUEQ0AS9RrS~shD4coWqimFOAN2KuBN6k~dMuA__',
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
                Container(
                  height: 45.w,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: 100.w,
                            height: 23.58.w,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Colors.transparent
                                        : Color(0xffF3F4F6)),
                                color: ThemeUtil.isDarkMode(context)
                                    ? Color(0xff121212)
                                    : Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 4.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1K',
                                      style:
                                          CustomTextStyles.darkHeadingTextStyle(
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors.whiteColor
                                                      : Color(0xff000000),
                                              size: 15.41),
                                    ),
                                    Text(
                                      'Posts',
                                      style: CustomTextStyles.lightTextStyle(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? AppColors.whiteColor
                                              : Color(0xff000000),
                                          size: 13.21),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '2000',
                                      style:
                                          CustomTextStyles.darkHeadingTextStyle(
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? AppColors.whiteColor
                                                      : Color(0xff000000),
                                              size: 15.41),
                                    ),
                                    Text(
                                      'Friends',
                                      style: CustomTextStyles.lightTextStyle(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? AppColors.whiteColor
                                              : Color(0xff000000),
                                          size: 13.21),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
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
                                  color: ThemeUtil.isDarkMode(context)
                                      ? Color(0xffC8D3E0)
                                      : null,
                                  size: 14),
                            )
                          ],
                        ),
                      )
                    ],
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
                                  backgroundColor: ThemeUtil.isDarkMode(context)
                                      ? Color(0XFF1F2228)
                                      : Color(0xffE5E7EB),
                                  textColor: ThemeUtil.isDarkMode(context)
                                      ? Color(0XFFC5D3E3)
                                      : Color(0xff1C2A3A)),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Expanded(
                              child: RoundedButtonSmall(
                                  isSmall: true,
                                  text: "Add Friend",
                                  onPressed: () {},
                                  backgroundColor: ThemeUtil.isDarkMode(context)
                                      ? Color(0XFFC5D3E3)
                                      : Color(0xff1C2A3A),
                                  textColor: ThemeUtil.isDarkMode(context)
                                      ? AppColors.blackColor
                                      : Color(0xffFFFFFF)),
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
                  "I’m Alexa David, diagnosed with Cancer last year. Starting getting chemotherapeutic treatment and now i’m getting better day by day.",
                  textAlign: TextAlign.justify,
                  style: CustomTextStyles.lightTextStyle(
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xffAAAAAA)
                          : null),
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
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : null),
                    ),
                    Spacer(),
                    Text(
                      'See All',
                      style: CustomTextStyles.lightSmallTextStyle(),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 49.52.w,
                        height: 47.9.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            'https://s3-alpha-sig.figma.com/img/3bde/5fa1/9ddfb5ff7fe8cb0e46e8a057916c84ea?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Eu01T1nSUTUea~6s6LseRnloN5KBWlYEStHvRAK6phG87NaLGOxwljNisAs~ge8K2O3NcT~hOUYa6oWt2EiftirxGlx2JhHdzJzgFDnjsBsEIFBa-zVoBUNK5br86ws~G2iGSwWeleJN0dfLpxTx9lMXLtregG7CEWr748ysqVEn96XkW~UbEdZTPf1CyVOGI1nnQ6sbsTe2cBRNFbKSl0mXw7nJUzbK8R~xm3z0L-lfFfctbNLcluO78d5wmu4Sjw9oUslC77XXvJB~9pucZnAvADWnmvY1bCVjAqF7LLw5dUMsVp2q0ma8CeN3H~FvuGj4ATwwEan-N0ncl-of2g__',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 35.5.w,
                            height: 22.8.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                'https://s3-alpha-sig.figma.com/img/3bde/5fa1/9ddfb5ff7fe8cb0e46e8a057916c84ea?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Eu01T1nSUTUea~6s6LseRnloN5KBWlYEStHvRAK6phG87NaLGOxwljNisAs~ge8K2O3NcT~hOUYa6oWt2EiftirxGlx2JhHdzJzgFDnjsBsEIFBa-zVoBUNK5br86ws~G2iGSwWeleJN0dfLpxTx9lMXLtregG7CEWr748ysqVEn96XkW~UbEdZTPf1CyVOGI1nnQ6sbsTe2cBRNFbKSl0mXw7nJUzbK8R~xm3z0L-lfFfctbNLcluO78d5wmu4Sjw9oUslC77XXvJB~9pucZnAvADWnmvY1bCVjAqF7LLw5dUMsVp2q0ma8CeN3H~FvuGj4ATwwEan-N0ncl-of2g__',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            width: 35.5.w,
                            height: 22.8.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                'https://s3-alpha-sig.figma.com/img/3bde/5fa1/9ddfb5ff7fe8cb0e46e8a057916c84ea?Expires=1719792000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Eu01T1nSUTUea~6s6LseRnloN5KBWlYEStHvRAK6phG87NaLGOxwljNisAs~ge8K2O3NcT~hOUYa6oWt2EiftirxGlx2JhHdzJzgFDnjsBsEIFBa-zVoBUNK5br86ws~G2iGSwWeleJN0dfLpxTx9lMXLtregG7CEWr748ysqVEn96XkW~UbEdZTPf1CyVOGI1nnQ6sbsTe2cBRNFbKSl0mXw7nJUzbK8R~xm3z0L-lfFfctbNLcluO78d5wmu4Sjw9oUslC77XXvJB~9pucZnAvADWnmvY1bCVjAqF7LLw5dUMsVp2q0ma8CeN3H~FvuGj4ATwwEan-N0ncl-of2g__',
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Text(
                      'My Posts',
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? Color(0xffC5D3E3)
                              : null),
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
                  postName: 'Sheroze',
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
                  size: 13.21,
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xffFFFFFF)
                      : Color(0xff19295C)),
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
      style: CustomTextStyles.w600TextStyle(
          size: 20,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xffC8D3E0)
              : Color(0xff1F2A37)),
    );
  }
}

class SubHeading extends StatelessWidget {
  final String title;

  const SubHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: CustomTextStyles.lightSmallTextStyle(
          size: 14,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xffC8D3E0)
              : Color(0xff1F2A37)),
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
                  backgroundImage: NetworkImage(userAssets[index]),
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
  bool isLikeButton;

  CircleButton(
      {Key? key,
      required this.color,
      this.onPressed,
      required this.img,
      this.isActive = false,
      this.isLikeButton = false})
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
              color: isLikeButton
                  ? (isActive || !isLikeButton)
                      ? Color(0xff1C2A3A)
                      : Color(0xFFC5D3E3)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
