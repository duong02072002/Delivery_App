import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email $email');
    print('Password $password');

    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);

      print('Response Api: ${responseApi.toJson()}');

      if (responseApi.success == true) {
        GetStorage()
            .write('user', responseApi.data); // DỮ LIỆU NGƯỜI DÙNG TRONG PHIÊN
        goToHomePage();
      } else {
        Get.snackbar('Login Fall', responseApi.message ?? '');
      }
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
