import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_app/Widgets/appbar/custom_appbar.dart';
import 'package:joy_app/Widgets/textfield/custom_textfield.dart';
import 'package:joy_app/Widgets/button/rounded_button.dart';
import 'package:joy_app/Widgets/dailog/success_dailog.dart';
import 'package:joy_app/common/map/view/mapscreen.dart';
import 'package:joy_app/common/profile/bloc/profile_bloc.dart';
import 'package:joy_app/modules/user/user_pharmacy/all_pharmacy/bloc/all_pharmacy_bloc.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:joy_app/theme.dart';
import 'package:joy_app/widgets/custom_message/flutter_toast_message.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

class CheckoutForm extends StatefulWidget {
  String? pharmacyId;
  CheckoutForm({super.key, this.pharmacyId});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  String? selectedValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();
  final FocusNode _focusNode7 = FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9 = FocusNode();
  final _profileController = Get.find<ProfileController>();

  TextEditingController controller = TextEditingController();
  bool isButtonSelectedCod = false;
  bool isButtonSelectedOp = false;
  bool isSelected = false;
  bool onlinepay = false;
  bool codpay = false;
  final _formKey = GlobalKey<FormState>();
  final pharmacyController = Get.find<AllPharmacyController>();

  @override
  void initState() {
    super.initState();
    _nameController.setText(_profileController.firstName.toString());
    _contactController.setText(_profileController.phone.toString());
  }

  double latitude = 0;
  double longitude = 0;
  @override
  Widget build(BuildContext context) {
    // List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: HomeAppBar(
          title: 'Checkout',
          leading: Image(
            image: AssetImage('Assets/icons/arrow-left.png'),
            // height: 6.w,
            // width: .w,
          ),
          actions: [],
          showIcon: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedBorderTextField(
                    controller: _nameController,
                    focusNode: _focusNode1,
                    nextFocusNode: _focusNode2,
                    hintText: 'Name',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                    controller: _contactController,
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hintText: 'Contact Number',
                    icon: '',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      ).then((value) {
                        if (value != null) {
                          latitude = value['latitude'];
                          longitude = value['longitude'];
                          _addressController.setText(value['searchValue']);
                        }
                      });
                    },
                    child: RoundedBorderTextField(
                        isenable: false,
                        controller: _addressController,
                        focusNode: _focusNode3,
                        nextFocusNode: _focusNode4,
                        hintText: 'Address',
                        icon: '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          } else {
                            return null;
                          }
                        }),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  RoundedBorderTextField(
                      controller: _cityController,
                      focusNode: _focusNode4,
                      nextFocusNode: _focusNode5,
                      hintText: 'City',
                      icon: '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RoundedButtonSmall(
                          text: "Cash On Delivery",
                          onPressed: () {
                            setState(() {
                              codpay = true;
                              onlinepay = false;
                              isSelected = true;
                            });
                          },
                          backgroundColor: codpay
                              ? ThemeUtil.isDarkMode(context)
                                  ? AppColors.lightGreenColoreb1
                                  : AppColors.darkGreenColor
                              : ThemeUtil.isDarkMode(context)
                                  ? Color(0xff121212)
                                  : AppColors.bgBackGroundColor,
                          textColor: codpay
                              ? ThemeUtil.isDarkMode(context)
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor
                              : ThemeUtil.isDarkMode(context)
                                  ? AppColors.borderColor
                                  : AppColors.borderColor,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: RoundedButtonSmall(
                          text: "Online Payment",
                          onPressed: () {
                            showErrorMessage(
                                context, 'Online payment not active');
                            setState(() {
                              onlinepay = false;
                              codpay = false;
                              isSelected = false;
                            });
                          },
                          backgroundColor: onlinepay
                              ? ThemeUtil.isDarkMode(context)
                                  ? AppColors.lightGreenColoreb1
                                  : AppColors.darkGreenColor
                              : ThemeUtil.isDarkMode(context)
                                  ? Color(0xff121212)
                                  : AppColors.bgBackGroundColor,
                          textColor: onlinepay
                              ? ThemeUtil.isDarkMode(context)
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor
                              : ThemeUtil.isDarkMode(context)
                                  ? AppColors.borderColor
                                  : AppColors.borderColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Obx(
                        () => RoundedButton(
                          showLoader: pharmacyController.placeOrderLoader.value,
                          text: 'Confirm Order',
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_formKey.currentState!.validate()) {
                            } else if (codpay) {
                              pharmacyController.placeOrderPharmacy(
                                  context,
                                  pharmacyController
                                      .calculateGrandTotal()
                                      .toString(),
                                  'Pending',
                                  pharmacyController.cartItems.length
                                      .toString(),
                                  _addressController.text +
                                      ' ' +
                                      _cityController.text,
                                  latitude,
                                  longitude,
                                  '123456789',
                                  pharmacyController.cartItemsToJson,
                                  pharmacyController.cartItems[0].pharmacyId);
                            } else if (onlinepay) {
                              showPaymentBottomSheet(
                                  context, false, true, widget.pharmacyId);
                            } else {
                              showErrorMessage(
                                  context, 'please select payment method');
                            }
                          },
                          backgroundColor: ThemeUtil.isDarkMode(context)
                              ? AppColors.lightGreenColoreb1
                              : AppColors.darkGreenColor,
                          textColor: ThemeUtil.isDarkMode(context)
                              ? Color(0xff1F2228)
                              : Color(0xffFFFFFF),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showPaymentBottomSheet(BuildContext context, bool isbookAppointment,
    bool? isPharmacyCheckout, pharId) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Pharmacy Online Payment',
                  style: CustomTextStyles.darkHeadingTextStyle(
                      size: 18,
                      color: ThemeUtil.isDarkMode(context)
                          ? AppColors.whiteColor
                          : null)),
            ),
            SizedBox(height: 4.h),
            _buildRoundedInputField(context: context, label: 'Card Number'),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                    child: _buildRoundedInputField(
                        context: context, label: 'Expiry')),
                SizedBox(width: 4.w),
                Expanded(
                    child: _buildRoundedInputField(
                        context: context, label: 'CVV')),
              ],
            ),
            SizedBox(height: 2.h),
            _buildRoundedInputField(context: context, label: 'Name on Card'),
            SizedBox(height: 2.h),
            RoundedButton(
                text: 'Pay Now',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        pharmacyId: pharId,
                        isPharmacyCheckout: true,
                        title: 'Congratulations!',
                        content: isbookAppointment
                            ? 'Your appointment with Dr. David Patel is confirmed for June 30, 2023, at 10:00 AM.'
                            : 'Your Order has been placed !',
                        showButton: true,
                        isBookAppointment: isbookAppointment,
                      );
                    },
                  );
                },
                backgroundColor: isbookAppointment!
                    ? AppColors.darkBlueColor
                    : ThemeUtil.isDarkMode(context)
                        ? AppColors.lightGreenColoreb1
                        : AppColors.darkGreenColor,
                textColor: ThemeUtil.isDarkMode(context)
                    ? AppColors.blackColor
                    : AppColors.whiteColor)
          ],
        ),
      );
    },
  );
}

Widget _buildRoundedInputField(
    {required BuildContext context, required String label}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: CustomTextStyles.lightTextStyle(
            color: ThemeUtil.isDarkMode(context)
                ? AppColors.whiteColor
                : Color(0xff000000),
            size: 16.35),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ThemeUtil.isDarkMode(context)
              ? Color(0xff121212)
              : AppColors.whiteColorf9f,
        ),
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: AppColors.blackColor),
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintStyle: CustomTextStyles.lightSmallTextStyle(
                color: Color(0xff9CA3AF), size: 14),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 25), // Padding for text input
          ),
        ),
      ),
    ],
  );
}
