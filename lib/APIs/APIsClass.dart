import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_maid_project/AModels/HMQuestionsModel.dart';
import 'package:house_maid_project/AModels/LogoutModel.dart';
import 'package:house_maid_project/AModels/OtpModel.dart';
import 'package:house_maid_project/AModels/RegisterationModel.dart';
import 'package:house_maid_project/AModels/SIgnInGoogleModel.dart';
import 'package:house_maid_project/AModels/changepasswordModel.dart';
import 'package:house_maid_project/AModels/forgotpasswordModel.dart';
import 'package:house_maid_project/AModels/loginModel.dart';
import 'package:house_maid_project/Views/RegisterScreens/HouseMaidRegisteration/address/DataSubmitted.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import your RegisterationModel class
// Adjust according to your project structure

class APIs {
  final String baseUrl =
      "https://c7ef-39-62-165-213.ngrok-free.app/api/"; // Base URL for your API

  Future<loginModel> login({
    required String email,
    required String password,
    required String deviceid,
  }) async {
    // Construct the URL with query parameters for role_id and device_id
    var url = Uri.parse('${baseUrl}login?device_id=${deviceid}');
    print("Fetching from URL: $url");

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Create the body of the POST request
      var body = jsonEncode({
        'email': email,
        'password': password,
      });
      print(' body is : ${body}');

      // Make the POST request
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // Print the response details for debugging
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Handle successful status codes (200, 201, 302)

      var jsonResponse = jsonDecode(response.body);

      // Parse the response into the loginModel
      return loginModel.fromJson(jsonResponse);
    } catch (e) {
      print("Error occurred in API function: $e");
      // Handle any exceptions or network errors and return a model with an error message
      return loginModel(
        statusCode: 500,
        status: false,
        message: "An error occurred: $e",
      );
    }
  }

  //HousemaidCompleteData

  Future<HMQuestionsMOdel> submitHousemaidDetails({
    required int roleid,
    required String email,
    required String password,
    required List<String> questions,
    required List<String> answers,
    required List<Map<String, String>> schedule,
    required int hourlyRate,
    required String currency,
    required String country,
    required String identityType,
    required List<Map<String, String>>
        documents, // Each map contains a 'type' and a 'path'
  }) async {
    final storage = GetStorage();

    // Retrieve the token from GetStorage
    String? bearerToken = storage.read('auth_token');
    print('mY TOKE BEFORE LOGOUT IS : ${bearerToken}');
    // Construct the URL
    var url = Uri.parse('${baseUrl}housemaid/register-with-questions');

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add fields to the request (including the name, email, and password as form fields)

    request.fields['email'] = '${storage.read('email')}';
    request.fields['password'] = 'Nafees302@@';
    request.fields['role_id'] = '${storage.read('roles')}';
    request.fields['questions'] = jsonEncode(questions);
    request.fields['answers'] = jsonEncode(answers);
    request.fields['schedule'] = jsonEncode(schedule);
    request.fields['hourly_rate'] = hourlyRate.toString();
    request.fields['currency'] = currency;
    request.fields['country'] = country;
    request.fields['identity_type'] = identityType;

    // Attach the documents to the request as files
    // Attach the documents to the request
    for (int i = 0; i < documents.length; i++) {
      String filePath = documents[i]['path']!;
      String fieldName = 'documents[$i]'; // Indexed name like "documents[0]"

      // Attach the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, filePath),
      );
    }

    // Print the fields and files to simulate the request body
    print("===== Request Data =====");
    print("URL: $url");
    print("Method: POST");

    // Print form fields
    print("Form Fields:");
    request.fields.forEach((key, value) {
      print("- $key: $value");
    });

    // Print file fields
    print("Files:");
    for (var file in request.files) {
      print("- Field: ${file.field}, Filename: ${file.filename},");
    }
    print("========================");

    // Set headers for the multipart request
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
      // Add more headers if required by your backend
    });

    // Send the request and await the response
    // Get.to(SubmittedData());
    var response = await request.send();

    // Read the response
    var responseBody = await response.stream.bytesToString();
    print("Response status code: ${response.statusCode}");
    print("Response body: $responseBody");

    // If the response code is 200, decode the response body into HMQuestionsModel
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      return HMQuestionsMOdel.fromJson(jsonResponse);
    } else {
      // Handle other status codes and return a model with an error message
      return HMQuestionsMOdel(
        statusCode: response.statusCode,
        status: false,
        message: "Failed to submit details. Please try again.",
        data: null,
      );
    }
    // will change later
    return HMQuestionsMOdel(
      statusCode: 200,
      status: false,
      message: "Failed to submit details. Please try again.",
      data: null,
    );
  }

  //Google SignIn
  Future<SignInGoogleModel> googleSignInInit({
    required String deviceId,
  }) async {
    // Construct the URL with query parameters for device_id and role_id
    //role_id=$roleId&device_id=$deviceId
    var url = Uri.parse('${baseUrl}signin/google?device_id=${deviceId}');
    print("Fetching from URL: $url");

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Make the GET request
      var response = await http.get(
        url,
        headers: headers,
      );

      // Print the response details for debugging
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check for a successful redirection status code (302)
      if (response.statusCode == 302 ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);

        // Parse the response into the SignInGoogleModel
        return SignInGoogleModel.fromJson(jsonResponse);
      } else {
        // Handle other status codes and return a model with an error message
        return SignInGoogleModel(
          statusCode: response.statusCode,
          status: false,
          message: "Failed to get redirection URL or log in.",
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle any exceptions or network errors
      return SignInGoogleModel(
        statusCode: 500,
        status: false,
        message: "An error occurred while fetching the URL: $e",
      );
    }
  }

  // Registration API Function
  Future<RegisterationModel> registrationAPI({
    required int roleid,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      var url = Uri.parse('${baseUrl}register');
      print("My URL is $url");
      print("My roleid is $roleid");

      // Request body for registration
      var body = jsonEncode({
        'name': fullName,
        'email': email,
        'password': password,
      });
      print("My body is $body");

      // Make a POST request to the registration endpoint
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print('API returned status: ${response.statusCode}');

      // Check for successful status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        return RegisterationModel.fromJson(jsonResponse);
      } else {
        // Handle error response codes
        var jsonResponse = jsonDecode(response.body);
        return RegisterationModel(
          status: false,
          message: jsonResponse['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      print('Error in API call: $error');
      // Return a failed registration model in case of exception
      return RegisterationModel(
        status: false,
        message: 'Failed to connect. Please try again.',
        statusCode: 500,
      );
    }
  }

  //ClintOTP
  Future<OtpModel> clientOtpAPI({
    required String email,
    required String otp,
  }) async {
    var url =
        Uri.parse('${baseUrl}verify-otp'); // Replace with your actual endpoint

    // Request body
    var body = jsonEncode({
      'otp': otp,
      'email': email,
    });
    print("My body is $body");
    print("My URL is $url");

    // Make a POST request to the OTP verification endpoint
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('API returned status: ${response.statusCode}');

    // Directly parse and return the response
    var jsonResponse = jsonDecode(response.body);
    return OtpModel.fromJson(jsonResponse);
  }

  //Logout
  Future<LogoutModel> LogoutAPI() async {
    var url =
        Uri.parse('${baseUrl}logout'); // Replace with your actual endpoint
    final storage = GetStorage();

    // Retrieve the token from GetStorage
    String? bearerToken = storage.read('auth_token');
    print('mY TOKE BEFORE LOGOUT IS : ${bearerToken}');

    // Check if the token is available
    if (bearerToken == null) {
      print("Bearer token is not available.");
      return LogoutModel(
        message: "Authentication token not found",
      );
    }

    print("My URL is $url");

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };
      print('Headers: ${headers}');
      // Make a GET request to the logout endpoint with Bearer token in headers
      var response = await http.get(
        url,
        headers: headers,
      );

      print('API returned status: ${response.statusCode}');
      print('Response body of Logout is : ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response into the LogoutModel
        var jsonResponse = jsonDecode(response.body);
        return LogoutModel.fromJson(jsonResponse);
      } else {
        // Handle error response
        return LogoutModel(
          message: "Failed to log out. Please try again.",
        );
      }
    } catch (e) {
      print("Error occurred during logout: $e");
      return LogoutModel(
        message: "An error occurred while trying to log out: $e",
      );
    }
  }

  //forgotpassword
  Future<ForgotpasswordModel?> forgotPassword(String email) async {
    try {
      var url = '${baseUrl}forget-password';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Successful response
        final jsonResponse = json.decode(response.body);
        return ForgotpasswordModel.fromJson(jsonResponse);
      } else {
        // Error response
        print(
            'Failed to send forgot password request. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  // Function to change the password
  Future<changepassModel> changePassword(
      String email, String otp, String newPassword) async {
    final url =
        Uri.parse('${baseUrl}change-password'); // Replace with actual endpoint
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'email': email,
      'password': newPassword,
      'otp': otp,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Parse the JSON response into the model
        return changepassModel.fromJson(jsonDecode(response.body));
      } else {
        // Handle the error response
        return changepassModel(
          statusCode: response.statusCode,
          status: false,
          message: 'Failed to change password',
        );
      }
    } catch (e) {
      // Handle the exception
      return changepassModel(
        statusCode: 500,
        status: false,
        message: 'An error occurred: $e',
      );
    }
  }
}
