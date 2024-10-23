import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:house_maid_project/APIs/APIsClass.dart';
import 'package:house_maid_project/CustomWidgets/errorDialogue.dart';
import 'package:house_maid_project/Views/Dashboard/TestDashboards/TestDash.dart';
import 'package:house_maid_project/Views/Dashboard/housemaid.dart/ClientDashboard.dart';
import 'package:path/path.dart';
import 'package:uni_links3/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart'; // For persistent storage

class GoogleSignInController extends GetxController {
  final APIs apiService = APIs(); // Initialize your APIs service
  StreamSubscription? _sub; // Subscription to listen for deep links
  final box = GetStorage(); // For persistent storage
  var isLoading = false.obs; // Observable to show/hide loader

  @override
  void onInit() {
    super.onInit();
    _handleIncomingLinks(); // Listen for deep links when the controller is initialized
    _handleInitialLink(); // Optionally handle the initial deep link
  }

  /// Initiates the Google Sign-In process by getting a redirection URL from the backend.
  /// Opens the Google consent screen in an external browser.
  Future<void> initiateGoogleSignIn(BuildContext context) async {
    isLoading.value = true; // Start loading indicator
    try {
      // Fetch the Google consent screen URL from your backend
      final response =
          await apiService.googleSignInInit(deviceId: await _getDeviceId());

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 302) {
        print('response code isssss ${response.statusCode}');
        // Redirection URL to open Google Sign-In consent screen
        final Uri googleSignInUrl = Uri.parse(response.data!.url!);

        // Open the Google Sign-In page in an external browser
        if (await canLaunchUrl(googleSignInUrl)) {
          await launchUrl(googleSignInUrl, mode: LaunchMode.inAppBrowserView);
        } else {
          throw 'Could not launch $googleSignInUrl';
        }
      } else {
        // Handle error response
        ErrorDialog.showError(
            context, response.message ?? "An unexpected error occurred.");
      }
    } catch (error) {
      // Display error message if any exception occurs
      ErrorDialog.showError(context, "An error occurred: $error");
    } finally {
      isLoading.value = false; // Stop loading indicator
    }
  }

  /// Handles incoming deep links after Google consent screen redirection.
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'housemaid') {
        // Ensure scheme matches your app's deep link configuration
        if (uri.host == 'callback') {
          _processBackendCallback(uri); // Process the deep link callback
        }
      }
    }, onError: (err) {
      print('Error listening for deep link: $err');
    });
  }

  /// Optionally handle the initial deep link if the app was opened by a deep link.
  Future<void> _handleInitialLink() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null && initialUri.scheme == 'housemaid') {
        _processBackendCallback(initialUri);
      }
    } on PlatformException catch (e) {
      print("Failed to receive initial URI: $e");
    }
  }

  void _processBackendCallback(Uri uri) {
    print('callback URL :  ${uri}');
    String? statusCode = uri.queryParameters['statusCode'];
    String? status = uri.queryParameters['status'];
    String? message = uri.queryParameters['message'];
    String? bearerToken = uri.queryParameters['bearerToken'];
    String? userName = uri.queryParameters['userName'];
    String? email = uri.queryParameters['email'];
    String? profilePicUrl = uri.queryParameters['profilePicUrl'];
    String? roles = uri.queryParameters['roles'];
    // _saveToken(bearerToken!, userName!, email!, profilePicUrl!, roles!);
    String? profileUrl = uri.queryParameters['profilePicUrl'];

    print('status before procedding :  ${status}');
    print('statusCode before procedding :  ${statusCode}');
    print('token before procedding :  ${bearerToken}');

    print('token is ${bearerToken}');

    if (status == 'false' && (statusCode == '409' || statusCode == '500')) {
      print('ENtered in function');
      _saveToken(
        bearerToken!,
        userName!,
        email!,
        profilePicUrl!,
        roles!.toString(), // Convert roles to a String safely
      );
      ErrorDialog.showError(
          context as BuildContext, message ?? "An unexpected error occurred.");
      return;
      // Get.off(() => HouseMaidBefore(), arguments: {'token': bearerToken});
    } else if (status == 'true' &&
        (statusCode == '200' || statusCode == '201')) {
      print('Token is ${bearerToken}');
      print('username is ${userName}');
      print('email   is ${email}');
      print('profilePic url is ${profilePicUrl}');
      print('roles is  is ${roles}');
      _saveToken(bearerToken!, userName!, email!, profilePicUrl!, roles!);
      // print('${box.read('auth_token')}');

      print('ENtered in function');
      Get.to(() => TestDashboard());

      // Get.off(() => HouseMaidBefore(), arguments: {'token': bearerToken});
    } else {
      ErrorDialog.showError(
          context as BuildContext, "Unknown status received from Deep Link");
    }
  }

  /// Saves the authentication token securely using GetStorage.
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

  /// Retrieves the saved authentication token from persistent storage.
  String? getToken() {
    return box.read('auth_token');
  }

  /// Fetches the device ID depending on the platform (Android/iOS).
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

  @override
  void dispose() {
    _sub?.cancel(); // Cancel the deep link listener when the controller is disposed
    super.dispose();
  }
}

// if (bearerToken == null || bearerToken.isEmpty || status == 'false') {
//   ErrorDialog.showError(
//       context as BuildContext, message ?? "An unexpected error occurred.");
//   return;
// }
