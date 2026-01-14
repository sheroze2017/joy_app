import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/custom_message/flutter_toast_message.dart';
import 'package:joy_app/modules/user/user_blood_bank/bloc/user_blood_bloc.dart';
import 'package:joy_app/modules/blood_bank/bloc/blood_bank_bloc.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/component/donors_card.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/fucntions/utils.dart';

class DonationApproval extends StatelessWidget {
  bool isBloodDonate;
  bool isPlasmaDonate;
  bool isOld;
  String date;
  String patName;
  String count;
  String priority;
  String location;
  String bloodType;
  bool isUser;
  String time;
  String phoneNo;
  String city;
  String gender;
  dynamic bloodId; // Add bloodId parameter
  UserDetails? userDetails; // Add userDetails parameter
  DonorDetails? donorDetails; // Add donorDetails parameter
  dynamic donorUserId; // Add donorUserId parameter
  bool isBloodBank; // Add isBloodBank parameter

  DonationApproval(
      {this.isBloodDonate = false,
      this.isPlasmaDonate = false,
      this.isOld = false,
      this.date = '',
      this.patName = '',
      this.count = '4',
      this.priority = '',
      this.location = 'Cardiology Center, USA',
      this.bloodType = 'B+',
      this.isUser = false,
      this.time = '',
      this.phoneNo = '',
      this.city = '',
      this.gender = '',
      this.bloodId,
      this.userDetails,
      this.donorDetails,
      this.donorUserId,
      this.isBloodBank = false});
  UserBloodBankController _userBloodBankController =
      Get.put(UserBloodBankController());
  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Color(0xffF4F4F4)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date + ' ' + convertTimeFormat(time),
              style: CustomTextStyles.darkHeadingTextStyle(size: 14),
            ),
            Divider(
              color: Color(0xffE5E7EB),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient: ' + patName,
                            style: CustomTextStyles.darkHeadingTextStyle(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            'Need: ${count} unit ${isBloodDonate ? 'of ${bloodType} Blood' : ''}',
                            style: CustomTextStyles.w600TextStyle(
                                size: 14, color: Color(0xff4B5563)),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('Assets/icons/location.svg'),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              Expanded(
                                  child: Text(location,
                                      style: CustomTextStyles.lightTextStyle(
                                          color: Color(0xff4B5563), size: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Show donor details if donor is attached
            if (donorDetails != null) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.redLightColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.redColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite,
                            color: AppColors.redColor, size: 16),
                        SizedBox(width: 0.5.w),
                        Text(
                          'Donor Attached',
                          style: CustomTextStyles.w600TextStyle(
                            size: 14,
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.8.h),
                    if (donorDetails!.name != null &&
                        donorDetails!.name!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'Donor: ${donorDetails!.name!}',
                          style:
                              CustomTextStyles.darkHeadingTextStyle(size: 13),
                        ),
                      ),
                    if (donorDetails!.bloodGroup != null &&
                        donorDetails!.bloodGroup!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Text(
                              'Blood Group: ',
                              style: CustomTextStyles.w600TextStyle(
                                size: 12,
                                color: Color(0xff4B5563),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.redLightColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                donorDetails!.bloodGroup!,
                                style: CustomTextStyles.w600TextStyle(
                                  size: 12,
                                  color: AppColors.redColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (donorDetails!.location != null &&
                        donorDetails!.location!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            SvgPicture.asset('Assets/icons/location.svg',
                                width: 12, height: 12),
                            SizedBox(width: 0.3.w),
                            Expanded(
                              child: Text(
                                donorDetails!.location!,
                                style: CustomTextStyles.lightTextStyle(
                                  size: 12,
                                  color: Color(0xff4B5563),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (donorDetails!.phone != null &&
                        donorDetails!.phone!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.phone,
                                size: 12, color: Color(0xff4B5563)),
                            SizedBox(width: 0.3.w),
                            Expanded(
                              child: Text(
                                donorDetails!.phone!,
                                style: CustomTextStyles.lightTextStyle(
                                  size: 12,
                                  color: Color(0xff4B5563),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makingPhoneCall(donorDetails!.phone!);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Call',
                                  style: CustomTextStyles.w600TextStyle(
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            Divider(
              color: Color(0xffE5E7EB),
            ),
            Builder(
              builder: (context) {
                // Determine button visibility based on donor status
                final currentUserId = _profileController.userId.value;
                final isDonorAttached =
                    donorDetails != null && donorUserId != null;
                final isCurrentUserDonor =
                    isDonorAttached && donorUserId.toString() == currentUserId;

                // Button logic:
                // 1. If isOld (My Requests): Show Cancel button
                // 2. If donor attached AND I am the donor: Show Cancel and Contact, hide Donate
                // 3. If donor attached AND I am NOT the donor: Show only Contact, hide Donate
                // 4. If no donor attached: Show Donate and Contact

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Show Cancel button if: isOld OR (donor attached AND I am the donor)
                    if (isOld || (isDonorAttached && isCurrentUserDonor)) ...[
                      Expanded(
                        child: RoundedButtonSmall(
                            text: 'Cancel',
                            onPressed: () {
                              if (isOld && bloodId != null) {
                                // Show confirmation alert for cancel request
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Cancel Request'),
                                      content: Text(
                                          'Are you sure you want to cancel this blood request?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(dialogContext).pop();
                                            // Delete the request
                                            await _userBloodBankController
                                                .deleteBloodRequest(
                                              bloodId.toString(),
                                              context,
                                            );
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  color: AppColors.redColor)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (isDonorAttached &&
                                  isCurrentUserDonor &&
                                  bloodId != null) {
                                // Show confirmation alert for cancel donor attachment
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Cancel Donor Attachment'),
                                      content: Text(
                                          'Are you sure you want to cancel your donor attachment?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(dialogContext).pop();
                                            // Detach donor - use donor_details._id as user_id
                                            if (donorDetails != null &&
                                                donorDetails!.id != null) {
                                              await _userBloodBankController
                                                  .detachDonorFromBloodRequest(
                                                bloodId.toString(),
                                                donorDetails!.id.toString(),
                                                context,
                                              );
                                            } else {
                                              showErrorMessage(context,
                                                  'Donor details not available');
                                            }
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  color: AppColors.redColor)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            backgroundColor: isBloodDonate
                                ? AppColors.redColor
                                : AppColors.yellowColor,
                            textColor: isBloodDonate
                                ? AppColors.whiteColor
                                : Colors.black),
                      ),
                      SizedBox(width: 2.w),
                    ],
                    // Show Donate button only if: no donor attached AND not isOld
                    if (!isDonorAttached && !isOld) ...[
                      Expanded(
                        child: RoundedButtonSmall(
                            text: 'Donate',
                            onPressed: () {
                              if (bloodId != null) {
                                // Show confirmation alert for donate
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Attach as Donor'),
                                      content: Text(
                                          'Are you sure you want to attach yourself as a donor for this blood request?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(dialogContext).pop();
                                            // Attach as donor - use appropriate controller
                                            if (isBloodBank) {
                                              try {
                                                final bloodBankController = Get.find<BloodBankController>();
                                                final success = await bloodBankController
                                                    .attachDonorToBloodRequest(
                                                  bloodId.toString(),
                                                  context,
                                                );
                                                if (success) {
                                                  // Refresh the list by calling getAllBloodRequest
                                                  await bloodBankController.getAllBloodRequest();
                                                  showSuccessMessage(context, 'You have been attached as a donor successfully');
                                                }
                                              } catch (e) {
                                                showErrorMessage(context, 'Error: ${e.toString()}');
                                              }
                                            } else {
                                              await _userBloodBankController
                                                  .attachDonorToBloodRequest(
                                                bloodId.toString(),
                                                context,
                                              );
                                            }
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  color: AppColors.redColor)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            backgroundColor: isBloodDonate
                                ? AppColors.redColor
                                : AppColors.yellowColor,
                            textColor: isBloodDonate
                                ? AppColors.whiteColor
                                : Colors.black),
                      ),
                      SizedBox(width: 2.w),
                    ],
                    // Show Contact button if: not isOld OR (donor attached)
                    if (!isOld || isDonorAttached) ...[
                      Expanded(
                        child: RoundedButtonSmall(
                            text: isUser ? 'Share' : 'Contact',
                            onPressed: () {
                              // Show user details alert
                              if (userDetails != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Contact Details'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (userDetails!.name != null &&
                                              userDetails!.name!.isNotEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Name:',
                                                          style: CustomTextStyles
                                                              .w600TextStyle(
                                                                  size: 12),
                                                        ),
                                                        SizedBox(height: 4),
                                                        SelectableText(
                                                          userDetails!.name!,
                                                          style: CustomTextStyles
                                                              .lightTextStyle(
                                                                  size: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.copy,
                                                        size: 18),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: userDetails!
                                                                  .name!));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Name copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (userDetails!.phone != null &&
                                              userDetails!.phone!.isNotEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Phone:',
                                                          style: CustomTextStyles
                                                              .w600TextStyle(
                                                                  size: 12),
                                                        ),
                                                        SizedBox(height: 4),
                                                        SelectableText(
                                                          userDetails!.phone!,
                                                          style: CustomTextStyles
                                                              .lightTextStyle(
                                                                  size: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.copy,
                                                        size: 18),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: userDetails!
                                                                  .phone!));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Phone copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (userDetails!.email != null &&
                                              userDetails!.email!.isNotEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Email:',
                                                          style: CustomTextStyles
                                                              .w600TextStyle(
                                                                  size: 12),
                                                        ),
                                                        SizedBox(height: 4),
                                                        SelectableText(
                                                          userDetails!.email!,
                                                          style: CustomTextStyles
                                                              .lightTextStyle(
                                                                  size: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.copy,
                                                        size: 18),
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: userDetails!
                                                                  .email!));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Email copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text('Close'),
                                        ),
                                        if (userDetails!.phone != null &&
                                            userDetails!.phone!.isNotEmpty)
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                              makingPhoneCall(
                                                  userDetails!.phone!);
                                            },
                                            child: Text('Call',
                                                style: TextStyle(
                                                    color: AppColors.redColor)),
                                          ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Fallback to phone number if userDetails not available
                                makingPhoneCall(phoneNo);
                              }
                            },
                            backgroundColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.blackColor
                                : AppColors.whiteColor,
                            textColor: ThemeUtil.isDarkMode(context)
                                ? AppColors.whiteColor
                                : isBloodDonate
                                    ? AppColors.redColor
                                    : AppColors.yellowColor),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
