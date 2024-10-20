import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_maid_project/APIs/APIsClass.dart';
import 'package:house_maid_project/CustomWidgets/errorDialogue.dart';
import 'package:house_maid_project/Views/forgotPassword/passChanged.dart';

class PasswordController {
  final TextEditingController otpTextController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final isLoading = ValueNotifier<bool>(false); // For showing loading indicator
  APIs apiService = APIs();

  // API call to change the password
  Future<void> changePassword(
      String email, String otp, String password, BuildContext context) async {
    isLoading.value = true; // Show loading indicator
    try {
      var response = await apiService.changePassword(
          email, otp, newPasswordController.text);

      if (response.status == true) {
        // Password change was successful

        Get.to(() => PasswordChangedScreen());
      } else {
        // Password change failed
        ErrorDialog.showError(
            context, response.message ?? 'Password update failed.');
      }
    } catch (e) {
      ErrorDialog.showError(context, 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  // Check if the passwords match
  bool doPasswordsMatch() {
    return newPasswordController.text == confirmPasswordController.text;
  }

  // Check if the password is strong
  bool isPasswordStrong() {
    final password = newPasswordController.text;
    return password.length >= 6 &&
        password.contains(RegExp(r'[A-Za-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  // Dispose the controllers when not needed
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
