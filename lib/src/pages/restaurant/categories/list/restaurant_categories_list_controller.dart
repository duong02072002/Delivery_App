import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/category.dart';
import '../../../../models/product.dart';
import '../../../../providers/categories_provider.dart';

class RestaurantCategoriesListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();

  List<Category> categories = <Category>[].obs;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;

  RestaurantCategoriesListController();

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
    update();
  }

  void getAllCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
    update();
  }

  void goToCreateCategories() async {
    await Get.toNamed('/restaurant/categories/create');
    getAllCategories(); // Cập nhật danh sách danh mục sau khi quay lại từ trang tạo danh mục
  }
}
