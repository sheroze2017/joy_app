import 'package:flutter/material.dart';
import 'package:joy_app/Widgets/custom_appbar.dart';
import 'package:joy_app/Widgets/custom_textfield.dart';
import 'package:joy_app/Widgets/rounded_button.dart';
import 'package:joy_app/Widgets/success_dailog.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/styles/custom_textstyle.dart';
import 'package:sizer/sizer.dart';

class CheckoutForm extends StatefulWidget {
  CheckoutForm({super.key});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  String? selectedValue;

  TextEditingController controller = TextEditingController();
  bool isButtonSelectedCod = false;
  bool isButtonSelectedOp = false;
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
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffFFFFFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Sheroze Rehman',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Contact Number',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'Address',
                  icon: '',
                ),
                SizedBox(
                  height: 2.h,
                ),
                RoundedBorderTextField(
                  controller: TextEditingController(),
                  hintText: 'City',
                  icon: '',
                ),
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
                                isButtonSelectedCod = !isButtonSelectedCod;
                              });
                            },
                            backgroundColor: isButtonSelectedCod
                                ? AppColors.darkGreenColor
                                : AppColors.bgBackGroundColor,
                            textColor: isButtonSelectedCod
                                ? AppColors.whiteColor
                                : AppColors.borderColor)),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(
                      child: RoundedButtonSmall(
                          text: "Online Payment",
                          onPressed: () {
                            setState(() {
                              isButtonSelectedOp = !isButtonSelectedOp;
                            });
                          },
                          backgroundColor: isButtonSelectedOp
                              ? AppColors.darkGreenColor
                              : AppColors.bgBackGroundColor,
                          textColor: isButtonSelectedOp
                              ? AppColors.whiteColor
                              : AppColors.borderColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                          text: 'Confirm Order',
                          onPressed: () {
                            showPaymentBottomSheet(context, false, true);
                          },
                          backgroundColor: AppColors.darkGreenColor,
                          textColor: AppColors.whiteColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showPaymentBottomSheet(
    BuildContext context, bool isbookAppointment, bool? isPharmacyCheckout) {
  showModalBottomSheet(
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
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Pharmacy Online Payment',
                  style: CustomTextStyles.darkHeadingTextStyle(size: 18)),
            ),
            SizedBox(height: 4.h),
            _buildRoundedInputField(label: 'Card Number'),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(child: _buildRoundedInputField(label: 'Expiry')),
                SizedBox(width: 4.w),
                Expanded(child: _buildRoundedInputField(label: 'CVV')),
              ],
            ),
            SizedBox(height: 2.h),
            _buildRoundedInputField(label: 'Name on Card'),
            SizedBox(height: 2.h),
            RoundedButton(
                text: 'Pay Now',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
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
                    : AppColors.darkGreenColor,
                textColor: AppColors.whiteColor)
          ],
        ),
      );
    },
  );
}

Widget _buildRoundedInputField({required String label}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: CustomTextStyles.lightTextStyle(
            color: Color(0xff000000), size: 16.35),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.whiteColorf9f,
        ),
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: AppColors.blackColor),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 25), // Padding for text input
          ),
        ),
      ),
    ],
  );
}
