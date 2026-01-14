import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_detail_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';

import '../../../../doctor/view/home_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ordersController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ordersController.allOrders(null, context);
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
          title: Text(
            'My Orders',
            style: CustomTextStyles.darkTextStyle(
                color: ThemeUtil.isDarkMode(context)
                    ? AppColors.whiteColor
                    : Color(0xff374151)),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: ThemeUtil.isDarkMode(context)
                ? AppColors.lightGreenColoreb1
                : AppColors.darkGreenColor,
            labelColor: ThemeUtil.isDarkMode(context)
                ? AppColors.lightGreenColoreb1
                : AppColors.darkGreenColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: CustomTextStyles.w600TextStyle(size: 14),
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(text: 'Confirmed'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: Obx(
          () => TabBarView(
            controller: _tabController,
            children: [
              ordersController.changeStatusLoader.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColors.darkGreenColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: ordersController.pendingOrders.length == 0
                          ? Center(
                              child: Text(
                                "No pending orders found",
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : ListView.builder(
                              itemCount: ordersController.pendingOrders.length,
                              itemBuilder: (context, index) {
                                final order =
                                    ordersController.pendingOrders[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                          OrderDetailScreen(
                                            orderDetail: order,
                                          ),
                                          transition: Transition.native);
                                    },
                                    child: Column(
                                      children: [
                                        MeetingCallScheduler(
                                          // Hide default pharmacy button so we can show
                                          // separate Accept / Reject buttons
                                          isActive: false,
                                          isPharmacy: true,
                                          buttonColor:
                                              ThemeUtil.isDarkMode(context)
                                                  ? AppColors.lightGreenColoreb1
                                                  : AppColors.darkGreenColor,
                                          bgColor: AppColors.lightGreenColor,
                                          nextMeeting: true,
                                          imgPath: '',
                                          name: 'Order Id: ' +
                                              order.orderId.toString(),
                                          time: '',
                                          location:
                                              order.location.toString(),
                                          category: order.quantity.toString() +
                                              ' Tablets',
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RoundedButtonSmall(
                                                text: 'Accept',
                                                onPressed: () {
                                                  ordersController
                                                      .updateOrderStatus(
                                                          order.orderId
                                                              .toString(),
                                                          'CONFIRMED',
                                                          context);
                                                },
                                                backgroundColor:
                                                    ThemeUtil.isDarkMode(
                                                            context)
                                                        ? AppColors
                                                            .lightGreenColoreb1
                                                        : AppColors
                                                            .darkGreenColor,
                                                textColor: AppColors.whiteColor,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: RoundedButtonSmall(
                                                text: 'Reject',
                                                onPressed: () {
                                                  ordersController
                                                      .updateOrderStatus(
                                                          order.orderId
                                                              .toString(),
                                                          'CANCELLED',
                                                          context);
                                                },
                                                backgroundColor:
                                                    ThemeUtil.isDarkMode(
                                                            context)
                                                        ? Color(0xff4B5563)
                                                        : Color(0xffE5E7EB),
                                                textColor:
                                                    AppColors.darkBlueColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

              // Confirmed Tab
              ordersController.changeStatusLoader.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColors.darkGreenColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: ordersController.confirmedOrders.length == 0
                          ? Center(
                              child: Text(
                                "No confirmed orders found",
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  ordersController.confirmedOrders.length,
                              itemBuilder: (context, index) {
                                final order =
                                    ordersController.confirmedOrders[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                        OrderDetailScreen(
                                          orderDetail: order,
                                        ),
                                        transition: Transition.native);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: MeetingCallScheduler(
                                      pharmacyButtonText:
                                          'Marked as Out for delivery',
                                      onPressed: () {
                                        ordersController.updateOrderStatus(
                                            order.orderId.toString(),
                                            'OUT_FOR_DELIVERY',
                                            context);
                                      },
                                      isPharmacy: true,
                                      buttonColor: ThemeUtil.isDarkMode(context)
                                          ? AppColors.lightGreenColoreb1
                                          : AppColors.darkGreenColor,
                                      bgColor: AppColors.lightGreenColor,
                                      nextMeeting: true,
                                      imgPath: '',
                                      name: 'Order Id: ' +
                                          order.orderId.toString(),
                                      time: '',
                                      location:
                                          order.location.toString(),
                                      category:
                                          order.quantity.toString() +
                                              ' Tablets',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

              // Delivered Tab (shows OUT_FOR_DELIVERY and DELIVERED)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: (ordersController.onTheWayOrders.length == 0 &&
                        ordersController.deliveredOrders.length == 0)
                    ? Center(
                        child: Text(
                          "No order delivered yet",
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ordersController.onTheWayOrders.length +
                            ordersController.deliveredOrders.length,
                        itemBuilder: (context, index) {
                          final bool isOutForDelivery =
                              index < ordersController.onTheWayOrders.length;
                          final order = isOutForDelivery
                              ? ordersController.onTheWayOrders[index]
                              : ordersController.deliveredOrders[
                                  index - ordersController.onTheWayOrders.length];

                          return InkWell(
                            onTap: () {
                              Get.to(
                                  OrderDetailScreen(
                                      orderDetail: order),
                                  transition: Transition.native);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: MeetingCallScheduler(
                                isDeliverd:
                                    (order.status?.toUpperCase() == 'DELIVERED'),
                                isPharmacy: true,
                                // If order is still out for delivery, show button to mark delivered
                                isActive: order.status?.toUpperCase() ==
                                        'OUT_FOR_DELIVERY'
                                    ? true
                                    : false,
                                pharmacyButtonText: order.status
                                            ?.toUpperCase() ==
                                        'OUT_FOR_DELIVERY'
                                    ? 'Marked as Delivered'
                                    : '',
                                onPressed: order.status?.toUpperCase() ==
                                        'OUT_FOR_DELIVERY'
                                    ? () {
                                        ordersController.updateOrderStatus(
                                            order.orderId.toString(),
                                            'DELIVERED',
                                            context);
                                      }
                                    : null,
                                buttonColor: ThemeUtil.isDarkMode(context)
                                    ? AppColors.lightGreenColoreb1
                                    : AppColors.darkGreenColor,
                                bgColor: AppColors.lightGreenColor,
                                nextMeeting: true,
                                imgPath: '',
                                name: 'Order Id: ' +
                                    order.orderId.toString(),
                                time: '',
                                location: order.location.toString(),
                                category:
                                    order.quantity.toString() + ' Tablets',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
