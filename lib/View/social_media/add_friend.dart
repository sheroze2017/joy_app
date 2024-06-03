import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/view/social_media/new_friend.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../../Widgets/custom_appbar.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        title: 'Friend Requests',
        leading: Text(''),
        showIcon: false,
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          child: Column(
            children: [
              countRequest(
                title: 'Requests',
                requestCount: ' (331)',
                showCount: true,
              ),
              FriendRequestWidget(
                profileImage:
                    'https://s3-alpha-sig.figma.com/img/d200/c571/c4db6c37dba3a4e963acefe9ca469ec5?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N9Y-bU6XLqGWyk1r~2hcF0F5H5Tx4tqyZL2lVJlSfHNM1pGZhf6xs~X3CQGxBSXmHoxIe7sBZm2-tF65MSyMd-kBsxm2WGBdr~REbm407gcj1KdlGBfLTJP06jULqm-ltao7Nv24hFvqhdcKRJp2HiXDP07QZDMDOjNDHI4FbyX65zFMXfFVpXQCVy7sAIDRALQrg-ShD~Uep5chrTunJ5aKGD9lNJarzEURJ5q6-n6a7gb2WfNaiYrs4Xeh1FcBQZTzhc9NdyHqjAWHga6d41NrcRcMCmokLftUJgMhNWYB3aDKp3NApPXjHBis6UXpwG04NrC7ZnnLuNhPSOGsfg__',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                ],
                mutualFriendsCount: 34,
              ),
              SizedBox(
                height: 1.h,
              ),
              FriendRequestWidget(
                profileImage:
                    'https://s3-alpha-sig.figma.com/img/d200/c571/c4db6c37dba3a4e963acefe9ca469ec5?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=N9Y-bU6XLqGWyk1r~2hcF0F5H5Tx4tqyZL2lVJlSfHNM1pGZhf6xs~X3CQGxBSXmHoxIe7sBZm2-tF65MSyMd-kBsxm2WGBdr~REbm407gcj1KdlGBfLTJP06jULqm-ltao7Nv24hFvqhdcKRJp2HiXDP07QZDMDOjNDHI4FbyX65zFMXfFVpXQCVy7sAIDRALQrg-ShD~Uep5chrTunJ5aKGD9lNJarzEURJ5q6-n6a7gb2WfNaiYrs4Xeh1FcBQZTzhc9NdyHqjAWHga6d41NrcRcMCmokLftUJgMhNWYB3aDKp3NApPXjHBis6UXpwG04NrC7ZnnLuNhPSOGsfg__',
                userName: 'Jim Hopper',
                mutualFriends: [
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                  'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                ],
                mutualFriendsCount: 34,
              ),
              SizedBox(
                height: 2.h,
              ),
              countRequest(
                title: 'People you may know',
                requestCount: '',
                showCount: false,
              ),
              Container(
                child: Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return AddFriendWidget(
                          profileImage: 'https://via.placeholder.com/50',
                          userName: 'Sheroze Rehman',
                          mutualFriends: [
                            'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                            'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                            'https://s3-alpha-sig.figma.com/img/6ec9/4186/cc6e3e60f69ecac1443984f93e6078eb?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aKFiRVmZKAXGKoZbAAC7VvnYHXDphd0IBXkz1BC~JQrvHCeH84~SuipUHO2QuWvPZ2QiDAEoyersbSLNl3SGq3kMFxIv-Nkhoinx5C-pkinmDt1yavaOCD6O-rbRsxayfCnvsrJIQ5240qDsqvLQeeHRZyHltZ6bWFvh-vKkwrgfi5m9T37iXrMdCUfSH8IunN97m~i6rHOa0FClmP7p5GJERgG6l-akaRBwpirolS3Luja4M34z44wtIb5WT~CsrLD7jfUf5XBj9QFzYGaES2Bzx40~6B~n5dI6MOqiy6rboFeXeoY5OOPNYpb93FHiXF2MugCPfu1Dh6~t1EpYbA__',
                          ],
                          mutualFriendsCount: 5,
                          onRemove: () {},
                          onAddFriend: () {});
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class countRequest extends StatelessWidget {
  final String requestCount;
  final bool showCount;
  final String title;

  const countRequest(
      {super.key,
      required this.requestCount,
      required this.showCount,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: CustomTextStyles.lightSmallTextStyle(
              color: Color(0xff19295C), size: 18),
        ),
        Text(
          showCount ? ' ${requestCount}' : '',
          style: CustomTextStyles.w600TextStyle(color: Colors.red, size: 14),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Get.to(AddNewFriend());
          },
          child: Text(
            'See all',
            style: CustomTextStyles.w600TextStyle(
                color: Color(0xff1C2A3A), size: 14),
          ),
        )
      ],
    );
  }
}

class FriendRequestWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;

  const FriendRequestWidget({
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
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
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 1.w),
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
            Column(
              children: [
                RoundedButtonSmall(
                    text: "Accept",
                    onPressed: () {},
                    backgroundColor: Color(0xff1C2A3A),
                    textColor: Color(0xffFFFFFF)),
                SizedBox(
                  width: 4.w,
                ),
                RoundedButtonSmall(
                    text: "Reject",
                    onPressed: () {},
                    backgroundColor: Color(0xffF1F4F5),
                    textColor: Color(0xff1C2A3A))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddFriendWidget extends StatelessWidget {
  final String profileImage;
  final String userName;
  final List<String> mutualFriends;
  final int mutualFriendsCount;
  final Function() onRemove;
  final Function() onAddFriend;

  const AddFriendWidget({
    Key? key,
    required this.profileImage,
    required this.userName,
    required this.mutualFriends,
    required this.mutualFriendsCount,
    required this.onRemove,
    required this.onAddFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 46.15.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24), color: Color(0xffFAFAFA)),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(children: [
            Positioned(
              top: -10,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 1.5.h,
                ),
                onPressed: onRemove,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: Image.network(
                        profileImage,
                        width: 6.6.h,
                        height: 6.6.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Positioned(
                    //     bottom: 5,
                    //     right: -10,
                    //     child: Container(
                    //       width: 8.w,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: Center(
                    //           child: Text(
                    //             'NEW',
                    //             style: CustomTextStyles.w600TextStyle(
                    //                 color: Colors.white, size: 6),
                    //           ),
                    //         ),
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: Color(0xff1C2A3A),
                    //         borderRadius: BorderRadius.circular(20),
                    //       ),
                    //     ))
                  ],
                ),
                Center(
                  child: Text(
                    userName,
                    style: CustomTextStyles.darkHeadingTextStyle(
                        color: Color(0xff19295C), size: 15),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      '$mutualFriendsCount mutual friends',
                      style: CustomTextStyles.lightTextStyle(
                          size: 9.4, color: Color(0xff99A1BE)),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButtonSmall(
                          text: 'Add Friend',
                          onPressed: () {},
                          backgroundColor: Color(0xff1C2A3A),
                          textColor: Color(0xFFFFFFFF)),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
              ],
            ),
          ])),
    );
  }
}
