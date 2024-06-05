import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../../../models/response_api.dart';
import '../../../../providers/categories_provider.dart';

class RestaurantCategoriesCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  void createCategory(BuildContext context) async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Wait A Minute...');
    await Future.delayed(const Duration(
        milliseconds: 800)); // Chờ 500ms trước khi hiển thị ProgressDialog

    // Kiểm tra điều kiện trước khi tạo danh mục
    if (name.isNotEmpty && description.isNotEmpty) {
      if (name.length < 3 || description.length < 3) {
        progressDialog.close(); // Đóng progressDialog nếu có lỗi
        Get.snackbar('Invalid Form',
            'Name and description must be at least 3 characters long');
        return;
      }

      Category category = Category(name: name, description: description);

      ResponseApi responseApi = await categoriesProvider.create(category);
      progressDialog.close(); // Đóng progressDialog sau khi hoàn thành
      Get.snackbar('Process Finished', responseApi.message ?? '');

      if (responseApi.success == true) {
        clearForm();
        // Cập nhật UI sau khi tạo danh mục thành công
        update();
      }
    } else {
      progressDialog.close(); // Đóng progressDialog nếu không có dữ liệu
      Get.snackbar(
          'Invalid Form', 'Enter all the fields to create the category');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    update();
  }
}
