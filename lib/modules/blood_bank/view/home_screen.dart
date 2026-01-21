import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/blood_bank/model/all_blood_request_model.dart';
import 'package:joy_app/modules/blood_bank/model/all_donors_model.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/location_widget.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/blood_bank/view/blood_appeal_screen.dart';
import 'package:joy_app/modules/user/user_blood_bank/view/request_blood.dart';
import 'package:joy_app/modules/user/user_doctor/view/all_doctor_screen.dart';
import 'package:joy_app/modules/user/user_hospital/view/hospital_detail_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../bloc/blood_bank_bloc.dart';
import '../model/blood_bank_details_model.dart';

class BloodBankHomeScreen extends StatelessWidget {
  BloodBankHomeScreen({super.key});
  BloodBankController _bloodBankController = Get.put(BloodBankController());
  
  // Helper method to format timings display (handles both String and List)
  String _getTimingsDisplayText(dynamic timings) {
    if (timings == null) {
      return 'Timings not available';
    }
    if (timings is String) {
      return timings.isNotEmpty ? timings : 'Timings not available';
    }
    if (timings is List) {
      if (timings.isEmpty) {
        return 'Timings not available';
      }
      // Format list of timing objects
      final List<String> formattedTimings = [];
      for (var timing in timings) {
        if (timing is Map) {
          final day = timing['day']?.toString() ?? '';
          final times = timing['times'];
          if (day.isNotEmpty && times != null) {
            if (times is List) {
              formattedTimings.add('$day: ${times.join(', ')}');
            } else {
              formattedTimings.add('$day: $times');
            }
          }
        }
      }
      return formattedTimings.isEmpty ? 'Timings not available' : formattedTimings.join('\n');
    }
    return 'Timings not available';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => _bloodBankController.bloodBankHomeLoader.value
              ? Center(
                  child: CircularProgressIndicator(
                  color: ThemeUtil.getCurrentTheme(context).primaryColor,
                ))
              : _bloodBankController.bloodBankDetail == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('Error Fetching Data'),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        RoundedButtonSmall(
                            text: 'refresh',
                            onPressed: () async {
                              _bloodBankController.getBloodBankDetail();
                              _bloodBankController.getAllBloodRequest();
                              _bloodBankController.getallDonor();
                            },
                            backgroundColor: AppColors.redColor,
                            textColor: Colors.white)
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _bloodBankController.getBloodBankDetail();
                        await _bloodBankController.getAllBloodRequest();
                        await _bloodBankController.getallDonor();
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 60, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 35.w,
                                child: Obx(() => _HorizontalDoctorCategories(
                                  isBloodBank: true,
                                  bloodBankDetail: _bloodBankController.bloodBankDetail?.data,
                                  bloodRequest:
                                      _bloodBankController.allBloodRequest.toList(),
                                  plasmaRequest:
                                      _bloodBankController.allPlasmaRequest.toList(),
                                  allDonors: _bloodBankController.allDonors.toList(),
                                )),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                _bloodBankController.bloodBankDetail!.data!.name
                                    .toString(),
                                style: CustomTextStyles.darkHeadingTextStyle(
                                    size: 20,
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xff383D44)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: LocationWidget(
                                  isBloodbank: true,
                                  location: _bloodBankController
                                      .bloodBankDetail!.data!.location,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Divider(
                                  color: Color(0xffE5E7EB),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RoundedSVGContainer(
                                      bgColor: AppColors.lightishBlueColorebf,
                                      iconColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC5D3E3)
                                          : Color(0xff1C2A3A),
                                      svgAsset:
                                          'Assets/icons/profile-2user.svg',
                                      numberText: _bloodBankController.bloodBankDetail?.data?.patientsCount != null
                                          ? '${_bloodBankController.bloodBankDetail!.data!.patientsCount!}+'
                                          : '0+',
                                      descriptionText: 'Patients',
                                    ),
                                    RoundedSVGContainer(
                                      bgColor: AppColors.lightishBlueColorebf,
                                      iconColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC5D3E3)
                                          : Color(0xff1C2A3A),
                                      svgAsset: 'Assets/icons/medal.svg',
                                      numberText: _bloodBankController.bloodBankDetail?.data?.experienceYears != null
                                          ? '${_bloodBankController.bloodBankDetail!.data!.experienceYears!}+'
                                          : '0+',
                                      descriptionText: 'experience',
                                    ),
                                    RoundedSVGContainer(
                                      bgColor: AppColors.lightishBlueColorebf,
                                      iconColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC5D3E3)
                                          : Color(0xff1C2A3A),
                                      svgAsset: 'Assets/icons/star.svg',
                                      numberText: _bloodBankController.bloodBankDetail?.data?.rating != null
                                          ? _bloodBankController.bloodBankDetail!.data!.rating!.toStringAsFixed(1)
                                          : '0',
                                      descriptionText: 'rating',
                                    ),
                                    RoundedSVGContainer(
                                      bgColor: AppColors.silverColor4f6,
                                      iconColor: ThemeUtil.isDarkMode(context)
                                          ? Color(0xffC5D3E3)
                                          : Color(0xff1C2A3A),
                                      svgAsset: 'Assets/icons/messages.svg',
                                      numberText: _bloodBankController.bloodBankDetail?.data?.reviewsCount != null
                                          ? '${_bloodBankController.bloodBankDetail!.data!.reviewsCount!}'
                                          : '0',
                                      descriptionText: 'reviews',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'About Blood Bank',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            size: 20,
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xffC8D3E0)
                                                : Color(0xff383D44)),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      BloodBankHomeScreen.showEditAboutSheet(context, _bloodBankController);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Text(
                                        'Edit',
                                        style:
                                            CustomTextStyles.lightSmallTextStyle(
                                                size: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: _bloodBankController.bloodBankDetail?.data?.about != null &&
                                        _bloodBankController.bloodBankDetail!.data!.about!.isNotEmpty
                                    ? ReadMoreText(
                                        _bloodBankController.bloodBankDetail!.data!.about!,
                                        trimMode: TrimMode.Line,
                                        trimLines: 3,
                                        colorClickableText: AppColors.blackColor,
                                        trimCollapsedText: ' view more',
                                        trimExpandedText: ' view less',
                                        style:
                                            CustomTextStyles.lightTextStyle(size: 14),
                                        moreStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        lessStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'No description available.',
                                        style: CustomTextStyles.lightTextStyle(size: 14),
                                      ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Blood Bank Timings',
                                    style:
                                        CustomTextStyles.darkHeadingTextStyle(
                                            size: 20,
                                            color: ThemeUtil.isDarkMode(context)
                                                ? Color(0xffC8D3E0)
                                                : Color(0xff383D44)),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      BloodBankHomeScreen.showEditTimingsSheet(context, _bloodBankController);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Text(
                                        'Edit',
                                        style:
                                            CustomTextStyles.lightSmallTextStyle(
                                                size: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _getTimingsDisplayText(_bloodBankController.bloodBankDetail?.data?.timings),
                                style:
                                    CustomTextStyles.lightTextStyle(size: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        ));
  }

  static void showEditAboutSheet(BuildContext context, BloodBankController controller) {
    final TextEditingController aboutController = TextEditingController(
      text: controller.bloodBankDetail?.data?.about ?? '',
    );
    final FocusNode aboutFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: ThemeUtil.isDarkMode(context) ? Color(0xff161616) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit About',
                    style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      aboutFocusNode.unfocus();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: TextField(
                  controller: aboutController,
                  focusNode: aboutFocusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    aboutFocusNode.unfocus();
                  },
                  style: CustomTextStyles.lightTextStyle(size: 14),
                  decoration: InputDecoration(
                    hintText: 'Enter about blood bank',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                () => RoundedButtonSmall(
                  text: 'Update',
                  onPressed: controller.appointmentLoader.value
                      ? () {}
                      : () {
                          controller.updateAbout(
                            aboutController.text,
                            context,
                          ).then((success) {
                            if (success) {
                              Navigator.pop(context);
                            }
                          });
                        },
                  backgroundColor: AppColors.redColor,
                  textColor: Colors.white,
                  showLoader: controller.appointmentLoader.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showEditTimingsSheet(BuildContext context, BloodBankController controller) {
    final List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final List<String> times = [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
    ];

    int selectedDayIndex = 0;
    Map<int, Set<String>> selectedTimesPerDay = {};
    
    // Initialize with existing timings if available
    final existingTimings = controller.bloodBankDetail?.data?.timings;
    if (existingTimings != null) {
      // Handle timings as either String or List
      if (existingTimings is String && existingTimings.isNotEmpty) {
        // Parse string format: "Monday: 08:00 AM - 09:00 AM" or "Monday: 08:00 AM - 09:00 AM, Tuesday: 10:00 AM - 11:00 AM"
        final parts = existingTimings.split(',');
        for (var part in parts) {
          part = part.trim();
          // Match pattern like "Monday: 08:00 AM - 09:00 AM"
          final dayTimeMatch = RegExp(r'^(\w+):\s*(\d{1,2}:\d{2}\s*(?:AM|PM))\s*-\s*(\d{1,2}:\d{2}\s*(?:AM|PM))').firstMatch(part);
          if (dayTimeMatch != null) {
            final dayName = dayTimeMatch.group(1)!;
            final startTime = dayTimeMatch.group(2)!.trim();
            final endTime = dayTimeMatch.group(3)!.trim();
            
            // Find day index
            final dayIndex = daysOfWeek.indexWhere((day) => day.toLowerCase() == dayName.toLowerCase());
            if (dayIndex != -1) {
              // Initialize set for this day if not exists
              if (selectedTimesPerDay[dayIndex] == null) {
                selectedTimesPerDay[dayIndex] = <String>{};
              }
              
              // Find all time slots between start and end time
              final startIndex = times.indexWhere((t) => t == startTime);
              final endIndex = times.indexWhere((t) => t == endTime);
              
              if (startIndex != -1 && endIndex != -1) {
                // Add all times from start to end (inclusive)
                for (int i = startIndex; i <= endIndex; i++) {
                  if (i < times.length) {
                    selectedTimesPerDay[dayIndex]!.add(times[i]);
                  }
                }
              } else {
                // If exact match not found, try to add start and end times
                if (startIndex != -1) {
                  selectedTimesPerDay[dayIndex]!.add(times[startIndex]);
                }
                if (endIndex != -1) {
                  selectedTimesPerDay[dayIndex]!.add(times[endIndex]);
                }
              }
              
              // Set first day with timings as selected
              if (selectedDayIndex == 0 && selectedTimesPerDay[dayIndex]!.isNotEmpty) {
                selectedDayIndex = dayIndex;
              }
            }
          }
        }
      } else if (existingTimings is List && existingTimings.isNotEmpty) {
        // Handle list format: [{day: "Monday", times: ["08:00 AM", "09:00 AM"]}]
        for (var timing in existingTimings) {
          if (timing is Map) {
            final day = timing['day']?.toString() ?? '';
            final timesList = timing['times'];
            
            if (day.isNotEmpty) {
              // Find day index
              final dayIndex = daysOfWeek.indexWhere((d) => d.toLowerCase() == day.toLowerCase());
              if (dayIndex != -1) {
                // Initialize set for this day if not exists
                if (selectedTimesPerDay[dayIndex] == null) {
                  selectedTimesPerDay[dayIndex] = <String>{};
                }
                
                if (timesList is List) {
                  // Add all times from the list
                  for (var time in timesList) {
                    final timeStr = time.toString().trim();
                    if (times.contains(timeStr)) {
                      selectedTimesPerDay[dayIndex]!.add(timeStr);
                    }
                  }
                } else if (timesList is String) {
                  // Parse string like "08:00 AM - 09:00 AM"
                  final timeRangeMatch = RegExp(r'(\d{1,2}:\d{2}\s*(?:AM|PM))\s*-\s*(\d{1,2}:\d{2}\s*(?:AM|PM))').firstMatch(timesList);
                  if (timeRangeMatch != null) {
                    final startTime = timeRangeMatch.group(1)!.trim();
                    final endTime = timeRangeMatch.group(2)!.trim();
                    
                    final startIndex = times.indexWhere((t) => t == startTime);
                    final endIndex = times.indexWhere((t) => t == endTime);
                    
                    if (startIndex != -1 && endIndex != -1) {
                      for (int i = startIndex; i <= endIndex; i++) {
                        if (i < times.length) {
                          selectedTimesPerDay[dayIndex]!.add(times[i]);
                        }
                      }
                    }
                  } else {
                    // Single time
                    final timeStr = timesList.trim();
                    if (times.contains(timeStr)) {
                      selectedTimesPerDay[dayIndex]!.add(timeStr);
                    }
                  }
                }
                
                // Set first day with timings as selected
                if (selectedDayIndex == 0 && selectedTimesPerDay[dayIndex]!.isNotEmpty) {
                  selectedDayIndex = dayIndex;
                }
              }
            }
          }
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: ThemeUtil.isDarkMode(context) ? Color(0xff161616) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Timings',
                      style: CustomTextStyles.darkHeadingTextStyle(size: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Select Day',
                  style: CustomTextStyles.w600TextStyle(size: 16),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(daysOfWeek.length, (index) {
                    final isSelected = index == selectedDayIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.redColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.redColor,
                          ),
                        ),
                        child: Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isSelected ? Colors.white : AppColors.redColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Select Times for ${daysOfWeek[selectedDayIndex]}',
                  style: CustomTextStyles.w600TextStyle(size: 16),
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: List.generate(times.length, (index) {
                        final time = times[index];
                        final isSelected = selectedTimesPerDay[selectedDayIndex]?.contains(time) ?? false;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedTimesPerDay[selectedDayIndex] == null) {
                                selectedTimesPerDay[selectedDayIndex] = <String>{};
                              }
                              if (isSelected) {
                                selectedTimesPerDay[selectedDayIndex]!.remove(time);
                              } else {
                                selectedTimesPerDay[selectedDayIndex]!.add(time);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.redColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.redColor,
                              ),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isSelected ? Colors.white : AppColors.redColor,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => RoundedButtonSmall(
                    text: 'Update',
                    onPressed: controller.appointmentLoader.value
                        ? () {}
                        : () {
                            // Format timings string
                            List<String> timingStrings = [];
                            for (int i = 0; i < daysOfWeek.length; i++) {
                              final timesForDay = selectedTimesPerDay[i];
                              if (timesForDay != null && timesForDay.isNotEmpty) {
                                final sortedTimes = timesForDay.toList()..sort();
                                if (sortedTimes.length > 0) {
                                  final startTime = sortedTimes.first;
                                  final endTime = sortedTimes.last;
                                  timingStrings.add('${daysOfWeek[i]}: $startTime - $endTime');
                                }
                              }
                            }
                            final timingsString = timingStrings.join(', ');
                            
                            controller.updateTimings(
                              timingsString,
                              context,
                            ).then((success) {
                              if (success) {
                                Navigator.pop(context);
                              }
                            });
                          },
                    backgroundColor: AppColors.redColor,
                    textColor: Colors.white,
                    showLoader: controller.appointmentLoader.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalDoctorCategories extends StatelessWidget {
  bool isBloodBank;
  List<BloodRequest>? plasmaRequest;
  List<BloodRequest>? bloodRequest;
  List<BloodDonor>? allDonors;
  Data? bloodBankDetail;

  _HorizontalDoctorCategories(
      {this.isBloodBank = false,
      this.bloodRequest,
      this.plasmaRequest,
      this.allDonors,
      this.bloodBankDetail});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: isBloodBank ? 3 : 5, // Show 3 cards: Donate Blood, Donate Plasma, Request Blood
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Add padding to the list
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 12.0), // Add spacing between cards
          child: InkWell(
          onTap: () {
            if (isBloodBank) {
              final bloodBankController = Get.find<BloodBankController>();
              if (index == 0) {
                // Donate Blood - defer navigation to avoid setState during build
                Future.microtask(() async {
                  await bloodBankController.getAllBloodRequest();
                  // Small delay to ensure lists are updated
                  await Future.delayed(Duration(milliseconds: 100));
                  Get.to(
                      BloodDonationAppeal(
                        isBloodDontate: true,
                      ),
                      transition: Transition.native);
                });
              } else if (index == 1) {
                // Donate Plasma - defer navigation to avoid setState during build
                Future.microtask(() async {
                  await bloodBankController.getAllBloodRequest();
                  // Small delay to ensure lists are updated
                  await Future.delayed(Duration(milliseconds: 100));
                  Get.to(
                      BloodDonationAppeal(
                        isBloodDontate: false,
                        isPlasmaDonate: true,
                      ),
                      transition: Transition.native);
                });
              } else if (index == 2) {
                // Request Blood - open request blood screen
                Future.microtask(() {
                  Get.to(RequestBlood(), transition: Transition.native);
                });
              }
            }
          },
          child: DoctorCategory(
            isAppeal: (isBloodBank && index == 2) ? true : false, // Request Blood is now index 2
            catrgory: isBloodBank
                ? index == 0
                    ? 'Donate Blood'
                    : index == 1
                        ? 'Donate Plasma'
                        : 'Request Blood' // index == 2
                : 'Dental',
            DoctorCount: isBloodBank
                ? index == 0
                    ? (bloodBankDetail?.activeBloodRequestsCount != null
                        ? '${bloodBankDetail!.activeBloodRequestsCount!}+'
                        : (bloodRequest != null ? '${bloodRequest!.length}+' : '0+'))
                    : index == 1
                        ? (bloodBankDetail?.activePlasmaRequestsCount != null
                            ? '${bloodBankDetail!.activePlasmaRequestsCount!}+'
                            : (plasmaRequest != null ? '${plasmaRequest!.length}+' : '0+'))
                        : (bloodBankDetail?.totalDonorsCount != null
                            ? '${bloodBankDetail!.totalDonorsCount!}+'
                            : (allDonors != null ? '${allDonors!.length}+' : '0+'))
                : '',
            bgColor: isBloodBank
                ? index == 0
                    ? bgColors[0] // Red for Donate Blood
                    : index == 1
                        ? bgColors[1] // Yellow for Donate Plasma
                        : AppColors.lightGreenColor // Green for Request Blood
                : ThemeUtil.isDarkMode(context)
                    ? bgColorsDoctorsDark[index % 2 == 0 ? 0 : 1]
                    : bgColorsDoctors[index % 2 == 0 ? 0 : 1],
            fgColor: isBloodBank
                ? index == 0
                    ? fgColors[0] // Red for Donate Blood
                    : index == 1
                        ? fgColors[1] // Yellow for Donate Plasma
                        : AppColors.darkGreenColor // Dark green for Request Blood
                : fgColorsDoctors[index % 2 == 0 ? 0 : 1],
            imagePath: isBloodBank
                ? index == 0
                    ? bloodBankCatImage[0] // Blood icon
                    : index == 1
                        ? bloodBankCatImage[1] // Plasma icon
                        : 'Assets/icons/blooddrop.svg' // Request Blood icon
                : 'Assets/icons/dental.svg',
            isBloodBank: isBloodBank,
            isUser: !isBloodBank, // Set isUser to false for blood bank to hide circles
          ),
        ),
        );
      },
    );
  }
}
