import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/core/utils/fucntions/utils.dart';
import 'package:joy_app/modules/doctor/view/all_appointment.dart';
import 'package:joy_app/modules/blood_bank/view/component/blood_donation_widget.dart';
import 'package:sizer/sizer.dart';

import '../bloc/blood_bank_bloc.dart';

class BloodDonationAppeal extends StatelessWidget {
  bool isBloodDontate;
  bool isPlasmaDonate;
  BloodDonationAppeal(
      {this.isBloodDontate = false, this.isPlasmaDonate = false});

  BloodBankController _bloodBankController = Get.find<BloodBankController>();

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
              Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: isBloodDontate
                      ? _bloodBankController.allBloodRequest.length
                      : _bloodBankController.allPlasmaRequest.length,
                  itemBuilder: (context, index) {
                    final data = isBloodDontate
                        ? _bloodBankController.allBloodRequest[index]
                        : _bloodBankController.allBloodRequest[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DonationApproval(
                        isBloodDonate: isBloodDontate,
                        isPlasmaDonate: isPlasmaDonate,
                        patName: data.patientName.toString(),
                        date: formatDateTime(data.date.toString(), true),
                        location: data.location.toString(),
                        bloodType: data.bloodGroup.toString(),
                        count: data.unitsOfBlood.toString(),
                        time: data.time.toString(),
                        phoneNo: data.phone.toString(),
                        city: data.city.toString(),
                        gender: data.gender.toString(),
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
    );
  }
}
