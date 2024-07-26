import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:sizer/sizer.dart';

import '../../../view/user_flow/hospital_user/all_hospital_screen.dart';
import '../../../view/user_flow/pharmacy_user/pharmacy_product_screen.dart';

class AllDocPharmacy extends StatelessWidget {
  String appBarText;
  bool isPharmacy;
  List<PharmacyModelData> dataList;
  AllDocPharmacy(
      {super.key,
      required this.appBarText,
      required this.dataList,
      required this.isPharmacy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
          title: appBarText,
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
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: dataList.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.w),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          isPharmacy
                              ? Get.to(
                                  PharmacyProductScreen(
                                      userId:
                                          dataList[index].userId.toString()),
                                  transition: Transition.native)
                              : Get.to(
                                  DoctorDetailScreen2(
                                    doctorId: dataList[index].userId.toString(),
                                    docName: 'Dr. David Patel',
                                    location: 'Golden Cardiology Center',
                                    Category: 'Cardiologist',
                                  ),
                                  transition: Transition.native);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isPharmacy
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
                                    dataList[index].image!.contains('http')
                                        ? dataList[index].image!
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
                                          hospitalName:
                                              dataList[index].name.toString()),
                                      LocationWidget(
                                          location: dataList[index]
                                              .location
                                              .toString()),
                                      ReviewBar(
                                        rating: '0',
                                        count: dataList[index].reviews!.length,
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
                                                          color:
                                                              Color(0xff6B7280),
                                                          size: 10.8))
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              SvgPicture.asset(isPharmacy
                                                  ? 'Assets/icons/pharmacy.svg'
                                                  : 'Assets/icons/hospital.svg'),
                                              SizedBox(
                                                width: 0.5.w,
                                              ),
                                              Text(
                                                  isPharmacy
                                                      ? 'Pharmacy'
                                                      : 'Doctor',
                                                  style: CustomTextStyles
                                                      .lightTextStyle(
                                                          color:
                                                              Color(0xff6B7280),
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
