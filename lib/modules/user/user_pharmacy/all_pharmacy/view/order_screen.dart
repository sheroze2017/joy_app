import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/modules/pharmacy/bloc/create_prodcut_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_detail_screen.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';

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
              Tab(text: 'On the way'),
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
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                        OrderDetailScreen(
                                          orderDetail: ordersController
                                              .pendingOrders[index],
                                        ),
                                        transition: Transition.native);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: MeetingCallScheduler(
                                      onPressed: () {
                                        ordersController.updateOrderStatus(
                                            ordersController
                                                .pendingOrders[index].orderId
                                                .toString(),
                                            'On the way',
                                            context);
                                      },
                                      pharmacyButtonText: 'Marked as Shipped',
                                      isPharmacy: true,
                                      buttonColor: ThemeUtil.isDarkMode(context)
                                          ? AppColors.lightGreenColoreb1
                                          : AppColors.darkGreenColor,
                                      bgColor: AppColors.lightGreenColor,
                                      nextMeeting: true,
                                      imgPath: '',
                                      name: 'Order Id: ' +
                                          ordersController
                                              .pendingOrders[index].orderId
                                              .toString(),
                                      time: '',
                                      location: ordersController
                                          .pendingOrders[index].location
                                          .toString(),
                                      category: ordersController
                                              .pendingOrders[index].quantity
                                              .toString() +
                                          ' Tablets',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

              // On the way Tab
              ordersController.changeStatusLoader.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColors.darkGreenColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: ordersController.onTheWayOrders.length == 0
                          ? Center(
                              child: Text(
                                "No order on the way",
                                style: CustomTextStyles.lightTextStyle(),
                              ),
                            )
                          : ListView.builder(
                              itemCount: ordersController.onTheWayOrders.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                        OrderDetailScreen(
                                          orderDetail: ordersController
                                              .onTheWayOrders[index],
                                        ),
                                        transition: Transition.native);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: MeetingCallScheduler(
                                      pharmacyButtonText: 'Marked as Deliverd',
                                      onPressed: () {
                                        ordersController.updateOrderStatus(
                                            ordersController
                                                .onTheWayOrders[index].orderId
                                                .toString(),
                                            'Delivered',
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
                                          ordersController
                                              .onTheWayOrders[index].orderId
                                              .toString(),
                                      time: '',
                                      location: ordersController
                                          .onTheWayOrders[index].location
                                          .toString(),
                                      category: ordersController
                                              .onTheWayOrders[index].quantity
                                              .toString() +
                                          ' Tablets',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

              // Delivered Tab
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: ordersController.deliveredOrders.length == 0
                    ? Center(
                        child: Text(
                          "No order delivered yet",
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ordersController.deliveredOrders.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  OrderDetailScreen(
                                      orderDetail: ordersController
                                          .deliveredOrders[index]),
                                  transition: Transition.native);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: MeetingCallScheduler(
                                isDeliverd: true,
                                isPharmacy: true,
                                isActive: false,
                                buttonColor: ThemeUtil.isDarkMode(context)
                                    ? AppColors.lightGreenColoreb1
                                    : AppColors.darkGreenColor,
                                bgColor: AppColors.lightGreenColor,
                                nextMeeting: true,
                                imgPath: '',
                                name: 'Order Id: ' +
                                    ordersController
                                        .deliveredOrders[index].orderId
                                        .toString(),
                                time: '',
                                location: ordersController
                                    .deliveredOrders[index].location
                                    .toString(),
                                category: ordersController
                                        .deliveredOrders[index].quantity
                                        .toString() +
                                    ' Tablets',
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
