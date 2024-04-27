import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email $email');
    print('Password $password');

    if (isValidForm(email, password)) {
      Get.snackbar('Valid form', 'Are you ready to send the HTTP request?');
    }
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter The Email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Form', 'The Email Is Not Valid');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter The Password');
      return false;
    }

    return true;
  }
}
