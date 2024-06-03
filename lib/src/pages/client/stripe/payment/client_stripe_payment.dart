import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../models/order.dart';
import '../../../../models/product.dart';
import '../../../../models/address.dart' as address;
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/orders_provider.dart';

class ClientStripePayment {
  Map<String, dynamic>? paymentIntentData;
  OrdersProvider ordersProvider = OrdersProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  Future<void> makePayment(BuildContext context) async {
    try {
      print('Start making payment...');
      paymentIntentData = await createPaymentIntent('15', 'USD');
      print('Payment Intent created: $paymentIntentData');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Stripe Payment',
          style: ThemeMode.dark,
        ),
      );
      print('Payment Sheet initialized.');

      showPaymentSheet(context);
    } catch (err) {
      print('Error occurred while making payment: $err');
    }
  }

  showPaymentSheet(BuildContext context) async {
    try {
      print('Start presenting Payment Sheet...');
      await Stripe.instance.presentPaymentSheet().then((value) async {
        print('Payment successful');
        Get.snackbar(
            'Transaction successful', 'Your payment was processed correctly');
        address.Address a =
            address.Address.fromJson(GetStorage().read('address') ?? {});
        List<Product> products = [];

        if (GetStorage().read("shopping_bag") is List<Product>) {
          products = GetStorage().read("shopping_bag");
        } else {
          products = Product.fromJsonList(GetStorage().read("shopping_bag"));
        }

        Order order = Order(
          idClient: user.id,
          idAddress: a.id,
          products: products,
        );
        ResponseApi responseApi = await ordersProvider.create(order);

        //Get.snackbar('finished process', responseApi.message ?? " ");
        Fluttertoast.showToast(
            msg: responseApi.message ?? "", toastLength: Toast.LENGTH_LONG);
        paymentIntentData = null;

        if (responseApi.success == true) {
          GetStorage().remove('shopping_bag');
          Get.offNamedUntil('/client/home', (route) => false);
        }
      }).onError((error, stackTrace) {
        print('Error with the transaction: $error - $stackTrace');
      });
    } on StripeException catch (err) {
      print('Error Stripe: $err');
      showDialog(
        context: context,
        builder: (value) => const AlertDialog(
          content: Text('Operation canceled'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      print('Start creating Payment Intent...');
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51PL3MAHh3zSP7bha8S2OaC9ylSC2RXoKF0VWuCmYL5Rgp96PJGtlnNqQZK4q0Ydy8TIfKsD5z7UTDfOiSdGu9jdd00xYfgF9ub',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      print('Payment Intent created successfully.');
      return jsonDecode(response.body);
    } catch (err) {
      print('Error occurred while creating Payment Intent: $err');
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    final a = int.parse(amount) * 100;
    return a.toString();
  }
}
