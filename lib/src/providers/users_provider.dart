import 'dart:convert';
import 'dart:io';
import 'package:flutter_delivery_app/src/environment/environment.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<Response> create(User user) async {
    Response response = await post(
      '$url/create',
      user.toJson(),
      headers: {'Content-Type': 'application/json'},
    ); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    return response;
  }

  Future<List<User>> findDeliveryMen() async {
    Response response = await get('$url/findDeliveryMen', headers: {
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

    List<User> users = User.fromJsonList(response.body);

    return users;
  }

  // update k ảnh
  Future<ResponseApi> update(User user) async {
    Response response = await put(
      '$url/updateWithoutImage',
      user.toJson(),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': userSession.sessionToken ?? ''
      },
    ); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    if (response.body == null) {
      Get.snackbar('Error', 'Could Not Update Information');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      Get.snackbar('Error', 'You Are Not Authorized To Make This Request');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  // Future<ResponseApi> updateNotificationToken(String id, String token) async {
  //   Response response = await put('$url/updateNotificationToken', {
  //     'id': id,
  //     'token': token
  //   }, headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': userSession.sessionToken ?? ''
  //   }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

  //   if (response.body == null) {
  //     Get.snackbar('Error', 'Could Not Update Information');
  //     return ResponseApi();
  //   }

  //   if (response.statusCode == 401) {
  //     Get.snackbar('Error', 'You Are Not Authorized To Make This Request');
  //     return ResponseApi();
  //   }

  //   ResponseApi responseApi = ResponseApi.fromJson(response.body);

  //   return responseApi;
  // }

  Future<Stream> createWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<Stream> createDriverWithImage(User user, File image) async {
    Uri uri =
        Uri.http(Environment.API_URL_OLD, '/api/users/createDriverWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path),
      ),
    );
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<Stream> updateWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(),
      filename: basename(image.path),
    ));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  /*
  * GET X
   */
  Future<ResponseApi> createUserWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });
    Response response = await post('$url/createWithImage', form);

    if (response.body == null) {
      Get.snackbar('Error In The Request', 'Could Not Create User');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> createDriverWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });
    Response response = await post('$url/createDriverWithImage', form);

    if (response.body == null) {
      Get.snackbar('Error In The Request', 'Could Not Create User');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response response = await post('$url/login', {
      'email': email,
      'password': password
    }, headers: {
      'Content-Type': 'application/json'
    }); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    if (response.body == null) {
      Get.snackbar('Error', 'The Request Could Not Be Executed');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
