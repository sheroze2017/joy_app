import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/hospital/bloc/get_hospital_details_bloc.dart';
import 'package:joy_app/modules/hospital/model/hospital_detail_model.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_hospital/model/all_hospital_model.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/home/components/blog_card.dart';
import 'package:joy_app/view/user_flow/hospital_user/all_hospital_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../home/my_profile.dart';
import '../user_flow/hospital_user/hospital_detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.hospitalId != null || !widget.hospitalId!.isEmpty) {
      _hospitalDetailController.getAllDoctorHospital(
          widget.hospitalId.toString(), context);
      _hospitalDetailController.getAllDoctorPharmacies(
          widget.hospitalId.toString(), context);
      _hospitalDetailController.getHospitalDetails(
          widget.hospitalId.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => _hospitalDetailController.hospitaldetailloader.value
          ? CircularProgressIndicator()
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight:
                      200.0, // Height of the app bar when it's expanded.
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.network(
                          _hospitalDetailController.hospitald.value!.image!
                                  .contains('http')
                              ? _hospitalDetailController.hospitald.value!.image
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
                            color: Theme.of(context).scaffoldBackgroundColor,
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.isHospital
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          child: SvgPicture.asset(
                                              'Assets/icons/joy-icon-small.svg'),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xff191919)
                                                : Color(0xffF3F4F6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  'Assets/icons/search-normal.svg'),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0.0, left: 8),
                                          child: Container(
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
                                                    'Assets/icons/sms.svg'),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: widget.isHospital ? 0.h : 1.5.h,
                              ),
                              widget.isHospital
                                  ? Row(
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
                                                            BorderSide.none),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                                fillColor: Colors.transparent,
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
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xff121212)
                                                : AppColors.whiteColorf9f,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0, vertical: 8),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'Assets/icons/camera.svg'),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  "Photo",
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                    color:
                                                        AppColors.borderColor,
                                                    size: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: widget.isHospital ? 0.h : 2.h,
                              ),
                              Text(
                                widget.hospitalDetail == null
                                    ? 'Sunrise Health Clinic'
                                    : widget.hospitalDetail!.name.toString(),
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    size: 30,
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffFFFFFF)
                                        : Color(0xff383D44)),
                              ),
                              LocationWidget(
                                  location: widget.hospitalDetail == null
                                      ? 'null'
                                      : widget.hospitalDetail!.location
                                          .toString()),
                              SizedBox(
                                height: 1.h,
                              ),
                              Divider(
                                color: Color(0xffE5E7EB),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundedSVGContainer(
                                    iconColor: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC5D3E3)
                                        : null,
                                    svgAsset: 'Assets/icons/profile-2user.svg',
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
                                    numberText: '1872',
                                    descriptionText: 'Reviews',
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              // Heading(
                              //   title: 'About Hospital',
                              // ),
                              // SizedBox(height: 0.5.h),
                              // ReadMoreText(
                              //   "Sunrise health clinic is renowned hospital working from last 12 years. It have all the modern machinery and all lab tests are available. It have all the modern machinery and all lab tests are available",
                              //   trimMode: TrimMode.Line,
                              //   trimLines: 3,
                              //   colorClickableText: AppColors.blackColor,
                              //   trimCollapsedText: ' view more',
                              //   trimExpandedText: ' view less',
                              //   style: CustomTextStyles.lightTextStyle(size: 14),
                              //   moreStyle: TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.bold),
                              //   lessStyle: TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.bold),
                              // ),

                              SizedBox(height: 1.h),
                              Heading(
                                title: 'Hospital Timings',
                              ),
                              SizedBox(height: 0.5.h),
                              Text('Monday-Friday, 08.00 AM-18.00 pM',
                                  style: CustomTextStyles.lightTextStyle(
                                      color: Color(0xff4B5563), size: 14)),
                              SizedBox(height: 1.5.h),
                              Heading(
                                title: 'Check up Fee',
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                  '${_hospitalDetailController.hospitald.value!.checkupFee.toString()}\$',
                                  style: CustomTextStyles.lightTextStyle(
                                      color: Color(0xff4B5563), size: 14)),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Text(
                                    'Our Doctors',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xffC8D3E0)
                                                : null),
                                  ),
                                  Spacer(),
                                  Text(
                                    'See All',
                                    style:
                                        CustomTextStyles.lightSmallTextStyle(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Obx(() =>
                                  _hospitalDetailController
                                              .hospitalDoctors.length ==
                                          0
                                      ? Center(
                                          child: Text('No Doctors Found'),
                                        )
                                      : Container(
                                          height: 70.w,
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      SizedBox(width: 2.w),
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  _hospitalDetailController
                                                      .hospitalDoctors.length,
                                              itemBuilder: (context, index) {
                                                final data =
                                                    _hospitalDetailController
                                                        .hospitalDoctors[index];
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(DoctorDetailScreen2(
                                                      doctorId: data
                                                          .pharmacyDetailId
                                                          .toString(),
                                                      docName:
                                                          'Dr. David Patel',
                                                      location:
                                                          'Golden Cardiology Center',
                                                      Category: 'Cardiologist',
                                                    ));
                                                  },
                                                  child: Container(
                                                    width: 57.5.w,
                                                    decoration: BoxDecoration(
                                                        color: ThemeUtil
                                                                .isDarkMode(
                                                                    context)
                                                            ? AppColors
                                                                .purpleBlueColor
                                                            : Color(0xffEEF5FF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            child:
                                                                Image.network(
                                                              data.image
                                                                      .toString()
                                                                      .contains(
                                                                          'http')
                                                                  ? data.image
                                                                      .toString()
                                                                  : "http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png",
                                                              width: 51.28.w,
                                                              height: 27.9.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  // width: 51.28.w,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                            8,
                                                                            8,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          data.name
                                                                              .toString(),
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
                                                                          'Cardiologist',
                                                                          style: CustomTextStyles.w600TextStyle(
                                                                              size: 14,
                                                                              color: Color(0xff4B5563)),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset('Assets/icons/location.svg'),
                                                                            SizedBox(
                                                                              width: 0.5.w,
                                                                            ),
                                                                            Expanded(
                                                                              child: Text('Cardiology Center, USA', style: CustomTextStyles.lightTextStyle(color: Color(0xff4B5563), size: 14)),
                                                                            )
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
                                                                            Text('5',
                                                                                style: CustomTextStyles.lightTextStyle(color: Color(0xff4B5563), size: 12)),
                                                                            SizedBox(
                                                                              width: 0.5.w,
                                                                            ),
                                                                            Text(' | 1,872 Reviews',
                                                                                style: CustomTextStyles.lightTextStyle(color: Color(0xff6B7280), size: 10.8)),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Text(
                                    'Visit Our Pharmacy',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xffC8D3E0)
                                                : null),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.isHospital == true
                                        ? 'Edit'
                                        : 'See All',
                                    style:
                                        CustomTextStyles.lightSmallTextStyle(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MedicineCard(
                                      onPressed: () {},
                                      btnText: "Add to Cart",
                                      imgUrl:
                                          'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                      count: '10',
                                      cost: '5',
                                      name: 'Panadol',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: MedicineCard(
                                      onPressed: () {},
                                      btnText: "Add to Cart",
                                      imgUrl:
                                          'https://i.guim.co.uk/img/media/20491572b80293361199ca2fc95e49dfd85e1f42/0_236_5157_3094/master/5157.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=80ea7ebecd3f10fe721bd781e02184c3',
                                      count: '10',
                                      cost: '5',
                                      name: 'Panadol',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Heading(
                                title: 'Reviews',
                              ),
                              SizedBox(height: 1.h),
                              UserRatingWidget(
                                image: '',
                                docName: 'Emily Anderson',
                                reviewText: '',
                                rating: '5',
                              ),
                              widget.isUser
                                  ? Container()
                                  : SizedBox(height: 2.h),
                              widget.isUser
                                  ? Container()
                                  : Row(
                                      children: [
                                        Text(
                                          'My Posts',
                                          style: CustomTextStyles
                                              .darkHeadingTextStyle(
                                                  color: ThemeUtil.isDarkMode(
                                                          context)
                                                      ? Color(0xffC8D3E0)
                                                      : null),
                                        ),
                                        Spacer(),
                                        Text(
                                          'See All',
                                          style: CustomTextStyles
                                              .lightSmallTextStyle(),
                                        ),
                                      ],
                                    ),
                              widget.isUser
                                  ? Container()
                                  : SizedBox(
                                      height: 1.h,
                                    ),
                              // widget.isUser
                              //     ? Container()
                              //     : MyCustomWidget(
                              //         isLiked: true,
                              //         isReply: true,
                              //         postName: 'Sheroze',
                              //         text:
                              //             'Hey pals ! Had my third day of chemo. feeling much better.',
                              //       ),
                              // widget.isUser
                              //     ? Container()
                              //     : SizedBox(
                              //         height: 3.h,
                              //       ),
                              // widget.isUser
                              //     ? Container()
                              //     : MyCustomWidget(
                              //         isLiked: false,
                              //         showImg: false,
                              //         isReply: false,
                              //         postName: 'Mille Brown',
                              //         text: 'Feeling depressed today.',
                              //       )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ));
  }
}
