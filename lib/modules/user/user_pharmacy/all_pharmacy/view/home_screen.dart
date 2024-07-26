import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/social_media/chat/view/chats.dart';
import 'package:joy_app/modules/social_media/friend_request/bloc/friends_bloc.dart';
import 'package:joy_app/modules/social_media/media_post/view/bottom_modal_post.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/home_screen.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_detail_screen.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_screen.dart';
import 'package:joy_app/view/user_flow/hospital_user/hospital_detail_screen.dart';
import 'package:joy_app/view/home/my_profile.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/rounded_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../pharmacy/bloc/create_prodcut_bloc.dart';
import '../../../../../styles/colors.dart';
import 'product_screen.dart';

class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({super.key});

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  final pharmacyController = Get.put(AllPharmacyController());
  final productsController = Get.put(ProductController());
  final profileController = Get.put(ProfileController());
  ProfileController _profileController = Get.put(ProfileController());
  FriendsSocialController _friendSocialController =
      Get.put(FriendsSocialController());
  @override
  void initState() {
    super.initState();
    pharmacyController.getPharmacyProduct(false, '');
    productsController.allOrders('', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          showBottom: true,
          title: '',
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SvgPicture.asset('Assets/icons/joy-icon-small.svg'),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff191919)
                    : Color(0xffF3F4F6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SvgPicture.asset('Assets/icons/search-normal.svg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ThemeUtil.isDarkMode(context)
                      ? Color(0xff191919)
                      : Color(0xffF3F4F6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child: InkWell(
                    onTap: () {
                      Get.to(AllChats(), transition: Transition.native);
                    },
                    child: SvgPicture.asset('Assets/icons/sms.svg'),
                  )),
                ),
              ),
            )
          ],
          showIcon: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await pharmacyController.getPharmacyProduct(false, '');
          await productsController.allOrders('', context);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => CreatePostModal(),
                          );
                        },
                        child: TextField(
                          enabled: false,
                          maxLines: null,
                          cursorColor: AppColors.borderColor,
                          style: CustomTextStyles.lightTextStyle(
                              color: AppColors.borderColor),
                          decoration: InputDecoration(
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            fillColor: Colors.transparent,
                            hintText: "What's on your mind?",
                            hintStyle: CustomTextStyles.lightTextStyle(
                                color: AppColors.borderColor),
                          ),
                        ),
                      ),
                    ),
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
                    )
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(MyOrderScreen(),
                              transition: Transition.native);
                        },
                        child: HeaderMenu(
                          bgColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.purpleBlueColor
                              : AppColors.lightBlueColore5e,
                          imgbgColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.darkishBlueColorb46
                              : AppColors.lightBlueColord0d,
                          imagepath: 'Assets/icons/calendar.svg',
                          title: 'Orders',
                          subTitle: 'Manage Orders',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                              ProductScreen(
                                isAdmin: true,
                                userId: '3',
                              ),
                              transition: Transition.native);
                        },
                        child: HeaderMenu(
                          bgColor: AppColors.lightGreenColor,
                          imgbgColor: AppColors.lightGreenColorFC7,
                          imagepath: 'Assets/icons/menu-board.svg',
                          title: 'Stocks',
                          subTitle: 'Manage Stocks',
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  children: [
                    Text(
                      'Ongoing Orders',
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.lightBlueColor3e3
                              : null),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(MyOrderScreen(), transition: Transition.native);
                      },
                      child: Text(
                        'See All',
                        style: CustomTextStyles.lightSmallTextStyle(size: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Obx(
                  () => productsController.onTheWayOrders.length < 1
                      ? Column(
                          children: [
                            Text('No Orders Yet'),
                            SizedBox(
                              height: 1.h,
                            ),
                            Obx(() => RoundedButtonSmall(
                                showLoader:
                                    pharmacyController.allProductLoader.value,
                                text: 'refresh',
                                onPressed: () async {
                                  await pharmacyController.getPharmacyProduct(
                                      false, '');
                                  await productsController.allOrders(
                                      '', context);
                                },
                                backgroundColor: AppColors.darkGreenColor,
                                textColor: Colors.white))
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              productsController.onTheWayOrders.length > 2
                                  ? 2
                                  : productsController.onTheWayOrders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    OrderDetailScreen(
                                      orderDetail: productsController
                                          .onTheWayOrders[index],
                                    ),
                                    transition: Transition.native);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: MeetingCallScheduler(
                                  onPressed: () {
                                    productsController.updateOrderStatus(
                                        productsController
                                            .onTheWayOrders[index].orderId
                                            .toString(),
                                        'Delivered',
                                        context);
                                  },
                                  pharmacyButtonText: 'Marked as Deliverd',
                                  isPharmacy: true,
                                  buttonColor: ThemeUtil.isDarkMode(context)
                                      ? AppColors.lightGreenColoreb1
                                      : AppColors.darkGreenColor,
                                  bgColor: AppColors.lightGreenColor,
                                  nextMeeting: true,
                                  imgPath: '',
                                  name: 'Order Id: ' +
                                      productsController
                                          .onTheWayOrders[index].orderId
                                          .toString(),
                                  time: '',
                                  location: productsController
                                      .onTheWayOrders[index].location
                                      .toString(),
                                  category: productsController
                                          .onTheWayOrders[index].quantity
                                          .toString() +
                                      ' Tablets',
                                ),
                              ),
                            );
                          },
                        ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading(
                        title: 'Reviews',
                      ),
                      SizedBox(height: 2.h),
                      UserRatingWidget(
                        image: '',
                        docName: 'Emily Anderson',
                        reviewText: '',
                        rating: '5',
                      ),
                      SizedBox(height: 1.h),
                      UserRatingWidget(
                        image: '',
                        docName: 'Emily Anderson',
                        reviewText: '',
                        rating: '5',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
