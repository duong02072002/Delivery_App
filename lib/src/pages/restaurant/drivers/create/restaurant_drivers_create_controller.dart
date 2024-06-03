import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantDriversCreateController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  void driver(BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('Email $email');
    print('Password $password');

    if (isValidForm(email, name, lastname, phone, password, confirmPassword)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Recording Data ...');

      User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password,
      );

      // Response response = await usersProvider.create(user);
      // print('RESPONSE: ${response.body}');
      // Get.snackbar('Valid Form', 'Are you ready to send the HTTP request?');
      Stream stream =
          await usersProvider.createDriverWithImage(user, imageFile!);
      stream.listen((res) {
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          GetStorage().write(
              'user', responseApi.data); // DỮ LIỆU NGƯỜI DÙNG TRONG PHIÊN
          clearFormFields();
        } else {
          Get.snackbar('Register driver fall', responseApi.message ?? '');
        }
      });
    }
  }

  void clearFormFields() {
    emailController.text = '';
    nameController.text = '';
    lastnameController.text = '';
    phoneController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
  }

  bool isValidForm(
    String email,
    String name,
    String lastname,
    String phone,
    String password,
    String confirmPassword,
  ) {
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
    if (imageFile == null) {
      Get.snackbar('Invalid Form', 'You Must Select A Profile Image');
      return false;
    }
    return true;
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: const Text(
          'GALLERY',
          style: TextStyle(color: Colors.amber),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: const Text(
          'CAMERA',
          style: TextStyle(color: Colors.amber),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Select An Option'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
