import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter_delivery_app/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfileUpdateController extends GetxController {
  User user = User.fromJson(GetStorage().read('user'));

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  UsersProvider usersProvider = UsersProvider();

  ClientProfileInfoController clientProfileInfoController = Get.find();

  ClientProfileUpdateController() {
    print('USER SESION: ${GetStorage().read('user')}');
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }
  void updateInfo(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;

    if (isValidForm(name, lastname, phone)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Update Profile...');

      User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        sessionToken: user.sessionToken,
      );

      if (imageFile == null) {
        ResponseApi responseApi = await usersProvider.update(myUser);
        print('Response Api Update: ${responseApi.data}');
        Get.snackbar('Process Finished', responseApi.message ?? '');
        progressDialog.close();

        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          clientProfileInfoController.user.value =
              User.fromJson(GetStorage().read('user') ?? {});
        }
      } else {
        Stream stream = await usersProvider.updateWithImage(myUser, imageFile!);
        stream.listen((res) {
          progressDialog.close();

          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Process Finished', responseApi.message ?? '');
          print('Response Api Update: ${responseApi.data}');
          if (responseApi.success == true) {
            GetStorage().write('user', responseApi.data);
            clientProfileInfoController.user.value =
                User.fromJson(GetStorage().read('user') ?? {});
          } else {
            Get.snackbar('Register Fall', responseApi.message ?? '');
          }
        });
      }
    }
  }

  bool isValidForm(
    String name,
    String lastname,
    String phone,
  ) {
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
