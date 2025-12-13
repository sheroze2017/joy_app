import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/location_widget.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/reviewbar_widget.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/dailog/confirmation_dailog.dart';
import 'package:sizer/sizer.dart';

import '../../user/user_hospital/view/all_hospital_screen.dart';
import '../../pharmacy/view/pharmacy_product_screen.dart';

class AllDocPharmacy extends StatefulWidget {
  bool isSelectable;
  String appBarText;
  bool isPharmacy;
  List<PharmacyModelData> dataList;
  bool isFromHosipital;
  AllDocPharmacy(
      {super.key,
      required this.appBarText,
      this.isSelectable = false,
      required this.dataList,
      required this.isFromHosipital,
      required this.isPharmacy});

  @override
  State<AllDocPharmacy> createState() => _AllDocPharmacyState();
}

class _AllDocPharmacyState extends State<AllDocPharmacy> {
  TextEditingController searchController = TextEditingController();
  List<PharmacyModelData> filteredList = [];

  @override
  void initState() {
    super.initState();
    // Initially, the filtered list is the same as the original list
    filteredList = widget.dataList;
    searchController.addListener(_filterPharmacies);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterPharmacies);
    searchController.dispose();
    super.dispose();
  }

  void _filterPharmacies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = widget.dataList.where((pharmacy) {
        return pharmacy.name?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: widget.appBarText,
          leading: Icon(Icons.arrow_back),
          actions: [],
          showIcon: true),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              RoundedSearchTextField(
                hintText: widget.appBarText,
                controller: searchController,
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.w),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          widget.isSelectable
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDailog(
                                      link_to_user_id:
                                          filteredList[index].userId.toString(),
                                    );
                                  },
                                )
                              : widget.isPharmacy
                                  ? Get.to(
                                      PharmacyProductScreen(
                                          isHospital: widget.isFromHosipital,
                                          userId: filteredList[index]
                                              .userId
                                              .toString()),
                                      transition: Transition.native)
                                  : Get.to(
                                      DoctorDetailScreen2(
                                        isFromHospital: widget.isFromHosipital,
                                        doctorId: filteredList[index]
                                            .userId
                                            .toString(),
                                        docName: 'Dr. David Patel',
                                        location: 'Golden Cardiology Center',
                                        Category: 'Cardiologist',
                                      ),
                                      transition: Transition.native);
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: widget.isPharmacy
                                      ? Color(0xffE2FFE3)
                                      : ThemeUtil.isDarkMode(context)
                                          ? Color(0xff151515)
                                          : Color(0xffEEF5FF),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        filteredList[index]
                                                .image!
                                                .contains('http')
                                            ? filteredList[index].image!
                                            : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                                        width: 28.w,
                                        height: 28.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          HospitalName(
                                              hospitalName: filteredList[index]
                                                  .name
                                                  .toString()),
                                          LocationWidget(
                                              location: filteredList[index]
                                                  .location
                                                  .toString()),
                                          ReviewBar(
                                            rating: '0',
                                            count: filteredList[index]
                                                .reviews!
                                                .length,
                                          ),
                                          Divider(
                                            color: Color(0xff6B7280),
                                            thickness: 0.1.h,
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'Assets/icons/routing.svg'),
                                                  SizedBox(
                                                    width: 0.5.w,
                                                  ),
                                                  Text('0.0 km/0min',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: Color(
                                                                  0xff6B7280),
                                                              size: 10.8))
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(widget
                                                          .isPharmacy
                                                      ? 'Assets/icons/pharmacy.svg'
                                                      : 'Assets/icons/hospital.svg'),
                                                  SizedBox(
                                                    width: 0.5.w,
                                                  ),
                                                  Text(
                                                      widget.isPharmacy
                                                          ? 'Pharmacy'
                                                          : 'Doctor',
                                                      style: CustomTextStyles
                                                          .lightTextStyle(
                                                              color: Color(
                                                                  0xff6B7280),
                                                              size: 10.8))
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            widget.isFromHosipital
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConfirmationUnLinkDailog(
                                              link_to_user_id:
                                                  filteredList[index]
                                                      .userId
                                                      .toString(),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  !ThemeUtil.isDarkMode(context)
                                                      ? Color(0xff0D0D0D)
                                                      : Color(0xffE5E7EB),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              color:
                                                  ThemeUtil.isDarkMode(context)
                                                      ? Color(0xff0D0D0D)
                                                      : Color(0xffE5E7EB),
                                              Icons.remove,
                                              size: 20,
                                            ),
                                          )),
                                    ))
                                : Container()
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
