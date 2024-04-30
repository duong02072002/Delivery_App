import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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
