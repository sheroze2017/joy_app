import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/hospital/view/all_doc_pharmacy.dart';
import 'package:joy_app/modules/social_media/media_post/bloc/medai_posts_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/user/user_doctor/bloc/user_doctor_bloc.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/location_widget.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/reviewbar_widget.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
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

  @override
  void initState() {
    super.initState();
    //  if (widget.hospitalId != null || !widget.hospitalId!.isEmpty) {
    _hospitalDetailController.getAllDoctorHospital(
        widget.isHospital, widget.hospitalId.toString(), context);
    _hospitalDetailController.getAllDoctorPharmacies(
        widget.isHospital, widget.hospitalId.toString(), context);
    _hospitalDetailController.getHospitalDetails(
        widget.isHospital, widget.hospitalId.toString(), context);
    mediaController.getAllPostById(
        widget.isHospital, widget.hospitalId, context);
    //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => Center(
        child: _hospitalDetailController.hospitaldetailloader.value
            ? CircularProgressIndicator()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight:
                        200.0, // Height of the app bar when it's expanded.
                    flexibleSpace: Obx(
                      () => Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.network(
                              _hospitalDetailController.hospitald.value!.image!
                                      .contains('http')
                                  ? _hospitalDetailController
                                      .hospitald.value!.image
                                      .toString()
                                  : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 30.0,
                            right: 0,
                            left: 0,
                            child: Center(
                              child: Text(
                                'Hospital Details',
                                style: CustomTextStyles.darkTextStyle(
                                    color: Color(0xff374151)),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xff191919)
                                                      : Color(0xffF3F4F6),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                    'Assets/icons/search-normal.svg'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0, left: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff191919)
                                                    : Color(0xffF3F4F6),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
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
                                                  decoration: InputDecoration(
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
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
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
                                                    BorderRadius.circular(54),
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xff121212)
                                                    : AppColors.whiteColorf9f,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
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
                                              .hospitald.value!.name
                                              .toString(),
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  size: 30,
                                                  color: ThemeUtil.isDarkMode(
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
                                          .hospitald.value!.location
                                          .toString()),
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
                                        iconColor: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC5D3E3)
                                            : null,
                                        svgAsset:
                                            'Assets/icons/profile-2user.svg',
                                        numberText: _hospitalDetailController
                                            .hospitalDoctors.length
                                            .toString(),
                                        descriptionText: 'Doctors',
                                      ),
                                      RoundedSVGContainer(
                                        iconColor: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC5D3E3)
                                            : null,
                                        svgAsset: 'Assets/icons/medal.svg',
                                        numberText: '5+',
                                        descriptionText: 'Experience',
                                      ),
                                      RoundedSVGContainer(
                                        iconColor: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC5D3E3)
                                            : null,
                                        svgAsset: 'Assets/icons/star.svg',
                                        numberText: '5',
                                        descriptionText: 'Rating',
                                      ),
                                      RoundedSVGContainer(
                                        iconColor: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC5D3E3)
                                            : null,
                                        svgAsset: 'Assets/icons/messages.svg',
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
                                        .hospitald.value!.about
                                        .toString(),
                                    trimMode: TrimMode.Line,
                                    trimLines: 3,
                                    colorClickableText: AppColors.blackColor,
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
                                  child: Text(
                                      _hospitalDetailController
                                          .hospitald.value!.timing
                                          .toString(),
                                      style: CustomTextStyles.lightTextStyle(
                                          color: Color(0xff4B5563), size: 14)),
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
                                  child: Row(
                                    children: [
                                      Text(
                                        'Our Doctors',
                                        style: CustomTextStyles
                                            .darkHeadingTextStyle(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xffC8D3E0)
                                                    : null),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                              AllDocPharmacy(
                                                isFromHosipital: true,
                                                dataList:
                                                    _hospitalDetailController
                                                        .hospitalDoctors.value,
                                                appBarText: 'Our Doctors',
                                                isPharmacy: false,
                                              ),
                                              transition:
                                                  Transition.rightToLeft);
                                        },
                                        child: Text(
                                          'See All',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Obx(
                                    () =>
                                        _hospitalDetailController
                                                .hospitalDoctors.isEmpty
                                            ? Center(
                                                child: Text('No Doctors Found'),
                                              )
                                            : Container(
                                                height: 60.w,
                                                child: ListView.separated(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0),
                                                  shrinkWrap: true,
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          SizedBox(width: 2.w),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _hospitalDetailController
                                                              .hospitalDoctors
                                                              .length +
                                                          1, // Increase by 1 for the plus widget
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index == 0) {
                                                      return InkWell(
                                                        onTap: () async {
                                                          await _userDoctorController
                                                              .getAllDoctors();

                                                          Get.to(
                                                              AllDoctorsScreen(
                                                                  isSelectable:
                                                                      true,
                                                                  appBarText:
                                                                      'Select Doctor'),
                                                              transition:
                                                                  Transition
                                                                      .native);
                                                        },
                                                        child: Container(
                                                          width: 57.5.w,
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
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    color: Colors
                                                                        .black),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      final data =
                                                          _hospitalDetailController
                                                                  .hospitalDoctors[
                                                              index - 1];
                                                      return InkWell(
                                                        onTap: () {
                                                          Get.to(
                                                            DoctorDetailScreen2(
                                                              isFromHospital:
                                                                  true,
                                                              doctorId: data
                                                                  .pharmacyDetailId
                                                                  .toString(),
                                                              docName:
                                                                  'Dr. David Patel',
                                                              location:
                                                                  'Golden Cardiology Center',
                                                              Category:
                                                                  'Cardiologist',
                                                            ),
                                                            transition:
                                                                Transition
                                                                    .rightToLeft,
                                                          );
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
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
                                                                child: Column(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                      child: Image
                                                                          .network(
                                                                        data.image?.toString().contains('http') ??
                                                                                false
                                                                            ? data.image.toString()
                                                                            : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                                                        width:
                                                                            51.28.w,
                                                                        height:
                                                                            25.w,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 2
                                                                            .w),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                8,
                                                                                8,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  data.name.toString(),
                                                                                  style: CustomTextStyles.darkHeadingTextStyle(),
                                                                                ),
                                                                                Divider(
                                                                                  color: Color(0xff6B7280),
                                                                                  thickness: 0.05.h,
                                                                                ),
                                                                                Text(
                                                                                  '',
                                                                                  style: CustomTextStyles.w600TextStyle(size: 14, color: Color(0xff4B5563)),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    SvgPicture.asset('Assets/icons/location.svg'),
                                                                                    SizedBox(width: 0.5.w),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        data.location ?? 'N/a',
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
                                                                                      ' | ${data.reviews!.length.toString()} Reviews',
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
                                                            Positioned(
                                                                right: 0,
                                                                top: 0,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ConfirmationUnLinkDailog(
                                                                          link_to_user_id: data
                                                                              .userId
                                                                              .toString(),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              color: !ThemeUtil.isDarkMode(context) ? Color(0xff0D0D0D) : Color(0xffE5E7EB),
                                                                              borderRadius: BorderRadius.circular(50)),
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(3.0),
                                                                            child:
                                                                                Icon(
                                                                              color: ThemeUtil.isDarkMode(context) ? Color(0xff0D0D0D) : Color(0xffE5E7EB),
                                                                              Icons.remove,
                                                                              size: 20,
                                                                            ),
                                                                          )),
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              )),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Visit Our Pharmacy',
                                        style: CustomTextStyles
                                            .darkHeadingTextStyle(
                                                color: ThemeUtil.isDarkMode(
                                                        context)
                                                    ? Color(0xffC8D3E0)
                                                    : null),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                              AllDocPharmacy(
                                                isFromHosipital: true,
                                                dataList:
                                                    _hospitalDetailController
                                                        .hospitalPharmacies
                                                        .value,
                                                appBarText: 'Our Pharmacy',
                                                isPharmacy: true,
                                              ),
                                              transition:
                                                  Transition.rightToLeft);
                                        },
                                        child: Text(
                                          'See All',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Container(
                                    width: 100.w,
                                    height: 15.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xffE2FFE3),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: _pharmacyController
                                            .fetchPharmacyLoader.value
                                        ? LoadingWidget()
                                        : Center(
                                            child: InkWell(
                                              onTap: () async {
                                                await _pharmacyController
                                                    .getAllPharmacy();

                                                Get.to(
                                                    AllDocPharmacy(
                                                      isFromHosipital: true,
                                                      isSelectable: true,
                                                      dataList:
                                                          _pharmacyController
                                                              .pharmacies.value,
                                                      appBarText:
                                                          'Select Pharmacy',
                                                      isPharmacy: true,
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.black),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Obx(() => _hospitalDetailController
                                            .hospitalPharmacies.length ==
                                        0
                                    ? Center(
                                        child: Text('No Pharmacy Found'),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _hospitalDetailController
                                            .hospitalPharmacies.length,
                                        itemBuilder: (context, index) {
                                          final data = _hospitalDetailController
                                              .hospitalPharmacies[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(
                                                    PharmacyProductScreen(
                                                      isHospital:
                                                          widget.isHospital,
                                                      userId: data.userId
                                                          .toString(),
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffE2FFE3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            child:
                                                                Image.network(
                                                              data.image!
                                                                      .contains(
                                                                          'http')
                                                                  ? data.image!
                                                                  : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                                                              width: 28.w,
                                                              height: 28.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                HospitalName(
                                                                    hospitalName: data
                                                                        .name
                                                                        .toString()),
                                                                LocationWidget(
                                                                    location: data
                                                                        .location
                                                                        .toString()),
                                                                ReviewBar(
                                                                    rating: PharReviews.calculateAverageRating(
                                                                            data.reviews ??
                                                                                [])
                                                                        .toString(),
                                                                    count: data
                                                                        .reviews!
                                                                        .length),
                                                                Divider(
                                                                  color: Color(
                                                                      0xff6B7280),
                                                                  thickness:
                                                                      0.1.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            'Assets/icons/routing.svg'),
                                                                        SizedBox(
                                                                          width:
                                                                              0.5.w,
                                                                        ),
                                                                        Text(
                                                                            '0.0 km/0min',
                                                                            style:
                                                                                CustomTextStyles.lightTextStyle(color: Color(0xff6B7280), size: 10.8))
                                                                      ],
                                                                    ),
                                                                    Spacer(),
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            'Assets/icons/pharmacy.svg'),
                                                                        SizedBox(
                                                                          width:
                                                                              0.5.w,
                                                                        ),
                                                                        Text(
                                                                            'Pharmacy',
                                                                            style:
                                                                                CustomTextStyles.lightTextStyle(color: Color(0xff6B7280), size: 10.8))
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ConfirmationUnLinkDailog(
                                                                link_to_user_id:
                                                                    data.userId
                                                                        .toString(),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: !ThemeUtil
                                                                        .isDarkMode(
                                                                            context)
                                                                    ? Color(
                                                                        0xff0D0D0D)
                                                                    : Color(
                                                                        0xffE5E7EB),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: Icon(
                                                                color: ThemeUtil
                                                                        .isDarkMode(
                                                                            context)
                                                                    ? Color(
                                                                        0xff0D0D0D)
                                                                    : Color(
                                                                        0xffE5E7EB),
                                                                Icons.remove,
                                                                size: 20,
                                                              ),
                                                            )),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Heading(
                                    title: 'Reviews',
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                widget.isUser
                                    ? Container()
                                    : SizedBox(height: 2.h),
                                widget.isUser
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'My Posts',
                                              style: CustomTextStyles
                                                  .darkHeadingTextStyle(
                                                      color: ThemeUtil
                                                              .isDarkMode(
                                                                  context)
                                                          ? Color(0xffC8D3E0)
                                                          : null),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Get.to(DoctorAllPost(),
                                                    transition:
                                                        Transition.rightToLeft);
                                              },
                                              child: Text(
                                                'See All',
                                                style: CustomTextStyles
                                                    .lightSmallTextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                widget.isUser
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Obx(() => ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: mediaController
                                                .postsByUserId.length,
                                            itemBuilder: ((context, index) {
                                              final data = mediaController
                                                  .postsByUserId[index];
                                              return Column(
                                                children: [
                                                  Obx(() => MyCustomWidget(
                                                        userImage: data
                                                            .user_image
                                                            .toString(),
                                                        isHospital: true,
                                                        cm: mediaController
                                                            .postsByUserId[
                                                                index]
                                                            .comments!,
                                                        postIndex: index,
                                                        postId: data.postId
                                                            .toString(),
                                                        postTime: data.createdAt
                                                            .toString(),
                                                        id: data.createdBy
                                                            .toString(),
                                                        imgPath: data.image
                                                            .toString(),
                                                        isLiked: true,
                                                        isReply: false,
                                                        showImg: (data.image ==
                                                                    null ||
                                                                data.image!
                                                                    .isEmpty)
                                                            ? false
                                                            : true,
                                                        postName: data.name
                                                            .toString(),
                                                        text: data.description
                                                            .toString(),
                                                      )),
                                                ],
                                              );
                                            }))),
                                      ),
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
