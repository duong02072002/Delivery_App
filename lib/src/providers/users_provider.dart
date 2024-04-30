import 'dart:convert';
import 'dart:io';
import 'package:flutter_delivery_app/src/environment/environment.dart';
import 'package:flutter_delivery_app/src/models/response_api.dart';
import 'package:flutter_delivery_app/src/models/user.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  Future<Response> create(User user) async {
    Response response = await post(
      '$url/create',
      user.toJson(),
      headers: {'Content-Type': 'application/json'},
    ); // CHỜ ĐẾN KHI MÁY CHỦ TRẢ LẠI CÂU TRẢ LỜI

    return response;
  }

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
