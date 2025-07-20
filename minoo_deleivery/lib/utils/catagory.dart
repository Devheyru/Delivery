import 'package:flutter/material.dart';

class CatagoryTile extends StatefulWidget {
  String catagoryName, imageUrl;
  CatagoryTile({required this.catagoryName, required this.imageUrl});

  @override
  State<CatagoryTile> createState() => _CatagoryState();
}

class _CatagoryState extends State<CatagoryTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(children: []),
    );
  }
}
