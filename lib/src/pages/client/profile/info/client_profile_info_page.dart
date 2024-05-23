import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController con = Get.put(ClientProfileInfoController());

  ClientProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            _backgroundCover(context),
            _boxForm(context),
            Column(
              children: [
                _buttonSignOut(),
                _buttonRoles(),
              ],
            ),
            Column(
              children: [
                _imageUser(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.28, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
            _textName(),
            _textEmail(),
            _textPhone(),
            _buttonUpdate(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonRoles() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => con.goToRoles(),
        icon: const Icon(
          Icons.supervised_user_circle,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _buttonSignOut() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () => con.signOut(),
          icon: const Icon(
            Icons.power_settings_new,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buttonUpdate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: ElevatedButton(
        onPressed: () => con.goToProfileUpdate(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'UPDATE PROFILE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: con.user.value.image != null
              ? NetworkImage(con.user.value.image!)
              : const AssetImage('assets/img/user_profile.png')
                  as ImageProvider,
          radius: 60,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _textName() {
    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 8, left: 15),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(
          '${con.user.value.name ?? ''} ${con.user.value.lastname ?? ''}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'User Name',
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _textEmail() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 8, left: 15),
      child: ListTile(
        leading: const Icon(Icons.email),
        title: Text(
          con.user.value.email ?? '',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Email',
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _textPhone() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 12, left: 15),
      child: ListTile(
        leading: const Icon(Icons.phone),
        title: Text(
          con.user.value.phone ?? '',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text(
          'Phone',
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
