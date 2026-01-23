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
  // Helper method to get status color
  static Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        return AppColors.darkGreenColor;
      case 'SHIPPED':
      case 'OUT_FOR_DELIVERY':
        return Colors.blue;
      case 'CONFIRMED':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
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
                          final order = ordersController.pharmaciesOrder[index];
                          final orderId = order.orderId?.toString() ?? 'N/A';
                          final status = order.status?.toString() ?? 'UNKNOWN';
                          final quantity = order.quantity?.toString() ?? '0';
                          final totalPrice = order.totalPrice?.toString() ?? '0';
                          final location = order.location?.toString() ?? '';
                          final itemsCount = (order.items != null && order.items!.isNotEmpty)
                              ? order.items!.length
                              : (order.cart?.length ?? 0);
                          
                          return InkWell(
                            onTap: () {
                              Get.to(
                                OrderDetailScreen(
                                  orderDetail: order,
                                ),
                                transition: Transition.native,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreenColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Color(0xffE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Avatar placeholder
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff2A2A2A)
                                              : Color(0xffE5E5E5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.shopping_bag,
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xff5A5A5A)
                                              : Color(0xffA5A5A5),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      // Order details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Order ID: $orderId',
                                              style: CustomTextStyles.w600TextStyle(
                                                size: 14,
                                                color: ThemeUtil.isDarkMode(context)
                                                    ? AppColors.whiteColor
                                                    : Color(0xff19295C),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: UserAllOrderScreen._getStatusColor(status),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                status,
                                                style: CustomTextStyles.w600TextStyle(
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.inventory_2_outlined,
                                                  size: 14,
                                                  color: ThemeUtil.isDarkMode(context)
                                                      ? Color(0xffC8D3E0)
                                                      : Color(0xff60709D),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '$itemsCount Items',
                                                  style: CustomTextStyles.lightTextStyle(
                                                    size: 12,
                                                    color: ThemeUtil.isDarkMode(context)
                                                        ? Color(0xffC8D3E0)
                                                        : Color(0xff60709D),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 14,
                                                  color: ThemeUtil.isDarkMode(context)
                                                      ? Color(0xffC8D3E0)
                                                      : Color(0xff60709D),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    location,
                                                    style: CustomTextStyles.lightTextStyle(
                                                      size: 12,
                                                      color: ThemeUtil.isDarkMode(context)
                                                          ? Color(0xffC8D3E0)
                                                          : Color(0xff60709D),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Total: Rs. $totalPrice',
                                              style: CustomTextStyles.w600TextStyle(
                                                size: 16,
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
