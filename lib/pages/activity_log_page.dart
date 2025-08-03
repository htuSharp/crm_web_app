// lib/pages/activity_log_page.dart
// import 'package:crm_web_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: const Text('Activity Log'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       tooltip: 'Home',
      //       onPressed: () => Navigator.pushNamed(context, '/'),
      //     ),
      //   ],
      // ),
      body: const Center(child: Text('View Activity History')),
    );
  }
}
