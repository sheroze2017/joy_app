import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/view/Doctor_flow/all_appointment.dart';
import 'package:joy_app/view/bloodbank_flow/component/blood_donation_widget.dart';
import 'package:sizer/sizer.dart';

class BloodDonationAppeal extends StatelessWidget {
  bool isBloodDontate;
  bool isPlasmaDonate;
  BloodDonationAppeal(
      {this.isBloodDontate = false, this.isPlasmaDonate = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: isBloodDontate ? 'Blood Appeals' : 'Plasma Appeals',
          leading: Container(),
          actions: [],
          showIcon: false),
      body: SingleChildScrollView(
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
                isBloodDonate: isBloodDontate,
                isPlasmaDonate: isPlasmaDonate,
              ),
              SizedBox(
                height: 1.h,
              ),
              DonationApproval(
                isBloodDonate: isBloodDontate,
                isPlasmaDonate: isPlasmaDonate,
              ),
              SizedBox(
                height: 1.h,
              ),
              DonationApproval(
                isBloodDonate: isBloodDontate,
                isPlasmaDonate: isPlasmaDonate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
