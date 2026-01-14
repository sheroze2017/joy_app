import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/common/profile/view/my_profile.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/modules/doctor/view/home_screen.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/view/order_screen.dart';
import 'package:joy_app/modules/user/user_hospital/view/hospital_detail_screen.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/widgets/button/rounded_button.dart';
import 'package:sizer/sizer.dart';
import 'package:joy_app/modules/auth/utils/auth_hive_utils.dart';
import 'package:joy_app/modules/auth/models/user.dart';

import '../../../../pharmacy/bloc/create_prodcut_bloc.dart';
import '../../../../../styles/colors.dart';
import 'product_screen.dart';

class PharmacyHomeScreen extends StatefulWidget {
  const PharmacyHomeScreen({super.key});

  @override
  State<PharmacyHomeScreen> createState() => _PharmacyHomeScreenState();
}

class _PharmacyHomeScreenState extends State<PharmacyHomeScreen> {
  final pharmacyController = Get.put(AllPharmacyController());
  final productsController = Get.put(ProductController());
  final profileController = Get.put(ProfileController());
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'SHIPPED':
      case 'OUT_FOR_DELIVERY':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  Widget _buildStatusButton(String status, String orderId) {
    if (status == 'PENDING') {
      return Row(
        children: [
          Expanded(
            child: RoundedButtonSmall(
              text: 'Accept',
              onPressed: () {
                productsController.updateOrderStatus(
                  orderId,
                  'CONFIRMED',
                  context,
                );
              },
              backgroundColor: AppColors.darkGreenColor,
              textColor: Colors.white,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: RoundedButtonSmall(
              text: 'Cancel',
              onPressed: () {
                productsController.updateOrderStatus(
                  orderId,
                  'CANCELLED',
                  context,
                );
              },
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ],
      );
    } else if (status == 'CONFIRMED') {
      return RoundedButtonSmall(
        text: 'Out for Delivery',
        onPressed: () {
          productsController.updateOrderStatus(
            orderId,
            'OUT_FOR_DELIVERY',
            context,
          );
        },
        backgroundColor: AppColors.darkGreenColor,
        textColor: Colors.white,
      );
    } else if (status == 'OUT_FOR_DELIVERY') {
      return RoundedButtonSmall(
        text: 'Delivered',
        onPressed: () {
          productsController.updateOrderStatus(
            orderId,
            'DELIVERED',
            context,
          );
        },
        backgroundColor: AppColors.darkGreenColor,
        textColor: Colors.white,
      );
    }
    return Container();
  }
  
  @override
  void initState() {
    super.initState();
    pharmacyController.getPharmacyProduct(false, '');
    productsController.allOrders('', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await pharmacyController.getPharmacyProduct(false, '');
          await productsController.allOrders('', context);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60.0, bottom: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(MyOrderScreen(),
                              transition: Transition.native);
                        },
                        child: HeaderMenu(
                          bgColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.purpleBlueColor
                              : AppColors.lightBlueColore5e,
                          imgbgColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.darkishBlueColorb46
                              : AppColors.lightBlueColord0d,
                          imagepath: 'Assets/icons/calendar.svg',
                          title: 'Orders',
                          subTitle: 'Manage Orders',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          UserHive? currentUser = await getCurrentUser();
                          if (currentUser != null) {
                            Get.to(
                                ProductScreen(
                                  isAdmin: true,
                                  userId: currentUser.userId.toString(),
                                ),
                                transition: Transition.native);
                          }
                        },
                        child: HeaderMenu(
                          bgColor: AppColors.lightGreenColor,
                          imgbgColor: AppColors.lightGreenColorFC7,
                          imagepath: 'Assets/icons/menu-board.svg',
                          title: 'Stocks',
                          subTitle: 'Manage Stocks',
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  children: [
                    Text(
                      'Ongoing Orders',
                      style: CustomTextStyles.darkHeadingTextStyle(
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.lightBlueColor3e3
                              : null),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(MyOrderScreen(), transition: Transition.native);
                      },
                      child: Text(
                        'See All',
                        style: CustomTextStyles.lightSmallTextStyle(size: 14),
                      ),
                    ),
                  ],
                ),
               
                Obx(
                  () {
                    // Get all orders (combining pending, confirmed, and on the way)
                    final allActiveOrders = [
                      ...productsController.pendingOrders,
                      ...productsController.confirmedOrders,
                      ...productsController.onTheWayOrders,
                    ];
                    
                    if (allActiveOrders.isEmpty) {
                      return Column(
                        children: [
                          Text('No Orders Yet'),
                        
                          Obx(() => RoundedButtonSmall(
                              showLoader:
                                  pharmacyController.allProductLoader.value,
                              text: 'refresh',
                              onPressed: () async {
                                await pharmacyController.getPharmacyProduct(
                                    false, '');
                                await productsController.allOrders(
                                    '', context);
                              },
                              backgroundColor: AppColors.darkGreenColor,
                              textColor: Colors.white))
                        ],
                      );
                    }
                    
                    // Show max 2 orders on home screen
                    final displayOrders = allActiveOrders.take(2).toList();
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: displayOrders.length,
                      itemBuilder: (context, index) {
                        final order = displayOrders[index];
                        final status = order.status?.toUpperCase() ?? '';
                        
                        // Get items from order (prefer items over cart)
                        final orderItems = order.items ?? order.cart ?? [];
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGreenColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Customer', // Placeholder - can be enhanced to fetch actual user name
                                          style: CustomTextStyles.darkTextStyle(
                                            color: ThemeUtil.isDarkMode(context)
                                                ? AppColors.whiteColor
                                                : Color(0xff374151),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          status,
                                          style: CustomTextStyles.lightTextStyle(
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // Display items with name, qty, and price
                                  ...orderItems.map<Widget>((item) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${item.productName ?? 'N/A'}',
                                              style: CustomTextStyles.w600TextStyle(
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Qty: ${item.qty ?? '0'}',
                                            style: CustomTextStyles.lightTextStyle(
                                              size: 12,
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            '${item.price ?? '0'} Rs',
                                            style: CustomTextStyles.w600TextStyle(
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  SizedBox(height: 8),
                                  Divider(color: Colors.grey.withOpacity(0.3)),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Location: ${order.location ?? 'N/A'}',
                                        style: CustomTextStyles.lightTextStyle(
                                          size: 12,
                                        ),
                                      ),
                                      Text(
                                        'Total: ${order.totalPrice ?? 'N/A'} Rs',
                                        style: CustomTextStyles.w600TextStyle(
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  // Status buttons based on order status
                                  _buildStatusButton(status, order.orderId?.toString() ?? ''),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Heading(
                        title: 'Reviews',
                      ),
                      SizedBox(height: 2.h),
                      Obx(() {
                        // Extract reviews from all orders
                        final reviews = <Map<String, dynamic>>[];
                        productsController.pharmaciesOrder.forEach((order) {
                          if (order.review != null && order.review is Map) {
                            final reviewData = order.review as Map<String, dynamic>;
                            if (reviewData['rating'] != null || reviewData['review'] != null) {
                              reviews.add({
                                'rating': reviewData['rating']?.toString() ?? '0',
                                'review': reviewData['review']?.toString() ?? '',
                                'name': reviewData['give_by']?['name']?.toString() ?? 'Anonymous',
                                'image': reviewData['give_by']?['image']?.toString() ?? '',
                              });
                            }
                          }
                        });
                        
                        if (reviews.isEmpty) {
                          return Text(
                            'No reviews yet',
                            style: CustomTextStyles.lightTextStyle(),
                          );
                        }
                        
                        // Show max 2 reviews
                        final displayReviews = reviews.take(2).toList();
                        
                        return Column(
                          children: displayReviews.map((review) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: UserRatingWidget(
                                image: review['image'] ?? '',
                                docName: review['name'] ?? 'Anonymous',
                                reviewText: review['review'] ?? '',
                                rating: review['rating'] ?? '0',
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
