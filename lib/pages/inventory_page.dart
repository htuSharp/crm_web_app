// lib/pages/inventory_page.dart
import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: const Text('Inventory'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       tooltip: 'Home',
      //       onPressed: () => Navigator.pushNamed(context, '/'),
      //     ),
      //   ],
      // ),
      body: const Center(child: Text('Inventory Overview and Tracking')),
    );
  }
}
