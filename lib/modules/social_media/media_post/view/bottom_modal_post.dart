import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/common/utils/file_selector.dart';
import 'package:joy_app/widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../bloc/medai_posts_bloc.dart';
import 'package:lottie/lottie.dart';

class CreatePostModal extends StatefulWidget {
  @override
  _CreatePostModalState createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final mediaController = Get.find<MediaPostController>();
  String? _selectedImage;
  final _profileController = Get.find<ProfileController>();
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter post description!';
                        } else {
                          return null;
                        }
                      },
                      controller: _descController,
                      enabled: true,
                      maxLines: null,
                      cursorColor: AppColors.borderColor,
                      style: CustomTextStyles.lightTextStyle(
                          color: AppColors.borderColor),
                      decoration: InputDecoration(
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.transparent,
                        hintText: "What's on your mind?",
                        hintStyle: CustomTextStyles.lightTextStyle(
                            color: AppColors.borderColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(54),
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff121212)
                          : AppColors.whiteColorf9f,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          _pickImage();
                        },
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
                    ),
                  )
                ],
              ),
              showLoader == true
                  ? Lottie.asset('Assets/animations/image_upload.json')
                  : Container(),
              (_selectedImage == null ||
                      _selectedImage!.isEmpty ||
                      showLoader == true)
                  ? Container()
                  : Center(
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80.w,
                        height: 43.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Image.network(
                          fit: BoxFit.cover,
                          _selectedImage!,
                        ),
                      ),
                    )),
              SizedBox(
                height: 2.h,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Obx(
                    () => RoundedButton(
                        showLoader: mediaController.postUpload.value,
                        text: 'Post',
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (!_formKey.currentState!.validate()) {
                          } else {
                            await mediaController.createPostByUser(
                                _descController.text,
                                _profileController.userId.value,
                                _selectedImage,
                                context);
                          }
                        },
                        backgroundColor: ThemeUtil.isDarkMode(context)
                            ? AppColors.lightBlueColor3e3
                            : Color(0xff1C2A3A),
                        textColor: AppColors.whiteColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final List<String?> paths = await pickSingleFile();
    if (paths.isNotEmpty) {
      final String path = await paths.first!;
      setState(() {
        showLoader = true;
      });
      String profileImg =
          await mediaController.uploadProfilePhoto(path, context);
      setState(() {
        showLoader = false;
        _selectedImage = profileImg;
      });
    }
  }
}
