// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text(
              'PharmaCRM Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          _buildTile(context, 'Dashboard', '/dashboard'),
          _buildTile(context, 'Data Management', '/data-management'),
          _buildTile(context, 'Inventory', '/inventory'),
          _buildTile(context, 'Stock Invoices', '/stock-invoices'),
          _buildTile(context, 'Retailer Bills', '/retailer-bills'),
          _buildTile(context, 'MR Activity Planner', '/mr-planner'),
          _buildTile(context, 'Activity Log', '/activity-log'),
        ],
      ),
    );
  }

  ListTile _buildTile(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
