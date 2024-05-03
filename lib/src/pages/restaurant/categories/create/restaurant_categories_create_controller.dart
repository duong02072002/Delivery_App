import 'package:flutter/widgets.dart';
import 'package:flutter_delivery_app/src/models/category.dart';
import 'package:get/get.dart';
import '../../../../models/response_api.dart';
import '../../../../providers/categories_provider.dart';

class RestaurantCategoriesCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;
    print('NAME: $name');
    print('DESCRIPTION: $description');

    if (name.isNotEmpty && description.isNotEmpty) {
      Category category = Category(name: name, description: description);

      ResponseApi responseApi = await categoriesProvider.create(category);
      Get.snackbar('Process Finished', responseApi.message ?? '');

      if (responseApi.success == true) {
        clearForm();
      }
    } else {
      Get.snackbar(
          'Invalid Form', 'Enter All The Fields To Create The Category');
    }
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
  }
}
