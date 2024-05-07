import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../models/product.dart';
import '../list/client_products_list_controller.dart';

class ClientProductsDetailController extends GetxController {
  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find();

  void checkIfProductsWasAdded(Product product, var price, var counter) {
    price.value = product.price ?? 0.0;

    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        // SẢN PHẨM ĐÃ ĐƯỢC THÊM
        counter.value = selectedProducts[index].quantity!;
        price.value = product.price! * counter.value;
      }
    }
  }

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0) {
      // XÁC NHẬN NẾU SẢN PHẨM ĐÃ ĐƯỢC THÊM BẰNG GETSTORAGE VÀO PHIÊN THIẾT BỊ
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index == -1) {
        // CHƯA ĐƯỢC THÊM
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          } else {
            product.quantity = 1;
          }
        }

        selectedProducts.add(product);
      } else {
        //ĐÃ ĐƯỢC THÊM VÀO BỘ LƯU TRỮ
        selectedProducts[index].quantity = counter.value;
      }

      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Product Added');

      productsListController.items.value = 0;
      for (var p in selectedProducts) {
        productsListController.items.value =
            productsListController.items.value + p.quantity!;
      }
    } else {
      Fluttertoast.showToast(
          msg: 'You Must Select At Least One Product To Add');
    }
  }

  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value;
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
    }
  }
}
