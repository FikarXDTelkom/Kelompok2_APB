import 'package:flutter/material.dart';
import 'management.dart';

class ItemDetailPage extends StatelessWidget {
  final String itemName;

  ItemDetailPage({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Item'),
      ),
      body: Center(
        child: Text('Nama Item: $itemName'),
      ),
    );
  }
}
