import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_maid_project/CustomWidgets/NextButtonWidget.dart';
import 'package:house_maid_project/Views/login/loginScreen.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.07), // 7% height spacing

              // Responsive Image Container
              Center(
                child: Container(
                  width: screenWidth * 0.45, // 60% of screen width
                  height: screenHeight * 0.3, // 30% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/onboard3.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 2% height spacing

              // Responsive Title Text
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: const Text(
                    'Maid Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontFamily: 'Urbanist',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.3, // 130% line height
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 2% height spacing

              // Responsive Description Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
                  'sed do eiusmod tempor incididunt ut labore et dolore.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8391A1),
                    fontFamily: 'Urbanist',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.25, // 125% line height
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.12), // 5% height spacing

              // Pagination Dots Container
              Center(
                child: Container(
                  width: screenWidth * 0.15, // 15% of screen width
                  height: screenHeight * 0.02, // 2% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.08),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/3rd_dot.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 10% height spacing

              // Custom Next Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: CustomNextButton(
                  text: 'Get Started',
                  onPressed: () {
                    Get.to(() => LoginScreen());
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // 4% height spacing
            ],
          ),
        ),
      ),
    );
  }
}
