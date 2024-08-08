import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:http/http.dart' as http;
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:sizer/sizer.dart';

class MyCustomWidget extends StatefulWidget {
  bool? isReply;
  bool? showImg;
  String postName;
  String text;
  String imgPath;
  String recentName;
  String id;
  String postTime;
  String postId;
  String likeCount;
  bool isLiked;
  String userImage;
  int postIndex;
  List<Comments> cm;
  bool isHospital;

  MyCustomWidget(
      {this.isReply = false,
      this.showImg = true,
      this.text = '',
      required this.postTime,
      this.imgPath = '',
      this.likeCount = '',
      this.recentName = '',
      this.isLiked = false,
      required this.id,
      required this.postId,
      required this.postIndex,
      this.postName = '',
      required this.cm,
      this.userImage = '',
      this.isHospital = false});

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

final _profileController = Get.find<ProfileController>();
final TextEditingController comment = TextEditingController();
final mediaController = Get.find<MediaPostController>();

int? showCommentIndex;
bool? showComment;

class _MyCustomWidgetState extends State<MyCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Get.to(
                MyProfileScreen(
                    myProfile: widget.id == _profileController.userId.value
                        ? false
                        : true,
                    friendId: widget.id),
                transition: Transition.native);
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.userImage.contains('http')
                    ? widget.userImage.toString()
                    : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png"),
              ),
              SizedBox(width: 2.w), // Adjust as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postName.toString(),
                    style: CustomTextStyles.w600TextStyle(
                        letterspacing: 0.5,
                        size: 13.21,
                        color: ThemeUtil.isDarkMode(context)
                            ? AppColors.whiteColor
                            : Color(0xff19295C)),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('Assets/icons/world.svg'),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text(
                        getElapsedTime(widget.postTime),
                        style: CustomTextStyles.lightTextStyle(size: 8.25),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          widget.text.toString(),
          style: CustomTextStyles.lightTextStyle(
              color: ThemeUtil.isDarkMode(context) ? null : Color(0xff2D3F7B),
              size: 11.56),
        ),
        SizedBox(height: 1.h),
        widget.showImg == true
            ? Container(
                height: 20.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias, // Add this line
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.imgPath,
                  placeholder: (context, url) => Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: LoadingWidget(),
                  )),
                  errorWidget: (context, url, error) => Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ErorWidget(),
                  )),
                ),
              )
            : Container(),
        SizedBox(
          height: 1.h,
        ),
        ReactionCount(
          comment: widget.cm.length.toString(),
          share: '0',
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            InkWell(
              onTap: () {
                widget.isLiked = !widget.isLiked;
                setState(() {});
              },
              child: CircleButton(
                isLikeButton: true,
                isActive: widget.isLiked,
                img: 'Assets/images/like.png',
                // color: widget.isLiked
                //     ? ThemeUtil.isDarkMode(context)
                // ? Color(0xffC5D3E3)
                // : Color(0XFF1C2A3A)
                //     : Color(0xff121212),
                color: ThemeUtil.isDarkMode(context)
                    ? widget.isLiked
                        ? Color(0xffC5D3E3)
                        : Color(0xff121212)
                    : !widget.isLiked
                        ? Color(0xff121212)
                        : AppColors.whiteColorf9f,
              ),
            ),
//            SizedBox(width: 10),
            // InkWell(
            //   onTap: () {},
            //   child: CircleButton(
            //     isLikeButton: false,
            //     img: 'Assets/images/message.png',
            //     color: ThemeUtil.isDarkMode(context)
            //         ? Color(0xff121212)
            //         : AppColors.whiteColorf9f,
            //   ),
            // ),

            SizedBox(width: 10),
            InkWell(
              onTap: () async {
                if (widget.showImg == true) {
                  final url = await Uri.parse(widget.imgPath);
                  final response = await http.get(url);
                  final bytes = await response.bodyBytes;
                  final temp = await getTemporaryDirectory();
                  final path = '${temp.path}/image.jpg';
                  File(path).writeAsBytesSync(bytes);
                  await Share.shareXFiles([XFile('${temp.path}/image.jpg')],
                      text: widget.text.toString() +
                          '\n\n posted by ${widget.postName} on Joy App \n\n Download App to see the latest post available on Apple Store and Google Play Store');
                } else {
                  final byteData =
                      await rootBundle.load('Assets/images/app-icon.png');
                  final bytes = byteData.buffer.asUint8List();
                  final temp = await getTemporaryDirectory();
                  final path = '${temp.path}/local_image.jpg';
                  File(path).writeAsBytesSync(bytes);
                  await Share.shareXFiles(
                      [XFile('${temp.path}/local_image.jpg')],
                      text: widget.text.toString() +
                          '\n\n posted by ${widget.postName} on Joy App \n\n Download App to see the latest post available on Apple Store and Google Play Store');

                  //await Share.share(widget.text.toString() +
                  //  '\n\n posted by ${widget.postName} on Joy App \n\n Download App to see the latest post available on Apple Store and Google Play Store');
                }
              },
              child: CircleButton(
                isLikeButton: false,
                img: 'Assets/images/send.png',
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff121212)
                    : AppColors.whiteColorf9f,
              ),
            ),
            Spacer(),
            // LikeCount(
            //   like: '32.1K',
            //   name: 'Ali',
            // ),
            Divider(
              color: Color(0xffE5E7EB),
            ),
          ],
        ),
        SizedBox(
          height: 1.h,
        ),
        RoundedCommentTextField(
          controller: comment,
          hintText: 'Add comment',
          onSendPressed: () async {
            FocusScope.of(context).unfocus();
            mediaController
                .commentAdd(
                    widget.postId, comment.text, context, widget.postIndex)
                .then((value) {
              setState(() {});
            });
            comment.clear();
          },
        ),
        SizedBox(
          height: 1.5.h,
        ),
        (widget.cm.length > 0)
            ? Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.isHospital
                    ? widget.postIndex == showCommentIndex
                        ? mediaController
                            .postsByUserId[widget.postIndex].comments!.length
                        : mediaController.postsByUserId[widget.postIndex]
                                    .comments!.length <
                                4
                            ? mediaController.postsByUserId[widget.postIndex]
                                .comments!.length
                            : 3
                    : widget.postIndex == showCommentIndex
                        ? mediaController
                            .allPost[widget.postIndex].comments!.length
                        : mediaController.allPost[widget.postIndex].comments!
                                    .length <
                                4
                            ? mediaController
                                .allPost[widget.postIndex].comments!.length
                            : 3,
                itemBuilder: ((context, index) {
                  final commen = widget.cm[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 13,
                          backgroundImage: NetworkImage(
                            "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                          )),
                      SizedBox(width: 2.w), // Adjust as needed

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commen.name.toString(),
                              style: CustomTextStyles.w600TextStyle(
                                  letterspacing: 0.5,
                                  size: 13.21,
                                  color: ThemeUtil.isDarkMode(context)
                                      ? AppColors.whiteColor
                                      : Color(0xff19295C)),
                            ),
                            Text(
                              commen.comment.toString(),
                              style:
                                  CustomTextStyles.lightTextStyle(size: 11.28),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              children: [
                                Text('Like',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            size: 10,
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xffC9C9C9)
                                                : Color(0xff60709D))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Text('Reply',
                                      style:
                                          CustomTextStyles.darkHeadingTextStyle(
                                              size: 10,
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xffC9C9C9)
                                                      : Color(0xff60709D))),
                                ),
                                Text(
                                    getElapsedTime(commen.createdAt.toString()),
                                    style: CustomTextStyles.lightTextStyle(
                                        size: 10,
                                        color: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC9C9C9)
                                            : Color(0xff60709D)))
                              ],
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      )
                    ],
                  );
                })))
            : Container(),
        (showCommentIndex == widget.postIndex)
            ? Container()
            : (widget.cm.length > 3)
                ? InkWell(
                    onTap: () {
                      showCommentIndex = widget.postIndex;
                      setState(() {});
                    },
                    child: Text(
                      (widget.cm.length - 3).toString() + ' comment',
                      style: CustomTextStyles.lightTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? null
                              : Color(0xff2D3F7B),
                          size: 11.56),
                    ),
                  )
                : Container(),
        SizedBox(height: 2.h),
      ],
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Color.fromARGB(137, 187, 181, 181),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
              )),
          SizedBox(width: 2.w), // Adjust as needed
          SizedBox(
            height: 2.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1.h,
                width: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 1.h,
                width: 20.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 20.h,
                width: 100.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
              ),
              SizedBox(height: 1.h),
            ],
          )
        ],
      ),
    );
  }
}
