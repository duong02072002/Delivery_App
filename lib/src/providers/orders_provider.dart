import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../environment/environment.dart';
import '../models/order.dart';
import '../models/response_api.dart';
import '../models/user.dart';

class OrdersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/orders';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get('$url/findByStatus/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    if (response.statusCode == 401) {
      Get.snackbar(
        'Request Denied',
        'Your User Is Not Allowed To Read This Information',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<List<Order>> findByDeliveryAndStatus(
      String idDelivery, String status) async {
    Response response =
        await get('$url/findByDeliveryAndStatus/$idDelivery/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    if (response.statusCode == 401) {
      Get.snackbar(
        'Request Denied',
        'Your User Is Not Allowed To Read This Information',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<List<Order>> findByClientAndStatus(
      String idClient, String status) async {
    Response response =
        await get('$url/findByClientAndStatus/$idClient/$status', headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    if (response.statusCode == 401) {
      Get.snackbar(
        'Request Denied',
        'Your User Is Not Allowed To Read This Information',
      );
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<ResponseApi> create(Order order) async {
    Response response = await post('$url/create', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToDispatched(Order order) async {
    Response response =
        await put('$url/updateToDispatched', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response response =
        await put('$url/updateToOnTheWay', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    Response response =
        await put('$url/updateToDelivered', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response response =
        await put('$url/updateLatLng', order.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userSession.sessionToken ?? ''
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }
}
