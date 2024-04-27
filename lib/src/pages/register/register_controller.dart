import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/providers/users_provider.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('Email $email');
    print('Password $password');

    if (isValidForm(email, name, lastname, phone, password, confirmPassword)) {
      User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password,
      );

      Response response = await usersProvider.create(user);

      print('RESPONSE: ${response.body}');

      Get.snackbar('Valid Form', 'Are you ready to send the HTTP request?');
    }
  }

  bool isValidForm(String email, String name, String lastname, String phone,
      String password, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter The Email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Form', 'The Email Is Not Valid');
      return false;
    }

    if (name.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter Your Name');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter Your Last Name');
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter Your Phone');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter Your Password');
      return false;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('Invalid Form', 'You Must Enter Your Confirm Password');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('Invalid Form', 'Passwords Do Not Match');
      return false;
    }

    return true;
  }
}
