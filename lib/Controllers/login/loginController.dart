import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_maid_project/APIs/APIsClass.dart'; // Import your API service
import 'package:house_maid_project/CustomWidgets/errorDialogue.dart';
import 'package:house_maid_project/Views/Dashboard/housemaid.dart/ClientDashboard.dart';
// Import loginModel

class LoginController extends GetxController {
  var apiService = APIs(); // Initialize the APIs class
  final box = GetStorage(); // For persistent storage
  var isLoading = false.obs; // Observable to track loading state
  void login(String email, String password, BuildContext context) async {
    isLoading.value = true; // Set loading to true when API call starts

    try {
      // Call the login API from your ApiService and await the loginModel response
      var response = await apiService.login(
          email: email, password: password, deviceid: await _getDeviceId());

      // Handle different status codes and responses
      if (response.statusCode == 200) {
        print('Token is ${response.data!.bearerToken}');
        print('username is ${response.data!.userName}');
        print('email   is ${response.data!.email}');
        print('profilePic url is ${response.data!.profilePicUrl}');
        print('roles is  is ${response.data!.roles}');
        _saveToken(
          response.data!.bearerToken!,
          response.data!.userName!,
          response.data!.email!,
          response.data!.profilePicUrl!,
          response.data!.roles!.toString(), // Convert roles to a String safely
        );

        // saveRoleId(response.data!.roles!);
        Get.to(() => Clientdashboard());
      } else {
        // Handle other cases
        ErrorDialog.showError(
            context, '${response.statusCode} ${response.message}');
      }
    } catch (e) {
      // Handle unexpected errors
      ErrorDialog.showError(context, 'An unexpected error occurred.');
      print('Error: $e');
    } finally {
      isLoading.value = false; // Set loading to false when API call finishes
    }
  }

  //get device id
  Future<String> _getDeviceId() async {
    String? deviceId;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Use androidId instead of hardware ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor; // Unique iOS device ID
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return deviceId!;
  }

  //save role id  saveRoleId('12345'); // Save roleId
  void saveRoleId(int roleId) {
    final storage = GetStorage();
    storage.write('roleId', roleId);
    print('Role ID saved: $roleId');
  }

  //get role id  int? roleId = getRoleId(); // Get roleId
  // Get roleId from storage and convert it to a String
  String? getRoleId() {
    final storage = GetStorage();
    final dynamic storedRoleId = storage.read('roleId');
    if (storedRoleId != null) {
      return storedRoleId.toString(); // Convert to String
    }
    return null;
  }

  //delete roll id
  void deleteRoleId() {
    final storage = GetStorage();
    storage.remove('roleId');
    print('Role ID deleted');
  }

//save token info
  Future<void> _saveToken(String token, String username, String email,
      String profilePicUrl, String roles) async {
    // Store the token in persistent storage for future API calls
    box.write('auth_token', token);
    box.write('username', username);
    box.write('email', email);
    box.write('profilePicUrl', profilePicUrl);

    // Convert roles to an integer if possible, otherwise set to 0
    int roleIdInt = int.tryParse(roles) ?? 0;
    box.write('roleId', roleIdInt);
  }

  //saveRoleId('12345'); // Save roleId
//String? roleId = getRoleId(); // Get roleId
//deleteRoleId(); // Delete roleId
}
