import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/utils/fucntions/utils.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/component/blood_donation_widget.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  UserBloodBankController _bloodBankController =
      Get.put(UserBloodBankController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          widget.isBloodDontate ? 'Blood Appeals' : 'Plasma Appeals',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.whiteColor
                  : Color(0xff374151)),
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
              text: 'Recent',
            ),
            Tab(text: 'Old'),
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
                  Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.isBloodDontate
                          ? _bloodBankController.allBloodRequest.length
                          : _bloodBankController.allPlasmaRequest.length,
                      itemBuilder: (context, index) {
                        final data = widget.isBloodDontate
                            ? _bloodBankController.allBloodRequest[index]
                            : _bloodBankController.allBloodRequest[index];
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
                          ),
                        );
                      })),
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
                  Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.isBloodDontate
                          ? _bloodBankController.allBloodRequest.length
                          : _bloodBankController.allPlasmaRequest.length,
                      itemBuilder: (context, index) {
                        final data = widget.isBloodDontate
                            ? _bloodBankController.allBloodRequest[index]
                            : _bloodBankController.allBloodRequest[index];
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
                              city: data.city.toString()),
                        );
                      })),
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
