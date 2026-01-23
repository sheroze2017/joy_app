import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/hospital/view/all_doc_pharmacy.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
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
import 'doctor_all_post.dart';
import '../../../common/profile/bloc/profile_bloc.dart';
import '../../../modules/auth/utils/auth_hive_utils.dart';
import '../../../modules/auth/models/user.dart';

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
                                  child: GestureDetector(
                                    onTap: () {
                                      if (hasValidImage) {
                                        _showFullImageSheet(
                                            context, hospitalData!.image!);
                                      }
                                    },
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
                                              // Handle both formats: times array or open/close
                                              String timingText;
                                              if (timing.times != null && timing.times!.isNotEmpty) {
                                                // New format: times array
                                                timingText = '${timing.day ?? ''}: ${timing.times!.join(' ')}';
                                              } else if (timing.open != null && timing.close != null) {
                                                // Old format: open/close
                                                timingText = '${timing.day ?? ''}: ${timing.open} - ${timing.close}';
                                              } else {
                                                // No timing data
                                                timingText = '${timing.day ?? ''}: -';
                                              }
                                              
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        timingText,
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
                                      final isHospitalRole = _profileController.userRole.value == 'HOSPITAL';

                                      // Build list items
                                      final List<Widget> doctorItems = [];
                                      
                                      // Add "+" button for hospital role
                                      if (isHospitalRole) {
                                        doctorItems.add(
                                          _buildAddButton(
                                            context: context,
                                            text: 'Add Doctors',
                                            onTap: () {
                                              // Navigate to add doctors screen or show dialog
                                              Get.to(
                                                AllDoctorsScreen(
                                                  isSelectable: true,
                                                  isHospital: true,
                                                  appBarText: 'Select Doctor',
                                                ),
                                                transition: Transition.rightToLeft,
                                              );
                                            },
                                            width: 55.w,
                                              height: 60.w,
                                          ),
                                        );
                                      }

                                      // Add existing doctor cards
                                      for (int index = 0; index < doctors.length; index++) {
                                                  final doctorIndex = index;
                                        final doctorData = doctors[doctorIndex] as Map<String, dynamic>;
                                        final doctorImage = doctorData['image']?.toString() ?? '';
                                        final doctorName = doctorData['name']?.toString() ?? '';
                                        final doctorLocation = doctorData['location']?.toString() ?? 'N/a';
                                        final hasValidImage = doctorImage.isNotEmpty &&
                                            doctorImage.contains('http') &&
                                            !doctorImage.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');
                                        
                                                  final doctorId = doctorData['_id']?.toString() ?? 
                                                                  doctorData['user_id']?.toString() ?? 
                                                                  doctorData['doctor_id']?.toString() ?? 
                                                                  doctorData['userId']?.toString() ?? '';
                                                  final doctorCategory = doctorData['expertise']?.toString() ?? 
                                                                        doctorData['category']?.toString() ?? 
                                                              doctorData['specialization']?.toString() ?? '';

                                        doctorItems.add(
                                          _buildDoctorCard(
                                            context: context,
                                                            doctorId: doctorId,
                                            doctorName: doctorName,
                                            doctorLocation: doctorLocation,
                                            doctorCategory: doctorCategory,
                                            doctorImage: doctorImage,
                                            hasValidImage: hasValidImage,
                                            isHospitalRole: isHospitalRole,
                                            onRemove: () async {
                                              // Show confirmation dialog
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Remove Doctor'),
                                                  content: Text('Do you want to remove this doctor?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: Text('Remove', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              
                                              if (confirmed == true && doctorId.isNotEmpty) {
                                                UserHive? currentUser = await getCurrentUser();
                                                if (currentUser != null) {
                                                  await _hospitalDetailController.linkOrDelinkDoctorOrPharmacy(
                                                    doctorId,
                                                    null, // null to delink
                                                    context,
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        );
                                      }

                                      return isEmpty && !isHospitalRole
                                          ? Center(
                                              child: Text('No Doctors Found'),
                                                                      )
                                                                    : Container(
                                              height: 60.w,
                                              child: ListView.separated(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                shrinkWrap: true,
                                                separatorBuilder: (context, index) => SizedBox(width: 2.w),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: doctorItems.length,
                                                itemBuilder: (context, index) {
                                                  return doctorItems[index];
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
                                      final hospital = _hospitalDetailController.hospitald.value;
                                      final pharmacies = hospital?.pharmacies ?? [];
                                      final isHospitalRole = _profileController.userRole.value == 'HOSPITAL';

                                      if (pharmacies.isEmpty &&
                                          _hospitalDetailController.hospitalPharmacies.isEmpty &&
                                          !isHospitalRole) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text('No Pharmacy Found'),
                                          ),
                                        );
                                      }

                                      final displayPharmacies = pharmacies.isNotEmpty
                                              ? pharmacies
                                          : _hospitalDetailController.hospitalPharmacies.map((p) {
                                                  return HospitalPharmacy(
                                                    pharmacyId: p.userId,
                                                    name: p.name,
                                                    email: p.email,
                                                    location: p.location,
                                                    phone: p.phone,
                                                    image: p.image,
                                                details: HospitalPharmacyDetails(
                                                      placeId: p.placeId,
                                                      lat: p.lat,
                                                      lng: p.lng,
                                                      location: p.location,
                                                    ),
                                                  );
                                                }).toList();

                                      // Build list items
                                      final List<Widget> pharmacyItems = [];
                                      
                                      // Add "+" button for hospital role
                                      if (isHospitalRole) {
                                        pharmacyItems.add(
                                          _buildAddButton(
                                            context: context,
                                            text: 'Add Pharmacy',
                                              onTap: () {
                                              // Navigate to add pharmacy screen or show dialog
                                              // Navigate to pharmacy selection screen
                                              // First fetch unlinked pharmacies, then show selection screen
                                              _hospitalDetailController.getUnlinkedPharmacies(context).then((_) {
                                                  Get.to(
                                                  AllDocPharmacy(
                                                    appBarText: 'Select Pharmacy',
                                                    isSelectable: true,
                                                    isPharmacy: true,
                                                    dataList: _hospitalDetailController.hospitalPharmacies.toList(),
                                                    isFromHosipital: true,
                                                  ),
                                                  transition: Transition.rightToLeft,
                                                );
                                              }).catchError((error) {
                                                // Error already handled in getUnlinkedPharmacies
                                                print('Error loading unlinked pharmacies: $error');
                                              });
                                            },
                                                width: 55.w,
                                            height: 60.w, // reduced height for add pharmacy card
                                          ),
                                        );
                                      }

                                      // Add existing pharmacy cards
                                      for (int index = 0; index < displayPharmacies.length; index++) {
                                        final pharmacy = displayPharmacies[index];
                                        final pharmacyId = pharmacy is HospitalPharmacy
                                            ? pharmacy.pharmacyId?.toString()
                                            : (pharmacy as PharmacyModelData).userId?.toString();

                                        pharmacyItems.add(
                                          _buildPharmacyCard(
                                            context: context,
                                            pharmacy: pharmacy,
                                            pharmacyId: pharmacyId ?? '',
                                            isHospitalRole: isHospitalRole,
                                            onRemove: () async {
                                              // Show confirmation dialog
                                              final confirmed = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Delink Pharmacy'),
                                                  content: Text('Do you want to delink this pharmacy from your hospital?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: Text('Delink', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              
                                              if (confirmed == true && pharmacyId != null && pharmacyId.isNotEmpty) {
                                                await _hospitalDetailController.delinkPharmacy(
                                                  pharmacyId,
                                                  context,
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }

                                      return Container(
                                        height: 60.w, // reduced height for pharmacy cards
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                shrinkWrap: true,
                                          separatorBuilder: (context, index) => SizedBox(width: 2.w),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: pharmacyItems.length,
                                                itemBuilder: (context, index) {
                                            return pharmacyItems[index];
                                          },
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 2.h),
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
                                                final dislikedBy =
                                                    postData['disliked_by']
                                                            as List<dynamic>? ??
                                                        [];
                                                final likesCount =
                                                    postData['likes']
                                                            ?.toString() ??
                                                        '0';

                                                // Check if current user liked this post by checking liked_by array
                                                // Ignore is_my_like field and use liked_by array instead
                                                final isLiked = currentUserId.isNotEmpty &&
                                                    likedBy.any((id) =>
                                                        id.toString() == currentUserId);
                                                
                                                // Check if current user disliked this post by checking disliked_by array
                                                final isDisliked = currentUserId.isNotEmpty &&
                                                    dislikedBy.any((id) =>
                                                        id.toString() == currentUserId);
                                                
                                                // Debug: Log the like/dislike state for verification
                                                print('🏥 [HospitalHomeScreen] Post ${postId}: currentUserId=$currentUserId, liked_by=$likedBy, disliked_by=$dislikedBy, isLiked=$isLiked, isDisliked=$isDisliked');

                                                // Convert comments to Comments format
                                                // Reverse to show newest comments first (at the top)
                                                final commentsList =
                                                    comments.map((c) {
                                                  final commentData =
                                                      c as Map<String, dynamic>;
                                                  return Comments.fromJson(
                                                      commentData);
                                                }).toList().reversed.toList();

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
                                                        isDisliked: isDisliked,
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

  // Helper method to build "+" button with dashed border
  Widget _buildAddButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeUtil.isDarkMode(context)
                ? Color(0xff5A5A5A)
                : Color(0xffD1D5DB),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 30,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xffC8D3E0)
                    : Color(0xff6B7280),
              ),
              SizedBox(height: 1.h),
              Text(
                text,
                style: CustomTextStyles.w600TextStyle(
                  size: 14,
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xffC8D3E0)
                      : Color(0xff6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build doctor card with remove button for hospital role
  Widget _buildDoctorCard({
    required BuildContext context,
    required String doctorId,
    required String doctorName,
    required String doctorLocation,
    required String doctorCategory,
    required String doctorImage,
    required bool hasValidImage,
    required bool isHospitalRole,
    required VoidCallback onRemove,
  }) {
    return InkWell(
      onTap: () {
        if (doctorId.isNotEmpty && doctorId != 'null') {
          Get.to(
            DoctorDetailScreen2(
              doctorId: doctorId,
              docName: doctorName,
              location: doctorLocation,
              Category: doctorCategory,
              isFromHospital: true,
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
            decoration: BoxDecoration(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.purpleBlueColor
                  : Color(0xffEEF5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: hasValidImage
                        ? Image.network(
                            doctorImage,
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
                                  Icons.person,
                                  size: 30,
                                  color: ThemeUtil.isDarkMode(context)
                                      ? Color(0xff5A5A5A)
                                      : Color(0xffA5A5A5),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 51.28.w,
                            height: 25.w,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xff2A2A2A)
                                : Color(0xffE5E5E5),
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff5A5A5A)
                                  : Color(0xffA5A5A5),
                            ),
                          ),
                  ),
                  SizedBox(width: 2.w),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName,
                                style: CustomTextStyles.darkHeadingTextStyle(),
                              ),
                              Divider(
                                color: Color(0xff6B7280),
                                thickness: 0.05.h,
                              ),
                              Text(
                                '',
                                style: CustomTextStyles.w600TextStyle(
                                    size: 14, color: Color(0xff4B5563)),
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
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
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
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff4B5563), size: 12),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Text(
                                    ' | 0 Reviews',
                                    style: CustomTextStyles.lightTextStyle(
                                        color: Color(0xff6B7280), size: 10.8),
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
          // Red view with "-" icon for hospital role
          if (isHospitalRole)
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: onRemove,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 4.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build pharmacy card with remove button for hospital role
  Widget _buildPharmacyCard({
    required BuildContext context,
    required dynamic pharmacy,
    required String pharmacyId,
    required bool isHospitalRole,
    required VoidCallback onRemove,
  }) {
    final pharmacyName = pharmacy is HospitalPharmacy
        ? pharmacy.name ?? 'Pharmacy'
        : (pharmacy as PharmacyModelData).name ?? 'Pharmacy';
    final pharmacyLocation = pharmacy is HospitalPharmacy
        ? pharmacy.location ?? 'N/A'
        : (pharmacy as PharmacyModelData).location ?? 'N/A';
    final pharmacyImage = pharmacy is HospitalPharmacy
        ? pharmacy.image
        : (pharmacy as PharmacyModelData).image;

    final hasValidImage = pharmacyImage != null &&
        pharmacyImage.isNotEmpty &&
        pharmacyImage.contains('http') &&
        !pharmacyImage.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');

    return InkWell(
      onTap: () {
        if (pharmacyId.isNotEmpty && pharmacyId != 'null') {
          Get.to(
            ProductScreen(
              userId: pharmacyId,
              isAdmin: false,
              isHospital: true,
            ),
            transition: Transition.rightToLeft,
          );
        } else {
          Get.snackbar(
            'Error',
            'Invalid pharmacy ID. Please try again.',
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
            height: 60.w,
            decoration: BoxDecoration(
              color: Color(0xffE2FFE3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: hasValidImage
                        ? Image.network(
                            pharmacyImage,
                            width: 51.28.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPharmacyImage(pharmacy, context);
                            },
                          )
                        : _buildPharmacyImage(pharmacy, context),
                  ),
                  SizedBox(height: 0.8.h),
                  Text(
                    pharmacyName,
                    style: CustomTextStyles.darkHeadingTextStyle(),
                  ),
                  Divider(
                    color: Color(0xff6B7280),
                    thickness: 0.05.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('Assets/icons/location.svg'),
                      SizedBox(width: 0.5.w),
                      Expanded(
                        child: Text(
                          pharmacyLocation,
                          style: CustomTextStyles.lightTextStyle(
                            color: Color(0xff4B5563),
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.3.h),
                  Row(
                    children: [
                      SvgPicture.asset('Assets/icons/pharmacy.svg'),
                      SizedBox(width: 0.5.w),
                      Text(
                        'Pharmacy',
                        style: CustomTextStyles.lightTextStyle(
                          color: Color(0xff4B5563),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Red view with "-" icon for hospital role
          if (isHospitalRole)
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: onRemove,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 4.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullImageSheet(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final sheetHeight = screenHeight * 0.75; // 75% of screen height
        final sheetWidth = screenWidth * 0.9; // 90% of screen width
        
        return Center(
          child: Container(
            height: sheetHeight,
            width: sheetWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 50,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
