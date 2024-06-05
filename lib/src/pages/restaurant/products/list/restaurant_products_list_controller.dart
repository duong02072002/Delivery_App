import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../models/category.dart';
import '../../../../models/product.dart';
import '../../../../providers/categories_provider.dart';
import '../../../../providers/products_provider.dart';

class RestaurantProductsListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();
  var products = <Product>[].obs;

  List<Product> selectedProducts = [];

  List<Category> categories = <Category>[].obs;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;

  RestaurantProductsListController();

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
    update();
  }

  void getAllProducts() async {
    var result = await productsProvider.findAllProducts();
    products.clear();
    products.addAll(result);
    update();
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      productName.value = text;
      print('COMPLETE TEXT: $text');
      // Kiểm tra nếu text là rỗng, nếu có, gọi lại hàm để lấy lại tất cả sản phẩm
      if (text.isEmpty) {
        getAllProducts();
        update();
      } else {
        // Nếu không, tìm kiếm sản phẩm theo tên
        searchProducts();
        update();
      }
    });
  }

  void searchProducts() async {
    var result = await getProducts(productName.value);
    products.clear();
    products.addAll(result);
    update();
  }

  Future<List<Product>> getProducts(String productName) async {
    return await productsProvider.findByName(productName);
  }

  void deleteProduct(String productId) async {
    // Gọi hàm xóa sản phẩm từ provider
    await productsProvider.deleteProduct(productId);
    // Sau khi xóa, cập nhật lại danh sách sản phẩm
    getAllProducts();
  }

  void goToCreateProduct() async {
    await Get.toNamed('/restaurant/products/create');
    getAllProducts(); // Cập nhật danh sách danh mục sau khi quay lại từ trang tạo danh mục
  }
}
