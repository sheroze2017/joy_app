import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/profile_form.dart';
import 'package:joy_app/modules/user/user_hospital/view/hospital_detail_screen.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';
import '../bloc/doctor_bloc.dart';
import '../models/doctor_detail_model.dart';

class DoctorDetailScreen extends StatelessWidget {
  final String docName;
  final String location;
  final String Category;
  bool isDoctor;

  DoctorDetailScreen(
      {super.key,
      required this.docName,
      required this.location,
      required this.Category,
      this.isDoctor = false});

  DoctorController _doctorController = Get.find<DoctorController>();
  
  Widget _buildDoctorAvatar(String? imageUrl, BuildContext context) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab') &&
        !imageUrl.contains('194.233.69.219');
    
    if (isValidUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl.trim(),
        width: 27.9.w,
        height: 27.9.w,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 27.9.w,
          height: 27.9.w,
          decoration: BoxDecoration(
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff2A2A2A)
                : Color(0xffE5E5E5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            Icons.person,
            size: 15.w,
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff5A5A5A)
                : Color(0xffA5A5A5),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 27.9.w,
          height: 27.9.w,
          decoration: BoxDecoration(
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff2A2A2A)
                : Color(0xffE5E5E5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            Icons.person,
            size: 15.w,
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff5A5A5A)
                : Color(0xffA5A5A5),
          ),
        ),
      );
    }
    return Container(
      width: 27.9.w,
      height: 27.9.w,
      decoration: BoxDecoration(
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Icon(
        Icons.person,
        size: 15.w,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final data = _doctorController.doctorDetail!.data;

    return Scaffold(
      appBar: HomeAppBar(
          bgColor: ThemeUtil.isDarkMode(context)
              ? Color(0xff1B1B1B)
              : AppColors.lightishBlueColorebf,
          title: isDoctor ? 'Your Profile' : 'Doctor Details',
          leading: Icon(Icons.arrow_back),
          actions: isDoctor ? [] : [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'Assets/icons/favourite.svg',
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : null,
                  )),
            )
          ],
          showIcon: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        ThemeUtil.isDarkMode(context)
                            ? BoxShadow()
                            : BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                      ],
                      color: ThemeUtil.isDarkMode(context)
                          ? Color(0xff1B1B1B)
                          : AppColors.lightishBlueColorebf,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: _buildDoctorAvatar(data!.image, context),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name.toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffC8D3E0)
                                                      : null),
                                        ),
                                        Divider(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff1F2228)
                                              : Color(0XFFE5E7EB),
                                        ),
                                        Text(
                                          data.expertise?.toString() ?? data.qualifications?.toString() ?? '',
                                          style: CustomTextStyles.w600TextStyle(
                                              size: 14,
                                              color: Color(0xff4B5563)),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                'Assets/icons/location.svg'),
                                            SizedBox(
                                              width: 0.5.w,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  data.location.toString(),
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                          color:
                                                              Color(0xff4B5563),
                                                          size: 14)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedSVGContainer(
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/profile-2user.svg',
                                  numberText: data.totalPatients != null 
                                      ? '${data.totalPatients}+' 
                                      : '0',
                                  isDoctor: true,
                                  descriptionText: 'Patients',
                                ),
                                RoundedSVGContainer(
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/star.svg',
                                  numberText: _calculateAverageRating(data.reviews ?? []).toStringAsFixed(1),
                                  isDoctor: true,
                                  descriptionText: 'rating',
                                ),
                                RoundedSVGContainer(
                                  isDoctor: true,
                                  bgColor: AppColors.lightishBlueColorebf,
                                  iconColor: Color(0xff023477),
                                  svgAsset: 'Assets/icons/messages.svg',
                                  numberText: (data.reviews?.length ?? 0).toString(),
                                  descriptionText: 'reviews',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          Heading(
                            title: 'About me',
                          ),
                          SizedBox(height: 1.h),
                          Text(
                              data.aboutMe?.toString() ?? '',
                              style: CustomTextStyles.lightTextStyle(size: 14)),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Working Time',
                          ),
                          SizedBox(height: 1.h),
                          _buildWorkingTime(data.availability ?? []),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Appointment Cost',
                          ),
                          SizedBox(height: 1.h),
                          Obx(() => Text(
                              '${_doctorController.doctorDetail!.data!.consultationFee!.toString()} for 1 Hour Consultation',
                              style:
                                  CustomTextStyles.lightTextStyle(size: 14))),
                          SizedBox(height: 1.5.h),
                          Heading(
                            title: 'Reviews',
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 2.h),
                              Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _doctorController.doctorDetail!
                                          .data?.reviews?.length ??
                                      0,
                                  itemBuilder: ((context, index) {
                                    final data = _doctorController
                                        .doctorDetail!.data?.reviews?[index];
                                    if (data == null) return SizedBox.shrink();
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: UserRatingWidget(
                                        image: data.giveBy?.image,
                                        docName: data.giveBy?.name ?? 'Unknown',
                                        reviewText: data.review ?? '',
                                        rating: data.rating,
                                      ),
                                    );
                                  })))
                            ],
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: new FractionalOffset(.5, 1.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RoundedButton(
                      text: isDoctor ? 'Edit Profile' : "Book Appointment",
                      onPressed: () {
                        isDoctor
                            ? Get.to(
                                DoctorFormScreen(
                                  email: data.email.toString(),
                                  password: data.password.toString(),
                                  name: data.name.toString(),
                                  details: data,
                                  isEdit: true,
                                ),
                                transition: Transition.native)
                            : null;
                      },
                      backgroundColor: AppColors.darkBlueColor,
                      textColor: AppColors.whiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  double _calculateAverageRating(List<Reviews>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0.0;
    double total = 0.0;
    for (var review in reviews) {
      if (review.rating != null) {
        if (review.rating is int) {
          total += (review.rating as int).toDouble();
        } else if (review.rating is double) {
          total += review.rating as double;
        } else if (review.rating is String) {
          total += double.tryParse(review.rating as String) ?? 0.0;
        }
      }
    }
    return total / reviews.length;
  }
  
  Widget _buildWorkingTime(List<Availability>? availability) {
    if (availability == null || availability.isEmpty) {
      return Text(
        'No working hours available',
        style: CustomTextStyles.lightTextStyle(size: 14),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: availability.map((avail) {
        final times = avail.times ?? '';
        final day = avail.day ?? '';
        return Padding(
          padding: EdgeInsets.only(bottom: 0.5.h),
          child: Text(
            '$day: $times',
            style: CustomTextStyles.lightTextStyle(size: 14),
          ),
        );
      }).toList(),
    );
  }
}
