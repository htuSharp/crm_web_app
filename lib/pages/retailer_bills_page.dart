// lib/pages/retailer_bills_page.dart
import 'package:crm_web_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class RetailerBillsPage extends StatelessWidget {
  const RetailerBillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: const Text('Retailer Bills'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       tooltip: 'Home',
      //       onPressed: () => Navigator.pushNamed(context, '/'),
      //     ),
      //   ],
      // ),
      body: const Center(child: Text('Retailer Billing System')),
    );
  }
}
