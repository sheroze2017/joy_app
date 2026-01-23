import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
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
  final TextEditingController _emailController = TextEditingController();
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
  final FocusNode _focusNode10 = FocusNode();

  @override
  void initState() {
    super.initState();
    // Populate controllers with order data when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateControllers();
      if (mounted) {
        setState(() {}); // Force UI update after populating controllers
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _fnameController.dispose();
    _lnameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _productsController.dispose();
    _cityController.dispose();
    _townController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    _focusNode7.dispose();
    _focusNode8.dispose();
    _focusNode9.dispose();
    _focusNode10.dispose();
    super.dispose();
  }

  void _populateControllers() {
    // Helper function to safely get string value
    String _getStringValue(dynamic value) {
      if (value == null) return '';
      final str = value.toString().trim();
      if (str.isEmpty || str.toLowerCase() == 'null') return '';
      return str;
    }
    
    // Populate controllers with order data
    _fnameController.text = _getStringValue(widget.orderDetail.orderId);
    _locationController.text = _getStringValue(widget.orderDetail.location);
    _feeController.text = _getStringValue(widget.orderDetail.totalPrice) != '' 
        ? _getStringValue(widget.orderDetail.totalPrice) 
        : '0';
    _productsController.text = _getStringValue(widget.orderDetail.quantity) != '' 
        ? _getStringValue(widget.orderDetail.quantity) 
        : '0';
    
    // Populate user info from API response
    final userName = _getStringValue(widget.orderDetail.userName);
    final userPhone = _getStringValue(widget.orderDetail.userPhone);
    final userEmail = _getStringValue(widget.orderDetail.userEmail);
    
    _lnameController.text = userName;
    _contactController.text = userPhone;
    _emailController.text = userEmail;
    
    // Debug logging - Check raw values
    print('📋 [OrderDetail] ========== ORDER DETAIL DEBUG ==========');
    print('📋 [OrderDetail] Raw orderDetail object:');
    print('   - Order ID: ${widget.orderDetail.orderId}');
    print('   - User Name (raw): ${widget.orderDetail.userName}');
    print('   - User Phone (raw): ${widget.orderDetail.userPhone}');
    print('   - User Email (raw): ${widget.orderDetail.userEmail}');
    print('   - User Image (raw): ${widget.orderDetail.userImage}');
    print('📋 [OrderDetail] Processed values:');
    print('   - User Name (processed): "$userName"');
    print('   - User Phone (processed): "$userPhone"');
    print('   - User Email (processed): "$userEmail"');
    print('📋 [OrderDetail] Controller values:');
    print('   - _lnameController.text: "${_lnameController.text}"');
    print('   - _contactController.text: "${_contactController.text}"');
    print('   - _emailController.text: "${_emailController.text}"');
    print('📋 [OrderDetail] ========================================');
  }

  Widget _buildCustomerAvatar(String? imageUrl, BuildContext context) {
    final isValidUrl = imageUrl != null &&
        imageUrl.trim().isNotEmpty &&
        imageUrl.trim().toLowerCase() != 'null' &&
        imageUrl.contains('http') &&
        !imageUrl.contains('c894ac58-b8cd-47c0-94d1-3c4cea7dadab');
    
    if (isValidUrl) {
      return ClipOval(
        child: Image.network(
          imageUrl.trim(),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return CircleAvatar(
              radius: 25,
              backgroundColor: ThemeUtil.isDarkMode(context)
                  ? Color(0xff2A2A2A)
                  : Color(0xffE5E5E5),
              child: Icon(
                Icons.person,
                size: 25,
                color: ThemeUtil.isDarkMode(context)
                    ? Color(0xff5A5A5A)
                    : Color(0xffA5A5A5),
              ),
            );
          },
        ),
      );
    }
    return CircleAvatar(
      radius: 25,
      backgroundColor: ThemeUtil.isDarkMode(context)
          ? Color(0xff2A2A2A)
          : Color(0xffE5E5E5),
      child: Icon(
        Icons.person,
        size: 25,
        color: ThemeUtil.isDarkMode(context)
            ? Color(0xff5A5A5A)
            : Color(0xffA5A5A5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get items to display (prefer items array, fallback to cart)
    final itemsToDisplay = (widget.orderDetail.items != null && widget.orderDetail.items!.isNotEmpty)
        ? widget.orderDetail.items!
        : (widget.orderDetail.cart ?? []);

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
                  height: 2.h,
                ),
                // Customer Info Section - Always show if we have any user data
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff1A1A1A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xffE5E7EB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Customer Avatar
                      _buildCustomerAvatar(widget.orderDetail.userImage, context),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer Name - Always show
                            Text(
                              _lnameController.text.isNotEmpty 
                                  ? _lnameController.text 
                                  : 'Customer',
                              style: CustomTextStyles.w600TextStyle(
                                size: 18,
                                color: ThemeUtil.isDarkMode(context)
                                    ? AppColors.whiteColor
                                    : Color(0xff19295C),
                              ),
                            ),
                            // Email - Always show if available
                            if (_emailController.text.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC8D3E0)
                                        : Color(0xff60709D),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _emailController.text,
                                      style: CustomTextStyles.lightTextStyle(
                                        size: 14,
                                        color: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC8D3E0)
                                            : Color(0xff60709D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // Phone - Always show if available
                            if (_contactController.text.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 16,
                                    color: ThemeUtil.isDarkMode(context)
                                        ? Color(0xffC8D3E0)
                                        : Color(0xff60709D),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _contactController.text,
                                      style: CustomTextStyles.lightTextStyle(
                                        size: 14,
                                        color: ThemeUtil.isDarkMode(context)
                                            ? Color(0xffC8D3E0)
                                            : Color(0xff60709D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                // Order Information Section
                Text(
                  'Order Information',
                  style: CustomTextStyles.darkHeadingTextStyle(
                    size: 18,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff19295C),
                  ),
                ),
                SizedBox(height: 1.h),
                RoundedBorderTextField(
                  showLabel: true,
                  isenable: false,
                  controller: _fnameController,
                  focusNode: _focusNode1,
                  nextFocusNode: _focusNode2,
                  hintText: 'Order Id',
                  icon: '',
                ),
                SizedBox(height: 2.h),
                // Customer Name Field - Always show
                RoundedBorderTextField(
                  showLabel: true,
                  controller: _lnameController,
                  focusNode: _focusNode2,
                  nextFocusNode: _focusNode3,
                  isenable: false,
                  hintText: 'Customer Name',
                  icon: '',
                ),
                SizedBox(height: 2.h),
                // Phone Number Field - Always show
                RoundedBorderTextField(
                  showLabel: true,
                  isenable: false,
                  controller: _contactController,
                  focusNode: _focusNode3,
                  nextFocusNode: _focusNode10,
                  hintText: 'Phone No',
                  icon: '',
                ),
                SizedBox(height: 2.h),
                // Email Field - Always show
                RoundedBorderTextField(
                  showLabel: true,
                  isenable: false,
                  controller: _emailController,
                  focusNode: _focusNode10,
                  nextFocusNode: _focusNode4,
                  hintText: 'Email',
                  icon: '',
                ),
                SizedBox(height: 2.h),
                RoundedBorderTextField(
                  showLabel: true,
                  focusNode: _focusNode4,
                  nextFocusNode: _focusNode5,
                  isenable: false,
                  controller: _productsController,
                  hintText: 'Total Items',
                  icon: '',
                ),
                SizedBox(height: 3.h),
                
                // Order Items Section
                Text(
                  'Order Items',
                  style: CustomTextStyles.darkHeadingTextStyle(
                    size: 18,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff19295C),
                  ),
                ),
                SizedBox(height: 1.h),
                itemsToDisplay.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          'No items found',
                          style: CustomTextStyles.lightTextStyle(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemsToDisplay.length,
                        itemBuilder: (context, index) {
                          final item = itemsToDisplay[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ThemeUtil.isDarkMode(context)
                                  ? Color(0xff1A1A1A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xffE5E7EB),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName ?? 'Unknown Product',
                                        style: CustomTextStyles.w600TextStyle(
                                          size: 15,
                                          color: ThemeUtil.isDarkMode(context)
                                              ? AppColors.whiteColor
                                              : Color(0xff19295C),
                                        ),
                                      ),
                                      SizedBox(height: 0.5.h),
                                      Text(
                                        'Quantity: ${item.qty ?? '0'}',
                                        style: CustomTextStyles.lightTextStyle(
                                          size: 13,
                                          color: ThemeUtil.isDarkMode(context)
                                              ? Color(0xffC8D3E0)
                                              : Color(0xff60709D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Rs. ${item.price ?? '0'}',
                                  style: CustomTextStyles.w600TextStyle(
                                    size: 16,
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                SizedBox(height: 2.h),
                // Location Section
                Text(
                  'Location',
                  style: CustomTextStyles.darkHeadingTextStyle(
                    size: 18,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff19295C),
                  ),
                ),
                SizedBox(height: 1.h),
                RoundedBorderTextField(
                  showLabel: true,
                  isenable: false,
                  controller: _locationController,
                  focusNode: _focusNode5,
                  nextFocusNode: _focusNode6,
                  hintText: 'Location',
                  maxlines: true,
                  icon: '',
                ),
                SizedBox(height: 2.h),
                // Bill Section
                Text(
                  'Bill Summary',
                  style: CustomTextStyles.darkHeadingTextStyle(
                    size: 18,
                    color: ThemeUtil.isDarkMode(context)
                        ? AppColors.whiteColor
                        : Color(0xff19295C),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeUtil.isDarkMode(context)
                        ? Color(0xff1A1A1A)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xffE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: CustomTextStyles.w600TextStyle(
                          size: 16,
                          color: ThemeUtil.isDarkMode(context)
                              ? AppColors.whiteColor
                              : Color(0xff19295C),
                        ),
                      ),
                      Text(
                        'Rs. ${widget.orderDetail.totalPrice ?? '0'}',
                        style: CustomTextStyles.w600TextStyle(
                          size: 20,
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    ],
                  ),
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
