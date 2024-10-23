import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:house_maid_project/Controllers/DeviceInfo/screen_sizeController.dart';
import 'package:house_maid_project/Controllers/splashController.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final SplashScreenController _controller = SplashScreenController();

  @override
  void initState() {
    super.initState();
    _controller.startSplashSequence(() {
      setState(() {
        _controller.changeSplashAppearance(() {
          _controller.handleUserNavigation(context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions in pixels
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get the device pixel ratio
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate the diagonal screen size in pixels
    final diagonalPixels = sqrt(
      pow(screenWidth * devicePixelRatio, 2) +
          pow(screenHeight * devicePixelRatio, 2),
    );

    // Calculate the DPI (dots per inch)
    final dpi = devicePixelRatio * 160;

    // Calculate the diagonal size in inches
    final diagonalInches = diagonalPixels / dpi;

    // Print the screen size in inches for debugging
    print('Screen size is: $diagonalInches inches');

    // Initialize the ScreenSizeController and set the screen category based on the screen inches
    final screenSizeController = Get.put(ScreenSizeController());
    screenSizeController.setScreenCategoryByInches(diagonalInches);
    return SafeArea(
      child: Scaffold(
        backgroundColor: _controller.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _controller.logoAsset,
                width: 150,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
