import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/models/order.dart';
import 'package:flutter_delivery_app/src/models/product.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/pages/client/stripe/payment/client_stripe_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/address.dart';
import '../../../../models/user.dart';
import '../../../../providers/address_provider.dart';
import '../../../../providers/orders_provider.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  ClientStripePayment stripePayment = ClientStripePayment();

  var radioValue = 0.obs;

  ClientAddressListController() {
    print('THE SESSION ADDRESS ${GetStorage().read('address')}');
  }

  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByUser(user.id ?? '');
    print('Address $address');
    Address a = Address.fromJson(
        GetStorage().read('address') ?? {}); // ĐỊA CHỈ ĐƯỢC CHỌN CỦA NGƯỜI DÙNG
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      // ĐỊA CHỈ PHIÊN PHÙ HỢP VỚI DỮ LIỆU TRONG DANH SÁCH ĐỊA CHỈ
      radioValue.value = index;
    }

    return address;
  }

//  void createOrder() async {
//     Address a = Address.fromJson(GetStorage().read('address') ?? {});
//     List<Product> products = [];

//     if (GetStorage().read("shopping_bag") is List<Product>) {
//       products = GetStorage().read("shopping_bag");
//     } else {
//       products = Product.fromJsonList(GetStorage().read("shopping_bag"));
//     }

//     Order order = Order(
//       idClient: user.id,
//       idAddress: a.id,
//       products: products,
//     );
//     ResponseApi responseApi = await ordersProvider.create(order);

//     Get.snackbar('finished process', responseApi.message ?? " ");
//     Fluttertoast.showToast(
//         msg: responseApi.message ?? "", toastLength: Toast.LENGTH_LONG);

//     if (responseApi.success == true) {
//       GetStorage().remove('shopping_bag');
//       Get.toNamed('/client/payments/create');
//     }
//   }

  void createOrder(BuildContext context) async {
    // Lấy số tiền từ giỏ hàng hoặc tính toán số tiền từ danh sách sản phẩm
    double totalAmount = calculateTotalAmount();
    stripePayment.makePayment(context, totalAmount.toString());
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    List<Product> products = [];

    // Lấy danh sách sản phẩm từ giỏ hàng
    if (GetStorage().read("shopping_bag") is List<Product>) {
      products = GetStorage().read("shopping_bag");
    } else {
      products = Product.fromJsonList(GetStorage().read("shopping_bag"));
    }

    // Tính tổng số tiền của tất cả sản phẩm trong giỏ hàng
    for (var product in products) {
      totalAmount += product.quantity! * product.price!;
    }

    return totalAmount;
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    print('SELECTED VALUE $value');
    GetStorage().write('address', address[value].toJson());
    update();
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }
}
