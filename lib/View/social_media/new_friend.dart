import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';
import '../../Widgets/rounded_button.dart';
import '../../styles/custom_textstyle.dart';

class AddNewFriend extends StatelessWidget {
  const AddNewFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Add New Friends',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          child: Column(
            children: [
              RoundedSearchTextField(
                hintText: 'Search',
                controller: TextEditingController(),
                onChanged: (value) {
                  print('Search text changed: $value');
                },
              ),
              NewFriendRequestWidget(
                profileImage:
                    'https://s3-alpha-sig.figma.com/img/d200/c571/c4db6c37dba3a4e963acefe9ca469ec5?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N9Y-bU6XLqGWyk1r~2hcF0F5H5Tx4tqyZL2lVJlSfHNM1pGZhf6xs~X3CQGxBSXmHoxIe7sBZm2-tF65MSyMd-kBsxm2WGBdr~REbm407gcj1KdlGBfLTJP06jULqm-ltao7Nv24hFvqhdcKRJp2HiXDP07QZDMDOjNDHI4FbyX65zFMXfFVpXQCVy7sAIDRALQrg-ShD~Uep5chrTunJ5aKGD9lNJarzEURJ5q6-n6a7gb2WfNaiYrs4Xeh1FcBQZTzhc9NdyHqjAWHga6d41NrcRcMCmokLftUJgMhNWYB3aDKp3NApPXjHBis6UXpwG04NrC7ZnnLuNhPSOGsfg__',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                ],
                mutualFriendsCount: 3,
              ),
              SizedBox(
                height: 1.h,
              ),
              NewFriendRequestWidget(
                profileImage:
                    'https://s3-alpha-sig.figma.com/img/d200/c571/c4db6c37dba3a4e963acefe9ca469ec5?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N9Y-bU6XLqGWyk1r~2hcF0F5H5Tx4tqyZL2lVJlSfHNM1pGZhf6xs~X3CQGxBSXmHoxIe7sBZm2-tF65MSyMd-kBsxm2WGBdr~REbm407gcj1KdlGBfLTJP06jULqm-ltao7Nv24hFvqhdcKRJp2HiXDP07QZDMDOjNDHI4FbyX65zFMXfFVpXQCVy7sAIDRALQrg-ShD~Uep5chrTunJ5aKGD9lNJarzEURJ5q6-n6a7gb2WfNaiYrs4Xeh1FcBQZTzhc9NdyHqjAWHga6d41NrcRcMCmokLftUJgMhNWYB3aDKp3NApPXjHBis6UXpwG04NrC7ZnnLuNhPSOGsfg__',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                ],
                mutualFriendsCount: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewFriendRequestWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;

  const NewFriendRequestWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.mutualFriends,
    required this.mutualFriendsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffFAFAFA), borderRadius: BorderRadius.circular(22.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rounded Image
            ClipOval(
              child: Image.network(
                profileImage,
                width: 6.6.h,
                height: 6.6.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    userName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: Color(0xff19295C), size: 15),
                  ),

                  SizedBox(height: 0.5.h),
                  // Mutual Friends
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          mutualFriends.length,
                          (index) => ClipOval(
                            child: Image.network(
                              mutualFriends[index],
                              width: 1.9.h,
                              height: 1.9.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: Text(
                          '$mutualFriendsCount mutual friends',
                          style: CustomTextStyles.lightTextStyle(
                              size: 9.4, color: Color(0xff99A1BE)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            RoundedButtonSmall(
                text: "Add Friend",
                onPressed: () {},
                backgroundColor: Color(0xff1C2A3A),
                textColor: Color(0xffFFFFFF)),
          ],
        ),
      ),
    );
  }
}

class RoundedSearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  bool isEnable;

  RoundedSearchTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.onChanged,
      this.isEnable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(width: 5.w),

            SvgPicture.asset('Assets/icons/search-icon.svg'),
            //  Icon(leadingIcon),
            SizedBox(width: 1.w),
            Expanded(
              child: TextField(
                enabled: isEnable,
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    hintStyle: CustomTextStyles.lightSmallTextStyle(
                        color: Color(0xff9CA3AF), size: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
