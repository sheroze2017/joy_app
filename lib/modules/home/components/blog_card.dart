import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/core/network/utils/extra.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/loader/loader.dart';
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
  static const String _defaultPostImage = 'Assets/images/app-icon.png';

  bool _isValidImageUrl(String? url) {
    return url != null &&
        url.trim().isNotEmpty &&
        url.trim().toLowerCase() != 'null';
  }

  Widget _buildAvatarWidget(String? url, double radius, BuildContext context) {
    if (_isValidImageUrl(url)) {
      return ClipOval(
        child: Image.network(
          url!.trim(),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff2A2A2A)
                    : Color(0xffE5E5E5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: radius,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff2A2A2A)
          : Color(0xffE5E5E5),
      child: Icon(
        Icons.person,
        size: radius,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  Widget _buildCommentsList(List<Comments> commentsList, BuildContext context) {
    if (commentsList.isEmpty) {
      return SizedBox.shrink();
    }
    
    final itemCount = widget.postIndex == showCommentIndex
        ? commentsList.length
        : commentsList.length < 4
            ? commentsList.length
            : 3;
    
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: ((context, index) {
          final commen = commentsList[index];
          final commenterName = (commen.name ?? commen.user?.name ?? '')
                  .trim()
                  .isEmpty
              ? 'User'
              : (commen.name ?? commen.user?.name ?? '');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarWidget(
                  commen.userImage ?? commen.user?.image, 13, context),
              SizedBox(width: 2.w), // Adjust as needed

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commenterName,
                      style: CustomTextStyles.w600TextStyle(
                          letterspacing: 0.5,
                          size: 13.21,
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : Color(0xff19295C)),
                    ),
                    Text(
                      commen.comment ?? '',
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
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    final postOwnerName =
        widget.postName.trim().isEmpty ? 'User' : widget.postName;
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
              _buildAvatarWidget(widget.userImage, 25, context),
              SizedBox(width: 2.w), // Adjust as needed
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postOwnerName,
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
                clipBehavior: Clip.antiAlias,
                child: Builder(builder: (context) {
                  final postImageUrl = widget.imgPath.trim();
                  final hasValidUrl = postImageUrl.isNotEmpty &&
                      postImageUrl.toLowerCase() != 'null';
                  if (!hasValidUrl) {
                    return Image.asset(
                      _defaultPostImage,
                      fit: BoxFit.cover,
                    );
                  }
                  return CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: postImageUrl,
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
                  );
                }),
              )
            : Container(),
        SizedBox(
          height: 1.h,
        ),
        Text(
          '${widget.cm.length} Comments',
          style: CustomTextStyles.lightTextStyle(size: 8.25),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            InkWell(
              onTap: () async {
                // Call togglePostLike API
                final mediaController = Get.find<MediaPostController>();
                bool success = await mediaController.toggleLike(
                  widget.postId,
                  widget.postIndex,
                  context,
                );
                if (success) {
                  // Update local state after successful API call
                  widget.isLiked = !widget.isLiked;
                  setState(() {});
                }
              },
              child: CircleButton(
                isLikeButton: true,
                isActive: widget.isLiked,
                img: 'Assets/images/like.png',
                color: ThemeUtil.isDarkMode(context)
                    ? widget.isLiked
                        ? Color(0xffC5D3E3)
                        : Color(0xff121212)
                    : !widget.isLiked
                        ? Color(0xff121212)
                        : AppColors.whiteColorf9f,
              ),
            ),
            Spacer(),
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
        // For hospital mode, use regular widget (not Obx) since widget.cm is not reactive
        widget.isHospital
            ? _buildCommentsList(widget.cm, context)
            : Obx(() {
                // For non-hospital mode, use reactive controller lists
                final commentsList = mediaController.postsByUserId.length > widget.postIndex
                    ? (mediaController.postsByUserId[widget.postIndex].comments ?? widget.cm)
                    : (mediaController.allPost.reversed.toList().length > widget.postIndex
                        ? (mediaController.allPost.reversed.toList()[widget.postIndex].comments ?? widget.cm)
                        : widget.cm);
                
                return _buildCommentsList(commentsList, context);
              }),
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
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff2A2A2A)
                  : Color(0xffE5E5E5),
              child: Icon(
                Icons.person,
                size: 15,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
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
