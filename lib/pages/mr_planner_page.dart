// lib/pages/mr_planner_page.dart
import 'package:flutter/material.dart';

class MRPlannerPage extends StatelessWidget {
  const MRPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: const Text('MR Activity Planner'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.home),
      //       tooltip: 'Home',
      //       onPressed: () => Navigator.pushNamed(context, '/'),
      //     ),
      //   ],
      // ),
      body: const Center(child: Text('Plan MR Visits')),
    );
  }
}
