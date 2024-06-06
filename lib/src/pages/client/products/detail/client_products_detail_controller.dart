import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../models/product.dart';
import '../list/client_products_list_controller.dart';

class ClientProductsDetailController extends GetxController {
  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find();

  @override
  void onInit() {
    super.onInit();
    if (GetStorage().read('shopping_bag') != null) {
      selectedProducts =
          Product.fromJsonList(GetStorage().read('shopping_bag'));
    }
  }

  void checkIfProductsWasAdded(Product product, var price, var counter) {
    price.value = product.price ?? 0.0;

    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      // Sản phẩm đã được thêm
      counter.value = selectedProducts[index].quantity!;
      price.value = product.price! * counter.value;
    }
  }

  void addToBag(Product product, var price, var counter) {
    if (counter.value > 0) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index == -1) {
        // Chưa được thêm
        product.quantity = counter.value;
        selectedProducts.add(product);
      } else {
        // Đã được thêm vào bộ lưu trữ
        selectedProducts[index].quantity = counter.value;
      }

      GetStorage().write('shopping_bag', selectedProducts);
      Fluttertoast.showToast(msg: 'Product Added');

      updateItemCount();
    } else {
      Fluttertoast.showToast(
          msg: 'You Must Select At Least One Product To Add');
    }
  }

  void updateItemCount() {
    productsListController.items.value =
        selectedProducts.fold(0, (sum, p) => sum + p.quantity!);
    update();
  }

  void addItem(Product product, var price, var counter) {
    counter.value++;
    price.value = product.price! * counter.value;
    update();
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value--;
      price.value = product.price! * counter.value;
      update();
    }
  }
}
