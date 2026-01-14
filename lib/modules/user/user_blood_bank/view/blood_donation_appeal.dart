import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/utils/fucntions/utils.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/component/blood_donation_widget.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:sizer/sizer.dart';

class BloodDonationAppealUser extends StatefulWidget {
  bool isBloodDontate;
  bool isPlasmaDonate;
  bool isUser;
  BloodDonationAppealUser(
      {this.isBloodDontate = false,
      this.isPlasmaDonate = false,
      this.isUser = false});

  @override
  State<BloodDonationAppealUser> createState() =>
      _BloodDonationAppealUserState();
}

class _BloodDonationAppealUserState extends State<BloodDonationAppealUser>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load blood requests data
    _bloodBankController.getAllBloodRequest();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  UserBloodBankController _bloodBankController =
      Get.put(UserBloodBankController());
  final _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Column(
          children: [
            Text(
              widget.isBloodDontate ? 'Blood Appeals' : 'Plasma Appeals',
              style: CustomTextStyles.darkTextStyle(
                  color: ThemeUtil.isDarkMode(context)
                      ? AppColors.whiteColor
                      : Color(0xff374151)),
            ),
            Obx(() {
              // Count all requests with ACTIVE or OPEN status (both blood and plasma)
              final allRequests = widget.isBloodDontate
                  ? _bloodBankController.allBloodRequest
                  : _bloodBankController.allPlasmaRequest;
              // Count requests with ACTIVE or OPEN status (API returns ACTIVE, not OPEN)
              final activeCount = allRequests
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
          indicatorColor: widget.isBloodDontate
              ? AppColors.redColor
              : AppColors.yellowColor,
          labelColor: widget.isBloodDontate
              ? AppColors.redColor
              : AppColors.yellowColor,
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
                    // Filter requests where user_id != current user_id (other people's requests)
                    final allRequests = widget.isBloodDontate
                        ? _bloodBankController.allBloodRequest
                        : _bloodBankController.allPlasmaRequest;
                    
                    // If no requests loaded yet, show loading or empty
                    if (allRequests.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Text(
                            'Loading requests...',
                            style: CustomTextStyles.lightTextStyle(size: 14),
                          ),
                        ),
                      );
                    }
                    
                    final filteredRequests = allRequests
                        .where((req) {
                          final reqUserId = req.userId?.toString() ?? '';
                          return reqUserId.isNotEmpty && reqUserId != currentUserId;
                        })
                        .toList();
                    
                    if (filteredRequests.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.h),
                          child: Column(
                            children: [
                              Text(
                                'No requests available',
                                style: CustomTextStyles.lightTextStyle(size: 14),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Total requests: ${allRequests.length}',
                                style: CustomTextStyles.lightTextStyle(size: 12),
                              ),
                            ],
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
                              city: data.city.toString(),
                              gender: data.gender.toString(),
                              isBloodDonate: widget.isBloodDontate,
                              isPlasmaDonate: widget.isPlasmaDonate,
                              patName: data.patientName.toString(),
                              date: formatDateTime(data.date.toString(), true),
                              location: data.location.toString(),
                              bloodType: data.bloodGroup.toString(),
                              count: data.unitsOfBlood.toString(),
                              time: data.time.toString(),
                              phoneNo: data.phone.toString(),
                              priority: data.responseTime ?? '', // Pass response_time as priority
                              bloodId: data.bloodId, // Pass bloodId
                              userDetails: data.userDetails, // Pass userDetails
                              donorDetails: data.donorDetails, // Pass donorDetails
                              donorUserId: data.donorUserId, // Pass donorUserId
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
                    // Filter requests where user_id == current user_id
                    final allRequests = widget.isBloodDontate
                        ? _bloodBankController.allBloodRequest
                        : _bloodBankController.allPlasmaRequest;
                    final myRequests = allRequests
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
                                isBloodDonate: widget.isBloodDontate,
                                isPlasmaDonate: widget.isPlasmaDonate,
                                patName: data.patientName.toString(),
                                date: formatDateTime(data.date.toString(), true),
                                location: data.location.toString(),
                                bloodType: data.bloodGroup.toString(),
                                count: data.unitsOfBlood.toString(),
                                time: data.time.toString(),
                                phoneNo: data.phone.toString(),
                                city: data.city.toString(),
                                priority: data.responseTime ?? '', // Pass response_time as priority
                                bloodId: data.bloodId, // Pass bloodId
                                donorDetails: data.donorDetails, // Pass donorDetails
                                donorUserId: data.donorUserId), // Pass donorUserId
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
