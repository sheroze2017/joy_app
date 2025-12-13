import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joy_app/styles/colors.dart';
import 'package:joy_app/widgets/custom_message/animated_snackbar.dart';

void showErrorMessage(BuildContext context, String message) {
  AnimatedSnackbar.showSnackbar(
    context: context,
    message: message,
    icon: Icons.info,
    backgroundColor: AppColors.redColor,
    textColor: AppColors.whiteColor,
    fontSize: 14.0,
  );
}

void showSuccessMessage(BuildContext context, String message) {
  AnimatedSnackbar.showSnackbar(
    context: context,
    message: message,
    icon: Icons.check,
    backgroundColor: Colors.green,
    textColor: AppColors.whiteColor,
    fontSize: 14.0,
  );
}
