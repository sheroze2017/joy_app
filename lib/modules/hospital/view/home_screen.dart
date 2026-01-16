import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/hospital/view/all_doc_pharmacy.dart';
import 'package:joy_app/modules/hospital/model/hospital_detail_model.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/social_media/media_post/model/media_post.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/location_widget.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/reviewbar_widget.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/product_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/home/components/blog_card.dart';
import 'package:joy_app/modules/user/user_hospital/view/all_hospital_screen.dart';
import 'package:joy_app/modules/pharmacy/view/pharmacy_product_screen.dart';
import 'package:joy_app/widgets/dailog/confirmation_dailog.dart';
import 'package:joy_app/widgets/loader/loader.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import '../../../common/profile/view/my_profile.dart';
import '../../user/user_hospital/view/hospital_detail_screen.dart';
import '../../social_media/chat/view/chats.dart';
import 'doctor_all_post.dart';
import '../../../common/profile/bloc/profile_bloc.dart';

class HospitalHomeScreen extends StatefulWidget {
  bool isHospital;
  bool isUser;
  String? hospitalId;
  Hospital? hospitalDetail;

  HospitalHomeScreen(
      {this.isHospital = false,
      this.isUser = false,
      this.hospitalId = '1',
      this.hospitalDetail});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  final _hospitalDetailController = Get.find<HospitalDetailController>();
  final _pharmacyController = Get.put(AllPharmacyController());
  UserDoctorController _userDoctorController = Get.put(UserDoctorController());
  final mediaController = Get.find<MediaPostController>();
  final _profileController = Get.find<ProfileController>();

  Widget _buildPharmacyImage(dynamic pharmacy, BuildContext context) {
    String? imageUrl;
    if (pharmacy is HospitalPharmacy) {
      imageUrl = pharmacy.image;
    } else if (pharmacy is PharmacyModelData) {
      imageUrl = pharmacy.image;
    }

    final hasValidImage = imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (hasValidImage) {
      return Image.network(
        imageUrl!,
        width: 28.w,
        height: 28.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 28.w,
            height: 28.w,
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff2A2A2A)
                : Color(0xffE5E5E5),
            child: Icon(
              Icons.local_pharmacy,
              size: 20,
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff5A5A5A)
                  : Color(0xffA5A5A5),
            ),
          );
        },
      );
    } else {
      return Container(
        width: 28.w,
        height: 28.w,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        child: Icon(
          Icons.local_pharmacy,
          size: 20,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff5A5A5A)
              : Color(0xffA5A5A5),
        ),
      );
    }
  }

  Widget _buildPharmacyImageForHorizontal(
      dynamic pharmacy, BuildContext context) {
    String? imageUrl;
    if (pharmacy is HospitalPharmacy) {
      imageUrl = pharmacy.image;
    } else if (pharmacy is PharmacyModelData) {
      imageUrl = pharmacy.image;
    }

    final hasValidImage = imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    if (hasValidImage) {
      return Image.network(
        imageUrl!,
        width: 51.28.w,
        height: 25.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 51.28.w,
            height: 25.w,
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff2A2A2A)
                : Color(0xffE5E5E5),
            child: Icon(
              Icons.local_pharmacy,
              size: 30,
              color: ThemeUtil.isDarkMode(context)
                  ? Color(0xff5A5A5A)
                  : Color(0xffA5A5A5),
            ),
          );
        },
      );
    } else {
      return Container(
        width: 51.28.w,
        height: 25.w,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff2A2A2A)
            : Color(0xffE5E5E5),
        child: Icon(
          Icons.local_pharmacy,
          size: 30,
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff5A5A5A)
              : Color(0xffA5A5A5),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Only call the main API - it returns all data (doctors, pharmacies, posts, reviews)
    _hospitalDetailController.getHospitalDetails(
        widget.isHospital, widget.hospitalId.toString(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Center(
        child: _hospitalDetailController.hospitaldetailloader.value
            ? CircularProgressIndicator()
            : _hospitalDetailController.hospitald.value == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load hospital details',
                        style: CustomTextStyles.darkHeadingTextStyle(),
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text('Go Back'),
                      ),
                    ],
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight:
                            200.0, // Height of the app bar when it's expanded.
                        flexibleSpace: Obx(
                          () {
                            final hospitalData =
                                _hospitalDetailController.hospitald.value;
                            final hasValidImage = hospitalData?.image != null &&
                                hospitalData!.image!.isNotEmpty &&
                                hospitalData.image!.contains('http') &&
                                !hospitalData.image!.contains(
                                    'c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

                            return Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: hasValidImage
                                      ? Image.network(
                                          hospitalData!.image!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xff2A2A2A)
                                                      : Color(0xffE5E5E5),
                                              child: Icon(
                                                Icons.local_hospital,
                                                size: 80,
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff5A5A5A)
                                                    : Color(0xffA5A5A5),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff2A2A2A)
                                              : Color(0xffE5E5E5),
                                          child: Icon(
                                            Icons.local_hospital,
                                            size: 80,
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xff5A5A5A)
                                                : Color(0xffA5A5A5),
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.isHospital
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16),
                                                child: SvgPicture.asset(
                                                    'Assets/icons/joy-icon-small.svg'),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0, left: 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? Color(0xff191919)
                                                        : Color(0xffF3F4F6),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.to(AllChats(),
                                                              transition: Transition
                                                                  .rightToLeft);
                                                        },
                                                        child: SvgPicture.asset(
                                                            'Assets/icons/sms.svg'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: widget.isHospital ? 0.h : 0.h,
                                    ),
                                    widget.isHospital
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            CreatePostModal(),
                                                      );
                                                    },
                                                    child: TextField(
                                                      enabled: false,
                                                      maxLines: null,
                                                      cursorColor:
                                                          AppColors.borderColor,
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: AppColors
                                                                  .borderColor),
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        border:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        fillColor:
                                                            Colors.transparent,
                                                        hintText:
                                                            "What's on your mind?",
                                                        hintStyle: CustomTextStyles
                                                            .lightTextStyle(
                                                                color: AppColors
                                                                    .borderColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            54),
                                                    color: ThemeUtil.isDarkMode(
                                                            context)
                                                        ? Color(0xff121212)
                                                        : AppColors
                                                            .whiteColorf9f,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.0,
                                                            vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'Assets/icons/camera.svg'),
                                                        SizedBox(width: 2.w),
                                                        Text(
                                                          "Photo",
                                                          style: CustomTextStyles
                                                              .lightTextStyle(
                                                            color: AppColors
                                                                .borderColor,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _hospitalDetailController
                                                      .hospitald.value?.name
                                                      .toString() ??
                                                  'Hospital',
                                              style: CustomTextStyles
                                                  .darkHeadingTextStyle(
                                                      size: 30,
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0xffFFFFFF)
                                                          : Color(0xff383D44)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: LocationWidget(
                                          location: _hospitalDetailController
                                                  .hospitald.value?.location
                                                  .toString() ??
                                              ''),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Divider(
                                      color: Color(0xffE5E7EB),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RoundedSVGContainer(
                                            iconColor:
                                                ThemeUtil.isDarkMode(context)
                                                    ? Color(0xffC5D3E3)
                                                    : null,
                                            svgAsset:
                                                'Assets/icons/profile-2user.svg',
                                            numberText:
                                                (_hospitalDetailController
                                                            .hospitald
                                                            .value
                                                            ?.doctors
                                                            ?.length ??
                                                        _hospitalDetailController
                                                            .hospitald
                                                            .value
                                                            ?.doctorCount ??
                                                        0)
                                                    .toString(),
                                            descriptionText: 'Doctors',
                                          ),
                                          RoundedSVGContainer(
                                            iconColor:
                                                ThemeUtil.isDarkMode(context)
                                                    ? Color(0xffC5D3E3)
                                                    : null,
                                            svgAsset: 'Assets/icons/medal.svg',
                                            numberText: '5+',
                                            descriptionText: 'Experience',
                                          ),
                                          RoundedSVGContainer(
                                            iconColor:
                                                ThemeUtil.isDarkMode(context)
                                                    ? Color(0xffC5D3E3)
                                                    : null,
                                            svgAsset: 'Assets/icons/star.svg',
                                            numberText: '5',
                                            descriptionText: 'Rating',
                                          ),
                                          RoundedSVGContainer(
                                            iconColor:
                                                ThemeUtil.isDarkMode(context)
                                                    ? Color(0xffC5D3E3)
                                                    : null,
                                            svgAsset:
                                                'Assets/icons/messages.svg',
                                            numberText: '0',
                                            descriptionText: 'Reviews',
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Heading(
                                        title: 'About Hospital',
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: ReadMoreText(
                                        _hospitalDetailController
                                                .hospitald.value?.about
                                                .toString() ??
                                            '',
                                        trimMode: TrimMode.Line,
                                        trimLines: 3,
                                        colorClickableText:
                                            AppColors.blackColor,
                                        trimCollapsedText: ' view more',
                                        trimExpandedText: ' view less',
                                        style: CustomTextStyles.lightTextStyle(
                                            size: 14),
                                        moreStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        lessStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Heading(
                                        title: 'Hospital Timings',
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Obx(() {
                                        final hospital =
                                            _hospitalDetailController
                                                .hospitald.value;
                                        if (hospital?.timings != null &&
                                            hospital!.timings!.isNotEmpty) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children:
                                                hospital.timings!.map((timing) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${timing.day ?? ''}: ${timing.open ?? ''} - ${timing.close ?? ''}',
                                                        style: CustomTextStyles
                                                            .lightTextStyle(
                                                                color: Color(
                                                                    0xff4B5563),
                                                                size: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        } else if (hospital?.timing != null &&
                                            hospital!.timing != 'N/a') {
                                          return Text(
                                            hospital.timing.toString(),
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    color: Color(0xff4B5563),
                                                    size: 14),
                                          );
                                        } else {
                                          return Text(
                                            'N/a',
                                            style:
                                                CustomTextStyles.lightTextStyle(
                                                    color: Color(0xff4B5563),
                                                    size: 14),
                                          );
                                        }
                                      }),
                                    ),
                                    // SizedBox(height: 2.h),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 16.0),
                                    //   child: Heading(
                                    //     title: 'Check up Fee',
                                    //   ),
                                    // ),
                                    // SizedBox(height: 1.h),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 16.0),
                                    //   child: Text(
                                    //       '${_hospitalDetailController.hospitald.value!.checkupFee.toString()}\ Rs',
                                    //       style: CustomTextStyles.lightTextStyle(
                                    //           color: Color(0xff4B5563), size: 14)),
                                    // ),

                                    SizedBox(height: 2.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        'Our Doctors',
                                        style: CustomTextStyles
                                            .darkHeadingTextStyle(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xffC8D3E0)
                                                    : null),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Obx(() {
                                      final doctors = _hospitalDetailController
                                              .hospitald.value?.doctors ??
                                          [];
                                      final isEmpty = doctors.isEmpty;

                                      return isEmpty
                                          ? Center(
                                              child: Text('No Doctors Found'),
                                            )
                                          : Container(
                                              height: 60.w,
                                              child: ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                shrinkWrap: true,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(width: 2.w),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: doctors.length,
                                                itemBuilder: (context, index) {
                                                  final doctorIndex = index;
                                                  final doctorData = doctors[
                                                          doctorIndex]
                                                      as Map<String, dynamic>;
                                                  final doctorImage =
                                                      doctorData['image']
                                                              ?.toString() ??
                                                          '';
                                                  final doctorName =
                                                      doctorData['name']
                                                              ?.toString() ??
                                                          '';
                                                  final doctorLocation =
                                                      doctorData['location']
                                                              ?.toString() ??
                                                          'N/a';
                                                  final hasValidImage = doctorImage
                                                          .isNotEmpty &&
                                                      doctorImage
                                                          .contains('http') &&
                                                      !doctorImage.contains(
                                                          'c894ac58-b8cd-47c0-94d1-3c4cea7dadab');
                                                  
                                                  // Extract doctor ID from the map
                                                  final doctorId = doctorData['_id']?.toString() ?? 
                                                                  doctorData['user_id']?.toString() ?? 
                                                                  doctorData['doctor_id']?.toString() ?? 
                                                                  doctorData['userId']?.toString() ?? '';
                                                  final doctorCategory = doctorData['expertise']?.toString() ?? 
                                                                        doctorData['category']?.toString() ?? 
                                                                        doctorData['specialization']?.toString() ?? 
                                                                        '';

                                                  return InkWell(
                                                    onTap: () {
                                                      if (doctorId.isNotEmpty && doctorId != 'null') {
                                                        Get.to(
                                                          DoctorDetailScreen2(
                                                            doctorId: doctorId,
                                                            docName: doctorName,
                                                            location: doctorLocation,
                                                            Category: doctorCategory,
                                                            isFromHospital: true, // Hospital mode - hide "Book Appointment" button
                                                          ),
                                                          transition: Transition.rightToLeft,
                                                        );
                                                      } else {
                                                        Get.snackbar(
                                                          'Error',
                                                          'Invalid doctor ID. Please try again.',
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.red,
                                                          colorText: Colors.white,
                                                          duration: Duration(seconds: 2),
                                                          icon: Icon(Icons.error, color: Colors.white),
                                                        );
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 55.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ThemeUtil
                                                                    .isDarkMode(
                                                                        context)
                                                                ? AppColors
                                                                    .purpleBlueColor
                                                                : Color(
                                                                    0xffEEF5FF),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(12),
                                                          ),
                                                          child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                                child: hasValidImage
                                                                    ? Image.network(
                                                                        doctorImage,
                                                                        width:
                                                                            51.28.w,
                                                                        height:
                                                                            25.w,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Container(
                                                                            width:
                                                                                51.28.w,
                                                                            height:
                                                                                25.w,
                                                                            color: ThemeUtil.isDarkMode(context)
                                                                                ? Color(0xff2A2A2A)
                                                                                : Color(0xffE5E5E5),
                                                                            child:
                                                                                Icon(
                                                                              Icons.person,
                                                                              size: 30,
                                                                              color: ThemeUtil.isDarkMode(context) ? Color(0xff5A5A5A) : Color(0xffA5A5A5),
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                    : Container(
                                                                        width:
                                                                            51.28.w,
                                                                        height:
                                                                            25.w,
                                                                        color: ThemeUtil.isDarkMode(context)
                                                                            ? Color(0xff2A2A2A)
                                                                            : Color(0xffE5E5E5),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              30,
                                                                          color: ThemeUtil.isDarkMode(context)
                                                                              ? Color(0xff5A5A5A)
                                                                              : Color(0xffA5A5A5),
                                                                        ),
                                                                      ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2.w),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          8,
                                                                          8,
                                                                          0,
                                                                          0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            doctorName,
                                                                            style:
                                                                                CustomTextStyles.darkHeadingTextStyle(),
                                                                          ),
                                                                          Divider(
                                                                            color:
                                                                                Color(0xff6B7280),
                                                                            thickness:
                                                                                0.05.h,
                                                                          ),
                                                                          Text(
                                                                            '',
                                                                            style:
                                                                                CustomTextStyles.w600TextStyle(size: 14, color: Color(0xff4B5563)),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              SvgPicture.asset('Assets/icons/location.svg'),
                                                                              SizedBox(width: 0.5.w),
                                                                              Expanded(
                                                                                child: Text(
                                                                                  doctorLocation,
                                                                                  style: CustomTextStyles.lightTextStyle(
                                                                                    color: Color(0xff4B5563),
                                                                                    size: 14,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              RatingBar.builder(
                                                                                itemSize: 15,
                                                                                initialRating: 6,
                                                                                minRating: 1,
                                                                                direction: Axis.horizontal,
                                                                                allowHalfRating: true,
                                                                                itemCount: 1,
                                                                                itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                                                itemBuilder: (context, _) => Icon(
                                                                                  Icons.star,
                                                                                  color: Colors.amber,
                                                                                ),
                                                                                onRatingUpdate: (rating) {
                                                                                  print(rating);
                                                                                },
                                                                              ),
                                                                              Text(
                                                                                '0.0',
                                                                                style: CustomTextStyles.lightTextStyle(color: Color(0xff4B5563), size: 12),
                                                                              ),
                                                                              SizedBox(width: 0.5.w),
                                                                              Text(
                                                                                ' | 0 Reviews',
                                                                                style: CustomTextStyles.lightTextStyle(color: Color(0xff6B7280), size: 10.8),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                },
                                              ),
                                            );
                                    }),
                                    SizedBox(height: 2.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        'Visit Our Pharmacy',
                                        style: CustomTextStyles
                                            .darkHeadingTextStyle(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xffC8D3E0)
                                                    : null),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    SizedBox(height: 1.h),
                                    Obx(() {
                                      final hospital = _hospitalDetailController
                                          .hospitald.value;
                                      final pharmacies =
                                          hospital?.pharmacies ?? [];

                                      if (pharmacies.isEmpty &&
                                          _hospitalDetailController
                                              .hospitalPharmacies.isEmpty) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text('No Pharmacy Found'),
                                          ),
                                        );
                                      }

                                      final displayPharmacies =
                                          pharmacies.isNotEmpty
                                              ? pharmacies
                                              : _hospitalDetailController
                                                  .hospitalPharmacies
                                                  .map((p) {
                                                  // Convert PharmacyModelData to HospitalPharmacy for display
                                                  return HospitalPharmacy(
                                                    pharmacyId: p.userId,
                                                    name: p.name,
                                                    email: p.email,
                                                    location: p.location,
                                                    phone: p.phone,
                                                    image: p.image,
                                                    details:
                                                        HospitalPharmacyDetails(
                                                      placeId: p.placeId,
                                                      lat: p.lat,
                                                      lng: p.lng,
                                                      location: p.location,
                                                    ),
                                                  );
                                                }).toList();

                                      return Container(
                                        height: 75.w,
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(width: 2.w),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: displayPharmacies.length,
                                          itemBuilder: (context, index) {
                                            final pharmacy =
                                                displayPharmacies[index];
                                            final pharmacyId = pharmacy
                                                    is HospitalPharmacy
                                                ? pharmacy.pharmacyId
                                                    ?.toString()
                                                : (pharmacy
                                                        as PharmacyModelData)
                                                    .userId
                                                    ?.toString();

                                            return InkWell(
                                              onTap: () {
                                                if (pharmacyId != null &&
                                                    pharmacyId.isNotEmpty &&
                                                    pharmacyId != 'null') {
                                                  Get.to(
                                                    ProductScreen(
                                                      userId: pharmacyId,
                                                      isAdmin: false, // User mode, not admin
                                                      isHospital: true, // Hospital mode - view only
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  );
                                                } else {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Invalid pharmacy ID. Please try again.',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    icon: Icon(Icons.error,
                                                        color: Colors.white),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 55.w,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffE2FFE3),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child:
                                                            _buildPharmacyImageForHorizontal(
                                                                pharmacy,
                                                                context),
                                                      ),
                                                      SizedBox(height: 2.w),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                8, 8, 0, 8),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              pharmacy
                                                                      is HospitalPharmacy
                                                                  ? pharmacy
                                                                          .name ??
                                                                      'Pharmacy'
                                                                  : (pharmacy as PharmacyModelData)
                                                                          .name ??
                                                                      'Pharmacy',
                                                              style: CustomTextStyles
                                                                  .darkHeadingTextStyle(),
                                                            ),
                                                            SizedBox(
                                                                height: 0.5.h),
                                                            Divider(
                                                              color: Color(
                                                                  0xff6B7280),
                                                              thickness: 0.05.h,
                                                            ),
                                                            SizedBox(
                                                                height: 0.5.h),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              2.0),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          'Assets/icons/location.svg'),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        0.5.w),
                                                                Expanded(
                                                                  child: Text(
                                                                    pharmacy
                                                                            is HospitalPharmacy
                                                                        ? (pharmacy.details?.location ??
                                                                            pharmacy
                                                                                .location ??
                                                                            'N/a')
                                                                        : (pharmacy as PharmacyModelData).location ??
                                                                            'N/a',
                                                                    style: CustomTextStyles
                                                                        .lightTextStyle(
                                                                      color: Color(
                                                                          0xff4B5563),
                                                                      size: 12,
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 0.5.h),
                                                            Row(
                                                              children: [
                                                                SvgPicture.asset(
                                                                    'Assets/icons/pharmacy.svg'),
                                                                SizedBox(
                                                                    width:
                                                                        0.5.w),
                                                                Text(
                                                                  'Pharmacy',
                                                                  style: CustomTextStyles.lightTextStyle(
                                                                      color: Color(
                                                                          0xff6B7280),
                                                                      size:
                                                                          10.8),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 1.h),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Heading(
                                        title: 'Reviews',
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Obx(() {
                                      final hospital = _hospitalDetailController
                                          .hospitald.value;
                                      final reviews = hospital?.reviews ?? [];

                                      if (reviews.isEmpty) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text('No Reviews Yet'),
                                          ),
                                        );
                                      }

                                      return Container(
                                        height: 25.h,
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(width: 2.w),
                                          itemCount: reviews.length,
                                          itemBuilder: (context, index) {
                                            final review = reviews[index];
                                            final userName =
                                                review.givenBy?.name ??
                                                    'Anonymous';
                                            final userImage =
                                                review.givenBy?.image ?? '';
                                            final hasValidUserImage = userImage
                                                    .isNotEmpty &&
                                                userImage.contains('http') &&
                                                !userImage.contains(
                                                    'c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

                                            return Container(
                                              width: 75.w,
                                              decoration: BoxDecoration(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff1A1A1A)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Color(0xffE5E7EB),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          child:
                                                              hasValidUserImage
                                                                  ? Image
                                                                      .network(
                                                                      userImage,
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          color: ThemeUtil.isDarkMode(context)
                                                                              ? Color(0xff2A2A2A)
                                                                              : Color(0xffE5E5E5),
                                                                          child:
                                                                              Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                25,
                                                                            color: ThemeUtil.isDarkMode(context)
                                                                                ? Color(0xff5A5A5A)
                                                                                : Color(0xffA5A5A5),
                                                                          ),
                                                                        );
                                                                      },
                                                                    )
                                                                  : Container(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      color: ThemeUtil.isDarkMode(context)
                                                                          ? Color(
                                                                              0xff2A2A2A)
                                                                          : Color(
                                                                              0xffE5E5E5),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            25,
                                                                        color: ThemeUtil.isDarkMode(context)
                                                                            ? Color(0xff5A5A5A)
                                                                            : Color(0xffA5A5A5),
                                                                      ),
                                                                    ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                userName,
                                                                style: CustomTextStyles.darkHeadingTextStyle(
                                                                    size: 14,
                                                                    color: ThemeUtil.isDarkMode(
                                                                            context)
                                                                        ? Color(
                                                                            0xffC8D3E0)
                                                                        : null),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Row(
                                                                children: List
                                                                    .generate(5,
                                                                        (starIndex) {
                                                                  return Icon(
                                                                    starIndex <
                                                                            (review.rating ??
                                                                                0)
                                                                        ? Icons
                                                                            .star
                                                                        : Icons
                                                                            .star_border,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .amber,
                                                                  );
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      review.review ?? '',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              size: 14,
                                                              color: ThemeUtil
                                                                      .isDarkMode(
                                                                          context)
                                                                  ? Color(
                                                                      0xffC8D3E0)
                                                                  : Color(
                                                                      0xff4B5563)),
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 1.h),
                                    widget.isUser
                                        ? Container()
                                        : SizedBox(height: 2.h),
                                    widget.isUser
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              'My Posts',
                                              style: CustomTextStyles
                                                  .darkHeadingTextStyle(
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0xffC8D3E0)
                                                          : null),
                                            ),
                                          ),
                                    SizedBox(height: 1.h),
                                    widget.isUser
                                        ? Container()
                                        : Obx(() {
                                            final hospital =
                                                _hospitalDetailController
                                                    .hospitald.value;
                                            final posts = hospital?.posts ?? [];

                                            if (posts.isEmpty) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text('No Posts Yet'),
                                                ),
                                              );
                                            }

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: posts.length,
                                              itemBuilder: ((context, index) {
                                                final postData = posts[index]
                                                    as Map<String, dynamic>;
                                                final createdByData = postData[
                                                        'created_by']
                                                    as Map<String, dynamic>?;

                                                // Get current user ID from ProfileController
                                                final currentUserId =
                                                    _profileController
                                                        .userId.value;

                                                // Convert post data to MediaPost-like structure
                                                final postId = postData['_id']
                                                        ?.toString() ??
                                                    '';
                                                final image = postData['image']
                                                        ?.toString() ??
                                                    '';
                                                final description =
                                                    postData['description']
                                                            ?.toString() ??
                                                        '';
                                                final createdAt =
                                                    postData['created_at']
                                                            ?.toString() ??
                                                        '';
                                                final createdBy =
                                                    createdByData?['_id']
                                                            ?.toString() ??
                                                        '';
                                                final postName =
                                                    createdByData?['name']
                                                            ?.toString() ??
                                                        '';
                                                final userImage =
                                                    createdByData?['image']
                                                            ?.toString() ??
                                                        '';
                                                final comments =
                                                    postData['comments']
                                                            as List<dynamic>? ??
                                                        [];
                                                final likedBy =
                                                    postData['liked_by']
                                                            as List<dynamic>? ??
                                                        [];
                                                final likesCount =
                                                    postData['likes']
                                                            ?.toString() ??
                                                        '0';

                                                // Check if current user liked this post
                                                final isLiked =
                                                    currentUserId.isNotEmpty &&
                                                        likedBy.any((id) =>
                                                            id.toString() ==
                                                            currentUserId);

                                                // Convert comments to Comments format
                                                final commentsList =
                                                    comments.map((c) {
                                                  final commentData =
                                                      c as Map<String, dynamic>;
                                                  return Comments.fromJson(
                                                      commentData);
                                                }).toList();

                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0xff1A1A1A)
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xffE5E7EB),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: MyCustomWidget(
                                                        userImage: userImage,
                                                        isHospital: true,
                                                        cm: commentsList,
                                                        postIndex: index,
                                                        postId: postId,
                                                        postTime: createdAt,
                                                        id: createdBy,
                                                        imgPath: image,
                                                        isLiked: isLiked,
                                                        likeCount: likesCount,
                                                        isReply: false,
                                                        showImg:
                                                            image.isNotEmpty,
                                                        postName: postName,
                                                        text: description,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            );
                                          }),
                                    SizedBox(height: 1.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    ));
  }
}
