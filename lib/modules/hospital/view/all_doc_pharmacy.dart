import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/modules/social_media/friend_request/view/new_friend.dart';
import 'package:joy_app/modules/user/user_doctor/view/doctor_detail_screen2.dart';
import 'package:joy_app/modules/user/user_hospital/view/widgets/reviewbar_widget.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/models/all_pharmacy_model.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/Widgets/dailog/confirmation_dailog.dart';
import 'package:sizer/sizer.dart';

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
                          if (widget.isSelectable && widget.isPharmacy) {
                            // Show confirmation dialog for linking pharmacy
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationPharmacyLinkDailog(
                                  pharmacy_id:
                                      filteredList[index].userId.toString(),
                                );
                              },
                            );
                          } else if (widget.isSelectable) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDailog(
                                  link_to_user_id:
                                      filteredList[index].userId.toString(),
                                );
                              },
                            );
                          } else if (widget.isPharmacy) {
                            final pharmacyController = Get.find<AllPharmacyController>();
                            final pharmacyId = filteredList[index]
                                .userId
                                .toString();
                            
                            // Check if cart is empty or same pharmacy
                            if (!pharmacyController.canNavigateToPharmacy(pharmacyId)) {
                              Get.snackbar(
                                'Cart Restriction',
                                'Please empty the cart first to add from other pharmacy',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                duration: Duration(seconds: 3),
                                icon: Icon(Icons.shopping_cart, color: Colors.white),
                              );
                              return;
                            }
                            
                            Get.to(
                              PharmacyProductScreen(
                                  isHospital: widget.isFromHosipital,
                                  userId: pharmacyId),
                              transition: Transition.native);
                          } else {
                            Get.to(
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
                          }
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
                                padding: EdgeInsets.all(widget.isSelectable ? 8.0 : 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        filteredList[index]
                                                .image!
                                                .contains('http')
                                            ? filteredList[index].image!
                                            : 'http://194.233.69.219/joy-Images//c894ac58-b8cd-47c0-94d1-3c4cea7dadab.png',
                                        width: widget.isSelectable ? 20.w : 28.w,
                                        height: widget.isSelectable ? 20.w : 28.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: widget.isSelectable ? 20.w : 28.w,
                                            height: widget.isSelectable ? 20.w : 28.w,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.local_pharmacy, size: widget.isSelectable ? 10.w : 14.w),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            filteredList[index].name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CustomTextStyles.darkTextStyle(
                                              color: ThemeUtil.isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ).copyWith(fontSize: 14),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 12.sp,
                                                color: Color(0xff6B7280),
                                              ),
                                              SizedBox(width: 0.5.w),
                                              Flexible(
                                                child: Text(
                                                  filteredList[index].location.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: CustomTextStyles.lightTextStyle(
                                                    color: Color(0xff6B7280),
                                                    size: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!widget.isSelectable) ...[
                                            SizedBox(height: 0.5.h),
                                            ReviewBar(
                                              rating: '0',
                                              count: filteredList[index].reviews!.length,
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Remove the "-" sign - no remove button in select pharmacy screen
                            Container()
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
