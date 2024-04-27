import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController con = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 48,
        child: _textDontHaveAccount(),
      ),
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          Column(
            children: [
              _imageCover(),
              _textAppName(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.54,
      decoration: BoxDecoration(
        color: Colors.amber.shade500, // Sử dụng shade400 ở đây
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
      ),
    );
  }

  Widget _textAppName() {
    return const Text(
      'PIZZA DELIVERY',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 3, // Tăng khoảng cách giữa các chữ cái
        color: Colors.black,
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.46,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 0.75),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(),
          ],
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextField(
        controller: con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'E-mail',
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: con.passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: ElevatedButton(
        onPressed: () => con.login(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      child: const Text(
        'LOGIN',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "You Don't Have An Account?",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () => con.goToRegisterPage(),
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.amber.shade500,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageCover() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 15),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/img/delivery.png',
          width: 260,
          height: 260,
        ),
      ),
    );
  }
}
