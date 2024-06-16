import 'dart:async';
import 'package:get/get.dart';
import '../../../../models/user.dart';
import '../../../../providers/users_provider.dart';

class RestaurantDriversListController extends GetxController {
  UsersProvider usersProvider = UsersProvider();

  List<User> deliveryMen = <User>[].obs;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;

  @override
  void onInit() {
    super.onInit();
    getAllDeliveryMen();
    update();
  }

  void getAllDeliveryMen() async {
    List<User> result = await usersProvider.findDeliveryMen();
    update();
    // Kiểm tra nếu danh sách không rỗng trước khi gán vào deliveryMen
    if (result.isNotEmpty) {
      deliveryMen.clear();
      deliveryMen.addAll(result);
      update(); // Cập nhật danh sách
    }
  }

  void goToCreateCategories() async {
    await Get.toNamed('/restaurant/drivers/create');
    // Sau khi quay lại từ màn hình thêm tài xế, cập nhật danh sách tài xế
    getAllDeliveryMen();
    update();
  }

  void goToStatistics() async {
    await Get.toNamed('/restaurant/statistics/create');
    update();
  }

  void deleteUser(String userId) {
    usersProvider.deleteUser(userId).then((response) {
      if (response.success != null) {
        if (response.success!) {
          // Xóa người dùng khỏi danh sách
          deliveryMen.removeWhere((user) => user.id == userId);
          // Cập nhật số lượng items
          items.value = deliveryMen.length;
          // Hiển thị thông báo xóa thành công
          Get.snackbar('Success', 'User deleted successfully');
        } else {
          // Hiển thị thông báo lỗi nếu không thể xóa người dùng
          Get.snackbar('Error', response.message ?? 'An error occurred');
        }
      } else {
        // Trường hợp success là null
        Get.snackbar('Error', 'Response success is null');
      }
    });
  }
}
