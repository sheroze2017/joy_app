import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/view/bloodbank_flow/component/blood_donation_widget.dart';
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
                  SizedBox(
                    height: 2.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
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
                  SizedBox(
                    height: 2.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  DonationApproval(
                    isUser: widget.isUser,
                    isBloodDonate: widget.isBloodDontate,
                    isPlasmaDonate: widget.isPlasmaDonate,
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
