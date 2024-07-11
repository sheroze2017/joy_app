import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/modules/pharmacy/models/all_orders.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class OrderDetailScreen extends StatefulWidget {
  final PharmacyOrders orderDetail;
  OrderDetailScreen({required this.orderDetail});
  @override
  State<OrderDetailScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<OrderDetailScreen> {
  String? selectedValue;
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();

  final TextEditingController _fnameController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();

  @override
  Widget build(BuildContext context) {
    _fnameController
        .setText('Order ID: ' + widget.orderDetail.orderId.toString());
    _locationController.setText(widget.orderDetail.location.toString());
    _feeController.setText(widget.orderDetail.totalPrice.toString());
    _productsController.setText(widget.orderDetail.quantity.toString());

    return Scaffold(
      appBar: HomeAppBar(
        title: "Order's Details",
        showIcon: true,
        actions: [],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: _fnameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  hintText: 'James',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: _lnameController,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  isenable: false,
                  hintText: 'Robinson',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: _contactController,
                  focusNode: _focusNode3,
                  nextFocusNode: _focusNode4,
                  hintText: 'Phone No',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  isenable: false,
                  controller: _productsController,
                  hintText: 'Products',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text('Details',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.orderDetail.cart!.length,
                  itemBuilder: (context, index) {
                    final item = widget.orderDetail.cart![index];
                    TextEditingController qtyController =
                        TextEditingController(text: item.qty);
                    TextEditingController priceController =
                        TextEditingController(text: item.price);
                    TextEditingController nameController =
                        TextEditingController(text: item.productName);

                    return ListTile(
                      title: Text(
                        'Qty x: ${qtyController.text}',
                        style: CustomTextStyles.lightSmallTextStyle(
                            size: 14,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC8D3E0)
                                : Color(0xff383D44)),
                      ),
                      subtitle: Text(
                        'Name: ${nameController.text}',
                        style: CustomTextStyles.lightSmallTextStyle(
                            size: 12,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC8D3E0)
                                : Color(0xff383D44)),
                      ),
                      trailing: Text(
                        'Price: ${priceController.text}',
                        style: CustomTextStyles.lightSmallTextStyle(
                            size: 14,
                            color: ThemeUtil.isDarkMode(context)
                                ? Color(0xffC8D3E0)
                                : Color(0xff383D44)),
                      ),
                    );
                  },
                ),
                Text('Location',
                    style: CustomTextStyles.lightTextStyle(
                        color: AppColors.blackColor3D4)),
                SizedBox(
                  height: 1.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  controller: _locationController,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  hintText: 'Location',
                  maxlines: true,
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode6,
                  nextFocusNode: _focusNode7,
                  isenable: false,
                  controller: _cityController,
                  maxlines: true,
                  hintText: 'City',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  focusNode: _focusNode7,
                  nextFocusNode: _focusNode8,
                  controller: _townController,
                  isenable: false,
                  maxlines: true,
                  hintText: 'Town',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  isenable: false,
                  focusNode: _focusNode8,
                  nextFocusNode: _focusNode9,
                  controller: _feeController,
                  hintText: '20\$ Bill',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
