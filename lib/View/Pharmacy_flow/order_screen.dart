import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/View/Pharmacy_flow/order_detail_screen.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

import '../user_flow/Doctor_flow/home_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: CustomTextStyles.darkTextStyle(color: Color(0xff374151)),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.darkGreenColor,
          labelColor: AppColors.darkGreenColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: CustomTextStyles.w600TextStyle(size: 16),
          tabs: [
            Tab(
              text: 'Pending',
            ),
            Tab(text: 'On the way'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    pharmacyButtonText: 'Marked as Shipped',
                    isPharmacy: true,
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    nextMeeting: true,
                    imgPath: 'Assets/images/tablet.jpg',
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
                SizedBox(
                  height: 0.75.h,
                ),
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    isPharmacy: true,
                    pharmacyButtonText: 'Marked as Shipped',
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    imgPath: 'Assets/images/tablet.jpg',
                    nextMeeting: true,
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    pharmacyButtonText: 'Marked as Deliverd',
                    isPharmacy: true,
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    nextMeeting: true,
                    imgPath: 'Assets/images/tablet.jpg',
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
                SizedBox(
                  height: 0.75.h,
                ),
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    isPharmacy: true,
                    pharmacyButtonText: 'Marked as Deliverd',
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    imgPath: 'Assets/images/tablet.jpg',
                    nextMeeting: true,
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    isDeliverd: true,
                    isPharmacy: true,
                    isActive: false,
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    nextMeeting: true,
                    imgPath: 'Assets/images/tablet.jpg',
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
                SizedBox(
                  height: 0.75.h,
                ),
                InkWell(
                  onTap: () {
                    Get.to(OrderDetailScreen());
                  },
                  child: MeetingCallScheduler(
                    isActive: false,
                    isDeliverd: true,
                    isPharmacy: true,
                    buttonColor: AppColors.darkGreenColor,
                    bgColor: AppColors.lightGreenColor,
                    imgPath: 'Assets/images/tablet.jpg',
                    nextMeeting: true,
                    name: 'Panadol',
                    time: 'May 22, 2023 - 10.00 AM',
                    location: 'Elite Ortho Clinic USA',
                    category: '10 Tablets',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
