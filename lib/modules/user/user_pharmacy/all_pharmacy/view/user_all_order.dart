import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/modules/pharmacy/view/review_screen.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_detail_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

import '../../../../doctor/view/home_screen.dart';

class UserAllOrderScreen extends StatefulWidget {
  const UserAllOrderScreen({super.key});

  @override
  State<UserAllOrderScreen> createState() => _UserAllOrderScreenState();
}

class _UserAllOrderScreenState extends State<UserAllOrderScreen> {
  final ordersController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    // Fetching all pharmacies orders
    ordersController.allOrders(null, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pharmacy Orders',
          style: CustomTextStyles.darkTextStyle(
            color: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : Color(0xff374151),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ordersController.changeStatusLoader.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.darkGreenColor,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: ordersController.pharmaciesOrder.length == 0
                    ? Center(
                        child: Text(
                          "No orders found",
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ordersController.pharmaciesOrder.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                OrderDetailScreen(
                                  orderDetail:
                                      ordersController.pharmaciesOrder[index],
                                ),
                                transition: Transition.native,
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: MeetingCallScheduler(
                                onPressed: () {
                                  Get.to(
                                    ReviewScreen(
                                        pharmacyId: ordersController
                                            .pharmaciesOrder[index].userId
                                            .toString(),
                                        buttonBgColor:
                                            AppColors.darkGreenColor),
                                  );
                                  // Here you can update order status if needed
                                },
                                isActive: false,
                                pharmacyButtonText: 'Review',
                                isPharmacy: true,
                                buttonColor: ThemeUtil.isDarkMode(context)
                                    ? AppColors.lightGreenColoreb1
                                    : AppColors.darkGreenColor,
                                bgColor: AppColors.lightGreenColor,
                                nextMeeting: true,
                                imgPath: '',
                                name: 'Order Id: ' +
                                    ordersController
                                        .pharmaciesOrder[index].orderId
                                        .toString() +
                                    '\nStatus: ' +
                                    ordersController
                                        .pharmaciesOrder[index].status
                                        .toString(),
                                time: '',
                                location: ordersController
                                    .pharmaciesOrder[index].location
                                    .toString(),
                                category: ordersController
                                        .pharmaciesOrder[index].quantity
                                        .toString() +
                                    ' Tablets',
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
