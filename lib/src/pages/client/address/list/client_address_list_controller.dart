import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../models/address.dart';
import '../../../../models/user.dart';
import '../../../../providers/address_provider.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  // OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

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

  // void createOrder() async {
  //   Get.toNamed('/client/payments/create');

  // }

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
