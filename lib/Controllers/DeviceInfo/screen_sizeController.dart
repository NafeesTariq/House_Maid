import 'package:get/get.dart';

class ScreenSizeController extends GetxController {
  RxString screenCategory = ''.obs;

  // Method to determine the screen category based on the diagonal size in inches
  void setScreenCategoryByInches(double diagonalInches) {
    print(' screen size is ${diagonalInches}');
    if (diagonalInches < 4.0) {
      screenCategory.value = 'extra-small';
    } else if (diagonalInches < 5.0) {
      screenCategory.value = 'small';
    } else if (diagonalInches < 6.5) {
      screenCategory.value = 'medium';
    } else if (diagonalInches < 7.5) {
      screenCategory.value = 'large';
    } else {
      screenCategory.value = 'extra-large';
    }
  }
}
