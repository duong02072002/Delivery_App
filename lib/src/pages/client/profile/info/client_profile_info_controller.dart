import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProfileInfoController extends GetxController {
  var user = User.fromJson(GetStorage().read('user')).obs;
  void signOut() {
    GetStorage().remove('address');
    GetStorage().remove('shopping_bag');
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // XÓA LỊCH SỬ MÀN HÌNH
  }

  void goToProfileUpdate() {
    Get.toNamed('/client/profile/update');
  }

  void goToRoles() {
    Get.offNamedUntil('/roles', (route) => false);
  }
}
