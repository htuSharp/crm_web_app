// lib/pages/invoice_page.dart
import 'package:crm_web_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: const Text('Stock Invoices'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       tooltip: 'Home',
      //       onPressed: () => Navigator.pushNamed(context, '/'),
      //     ),
      //   ],
      // ),
      body: const Center(child: Text('Manage Invoices')),
    );
  }
}
