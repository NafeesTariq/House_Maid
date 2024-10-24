import 'package:get/get.dart';
import 'package:house_maid_project/APIs/APIsClass.dart';
import 'package:house_maid_project/CustomWidgets/errorDialogue.dart';
import 'package:house_maid_project/Views/forgotPassword/NewpasswordScreen.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  APIs apiservice = APIs();
  // Method to handle the forgot password request
  Future<void> sendForgotPasswordRequest(String email, context) async {
    isLoading.value = true; // Show loading indicator
    try {
      var response = await apiservice.forgotPassword(email);

      if (response != null && response.status == true) {
        // Request was successful
        Get.to(() => CreateNewPasswordScreen(
              email: response.data!.email!,
            )); // Navigate to Create New Password screen
      } else {
        // Request failed
        ErrorDialog.showError(context, response?.message ?? 'Request failed');
      }
    } catch (e) {
      ErrorDialog.showError(context, 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }
}
