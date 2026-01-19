import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/core/utils/fucntions/utils.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/component/blood_donation_widget.dart';
import 'package:sizer/sizer.dart';

class MyBloodAppeals extends StatefulWidget {
  MyBloodAppeals({super.key});

  @override
  State<MyBloodAppeals> createState() => _MyBloodAppealsState();
}

class _MyBloodAppealsState extends State<MyBloodAppeals> {
  UserBloodBankController _bloodBankController =
      Get.put(UserBloodBankController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'My Appeals',
          style: CustomTextStyles.darkTextStyle(
              color: ThemeUtil.isDarkMode(context)
                  ? AppColors.whiteColor
                  : Color(0xff374151)),
        ),
        centerTitle: true,
      ),
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
                  itemCount: _bloodBankController.allMyRequest.length,
                  itemBuilder: (context, index) {
                    final data = _bloodBankController.allMyRequest[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DonationApproval(
                        city: data.city.toString(),
                        gender: data.gender.toString(),
                        isBloodDonate: true,
                        isPlasmaDonate: false,
                        isOld: true,
                        patName: data.patientName.toString(),
                        date: formatDateTime(data.date.toString(), true),
                        location: data.location.toString(),
                        bloodType: data.bloodGroup.toString(),
                        count: data.unitsOfBlood.toString(),
                        time: data.time.toString(),
                        phoneNo: data.phone.toString(),
                        priority: data.responseTime ?? '', // Pass response_time as priority
                        bloodId: data.bloodId, // Pass bloodId for Complete Request button
                        donorDetails: data.donorDetails, // Pass donorDetails
                        donorUserId: data.donorUserId, // Pass donorUserId
                        userDetails: data.userDetails, // Pass userDetails
                        status: data.status, // Pass status to check if completed
                        isBloodBank: false, // User mode, not blood bank mode
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
