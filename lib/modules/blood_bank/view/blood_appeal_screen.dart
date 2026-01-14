import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/blood_bank/view/component/blood_donation_widget.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

import '../bloc/blood_bank_bloc.dart';

class BloodDonationAppeal extends StatefulWidget {
  bool isBloodDontate;
  bool isPlasmaDonate;
  BloodDonationAppeal(
      {this.isBloodDontate = false, this.isPlasmaDonate = false});

  @override
  State<BloodDonationAppeal> createState() => _BloodDonationAppealState();
}

class _BloodDonationAppealState extends State<BloodDonationAppeal> with TickerProviderStateMixin {
  BloodBankController _bloodBankController = Get.find<BloodBankController>();
  final _profileController = Get.find<ProfileController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Data is already loaded before navigation, but refresh if needed
    // Use postFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only refresh if both lists are empty (data might not have loaded)
      if (_bloodBankController.allBloodRequest.isEmpty && 
          _bloodBankController.allPlasmaRequest.isEmpty) {
        _bloodBankController.getAllBloodRequest();
      }
    });
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
        leading: null,
        title: Column(
          children: [
            Text(
              widget.isPlasmaDonate ? 'Plasma Appeals' : 'Blood Appeals',
              style: CustomTextStyles.darkTextStyle(
                  color: ThemeUtil.isDarkMode(context)
                      ? AppColors.whiteColor
                      : Color(0xff374151)),
            ),
            Obx(() {
              // Count requests based on type (blood or plasma)
              final requestsToCount = widget.isPlasmaDonate
                  ? _bloodBankController.allPlasmaRequest
                  : _bloodBankController.allBloodRequest;
              // Count requests with ACTIVE or OPEN status
              final activeCount = requestsToCount
                  .where((req) {
                    final status = req.status?.toUpperCase() ?? '';
                    return status == 'ACTIVE' || status == 'OPEN';
                  })
                  .length;
              return Text(
                '$activeCount Patients waiting',
                style: CustomTextStyles.lightTextStyle(
                    size: 12,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff374151)),
              );
            }),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.redColor,
          labelColor: AppColors.redColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: CustomTextStyles.w600TextStyle(size: 16),
          tabs: [
            Tab(
              text: 'Requests',
            ),
            Tab(text: 'My Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Requests Tab - Show all requests except blood bank's own
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Divider(
                    color: Color(0xffE5E7EB),
                  ),
                  Obx(() {
                    final currentUserId = _profileController.userId.value;
                    // Get requests based on type (blood or plasma)
                    final requestsToShow = widget.isPlasmaDonate
                        ? _bloodBankController.allPlasmaRequest
                        : _bloodBankController.allBloodRequest;
                    
                    // Filter requests where user_id != current user_id (other people's requests)
                    final filteredRequests = requestsToShow
                        .where((req) {
                          final status = req.status?.toUpperCase() ?? '';
                          final reqUserId = req.userId?.toString() ?? '';
                          return (status == 'ACTIVE' || status == 'OPEN') &&
                                 reqUserId.isNotEmpty && 
                                 reqUserId != currentUserId;
                        })
                        .toList();
                    
                    if (filteredRequests.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            'No requests available',
                            style: CustomTextStyles.lightTextStyle(size: 14),
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final data = filteredRequests[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DonationApproval(
                              isBloodDonate: true,
                              isPlasmaDonate: false,
                              patName: data.patientName ?? '',
                              date: data.date ?? '',
                              location: data.location ?? '',
                              bloodType: data.bloodGroup ?? '',
                              count: data.unitsOfBlood?.toString() ?? '',
                              time: data.time ?? '',
                              phoneNo: data.phone ?? '',
                              city: data.city ?? '',
                              gender: data.gender ?? '',
                              priority: data.responseTime ?? '',
                              bloodId: data.bloodId,
                              userDetails: data.userDetails,
                              donorDetails: data.donorDetails,
                              donorUserId: data.donorUserId,
                              isBloodBank: true, // Indicate this is blood bank mode
                            ),
                          );
                        });
                  }),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
          // My Requests Tab - Show only blood bank's own requests
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Divider(
                    color: Color(0xffE5E7EB),
                  ),
                  Obx(() {
                    final currentUserId = _profileController.userId.value;
                    // Get requests based on type (blood or plasma)
                    final requestsToShow = widget.isPlasmaDonate
                        ? _bloodBankController.allPlasmaRequest
                        : _bloodBankController.allBloodRequest;
                    // Filter requests where user_id == current user_id
                    final myRequests = requestsToShow
                        .where((req) => req.userId?.toString() == currentUserId)
                        .toList();
                    
                    if (myRequests.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            'No requests found',
                            style: CustomTextStyles.lightTextStyle(size: 14),
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: myRequests.length,
                        itemBuilder: (context, index) {
                          final data = myRequests[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: DonationApproval(
                              isOld: true,
                              isBloodDonate: true,
                              isPlasmaDonate: false,
                              patName: data.patientName ?? '',
                              date: data.date ?? '',
                              location: data.location ?? '',
                              bloodType: data.bloodGroup ?? '',
                              count: data.unitsOfBlood?.toString() ?? '',
                              time: data.time ?? '',
                              phoneNo: data.phone ?? '',
                              city: data.city ?? '',
                              gender: data.gender ?? '',
                              priority: data.responseTime ?? '',
                              bloodId: data.bloodId,
                              userDetails: data.userDetails,
                              donorDetails: data.donorDetails,
                              donorUserId: data.donorUserId,
                              isBloodBank: true, // Indicate this is blood bank mode
                            ),
                          );
                        });
                  }),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
