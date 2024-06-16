import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/product.dart';
import '../../products/list/client_products_list_controller.dart';

class ClientOrdersCreateController extends GetxController {
  List<Product> selectedProducts = <Product>[];
  var total = 0.0.obs;
  ClientProductsListController productsListController = Get.find();

  ClientOrdersCreateController() {
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        var result = GetStorage().read('shopping_bag');
        selectedProducts.clear();
        selectedProducts.addAll(result);
      } else {
        var result = Product.fromJsonList(GetStorage().read('shopping_bag'));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }

      getTotal();
    }
    update();
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value = total.value + (product.quantity! * product.price!);
    }
    update();
  }

  void deleteItem(Product product) {
    selectedProducts.remove(product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();

    productsListController.items.value = 0;
    if (selectedProducts.isEmpty) {
      productsListController.items.value = 0;
    } else {
      for (var p in selectedProducts) {
        productsListController.items.value =
            productsListController.items.value + p.quantity!;
      }
    }
    update();
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    product.quantity = product.quantity! + 1;
    selectedProducts.insert(index, product);
    GetStorage().write('shopping_bag', selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    for (var p in selectedProducts) {
      productsListController.items.value =
          productsListController.items.value + p.quantity!;
    }
  }

  void removeItem(Product product) {
    if (product.quantity! > 1) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts.remove(product);
      product.quantity = product.quantity! - 1;
      selectedProducts.insert(index, product);
      GetStorage().write('shopping_bag', selectedProducts);
      getTotal();
      productsListController.items.value = 0;
      for (var p in selectedProducts) {
        productsListController.items.value =
            productsListController.items.value + p.quantity!;
      }
    }
    update();
  }

  void goToAddressList() {
    if (selectedProducts.isNotEmpty) {
      Get.toNamed('/client/address/list');
    } else {
      Get.snackbar(
        'No Products Added',
        'Please add products to your shopping bag before proceeding to checkout.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
