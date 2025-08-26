import 'package:flutter/material.dart';
import 'package:minoo_deleivery/services/address/Delivery_center_dropDownButton.dart';
import 'package:minoo_deleivery/services/address/destination_dropdown.dart';

class Addresspage extends StatelessWidget {
  const Addresspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sellect Adress"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DeliveryCenterDropdown(),
            SizedBox(height: 24),
            DestinationDropdown(),
          ],
        ),
      ),
    );
  }
}
