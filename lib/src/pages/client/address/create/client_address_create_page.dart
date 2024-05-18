import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:get/get.dart';

class ClientAddressCreatePage extends StatelessWidget {
  ClientAddressCreateController con = Get.put(ClientAddressCreateController());

  ClientAddressCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _boxForm(context),
          Column(
            children: [
              _textNewAddress(context),
            ],
          ),
          _iconBack(),
        ],
      ),
    );
  }

  Widget _iconBack() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 15, top: 10),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: Colors.amber.shade500,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
      ),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.53,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.32, left: 20, right: 20),
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
            _textYourInfo(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldRefPoint(context),
            _buttonCreate(context),
          ],
        ),
      ),
    );
  }

  Widget _textFieldAddress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextField(
        controller: con.addressController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Name',
          prefixIcon: const Icon(Icons.location_on),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: con.neighborhoodController,
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: 'Neighborhood',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        onTap: () => con.openGoogleMaps(context),
        controller: con.refPointController,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Reference Point',
          prefixIcon: const Icon(Icons.map),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: ElevatedButton(
        onPressed: () {
          con.createAddress();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'CREATE ADDRESS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textNewAddress(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              size: 100,
              color: Colors.black87,
            ),
            SizedBox(height: 5),
            Text(
              'NEW ADDRESS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 25, bottom: 12),
      child: const Text(
        'ADDRESS',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

// import 'package:flutter/material.dart';
// import 'package:flutter_delivery_app/src/pages/client/address/create/client_address_create_controller.dart';
// import 'package:get/get.dart';

// class ClientAddressCreatePage extends StatelessWidget {
//   final ClientAddressCreateController con =
//       Get.put(ClientAddressCreateController());

//   ClientAddressCreatePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _backgroundCover(context),
//           _boxForm(context),
//           _textNewAddress(),
//           _iconBack(),
//         ],
//       ),
//     );
//   }

//   Widget _iconBack() {
//     return SafeArea(
//       child: Container(
//         margin: const EdgeInsets.only(left: 15),
//         child: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             size: 30,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _backgroundCover(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.35,
//       color: Colors.amber,
//     );
//   }

//   Widget _boxForm(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.55,
//       margin: EdgeInsets.only(
//         top: MediaQuery.of(context).size.height * 0.3,
//         left: 30,
//         right: 30,
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black54,
//             blurRadius: 15,
//             offset: Offset(0, 0.75),
//           ),
//         ],
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _textYourInfo(),
//             const SizedBox(height: 15),
//             _textFieldAddress(),
//             const SizedBox(height: 20),
//             _textFieldNeighborhood(),
//             const SizedBox(height: 20),
//             _textFieldRefPoint(),
//             const SizedBox(height: 30),
//             _buttonCreate(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _textFieldAddress() {
//     return const TextField(
//       // controller: con.addressController,
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         hintText: 'Address',
//         prefixIcon: Icon(Icons.location_on),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _textFieldNeighborhood() {
//     return const TextField(
//       // controller: con.neighborhoodController,
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//         hintText: 'Neighborhood',
//         prefixIcon: Icon(Icons.location_city),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _textFieldRefPoint() {
//     return TextField(
//       // onTap: () => con.openGoogleMaps(context),
//       // controller: con.refPointController,
//       focusNode: AlwaysDisabledFocusNode(),
//       keyboardType: TextInputType.text,
//       decoration: const InputDecoration(
//         hintText: 'Reference Point',
//         prefixIcon: Icon(Icons.map),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buttonCreate(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         // onPressed: () {
//         //   con.createAddress();
//         // },
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 15),
//           backgroundColor: Colors.amber,
//         ),
//         child: const Text(
//           'CREATE ADDRESS',
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _textNewAddress() {
//     return SafeArea(
//       child: Container(
//         margin: const EdgeInsets.only(top: 15),
//         alignment: Alignment.topCenter,
//         child: const Column(
//           children: [
//             Icon(Icons.location_on, size: 100, color: Colors.white),
//             Text(
//               'NEW ADDRESS',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 23,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _textYourInfo() {
//     return const Center(
//       child: Text(
//         'ADDRESS',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 28,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => false;
// }
