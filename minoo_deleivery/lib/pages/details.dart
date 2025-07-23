import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              spreadRadius: -300.0,
              blurStyle: BlurStyle.normal,
              color: Colors.black,
              blurRadius: 40.0,
              offset: Offset(0, 60.0),
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 30),
        height: 400,

        child: Center(
          child: Image.asset(
            'assets/images/Cheeseburger.png',
            height: 350,
            width: 355,
          ),
        ),
      ),
    );
  }
}
