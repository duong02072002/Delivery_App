import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomeController() {
    print('SESSION USER: ${user.toJson()}');
  }
  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // XÓA LỊCH SỬ MÀN HÌNH
  }
}
