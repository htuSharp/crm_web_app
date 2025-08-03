import 'package:crm_web_app/pages/activity_log_page.dart';
import 'package:crm_web_app/pages/inventory_page.dart';
import 'package:crm_web_app/pages/invoice_page.dart';
import 'package:crm_web_app/pages/mr_planner_page.dart';
import 'package:crm_web_app/pages/retailer_bills_page.dart';
import 'package:crm_web_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'datamanagement/data_management_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<String> sections = [
    'Dashboard',
    'Data Management',
    'Inventory',
    'Stock Invoices',
    'Retailer Bills',
    'MR Activity Planner',
    'Activity Log',
  ];

  Widget _getSectionWidget(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const DataManagementPage();
      case 2:
        return const InventoryPage();
      case 3:
        return const InvoicePage();
      case 4:
        return const RetailerBillsPage();
      case 5:
        return const MRPlannerPage();
      case 6:
        return const ActivityLogPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('PharmaCRM', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 1,
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Smaller padding
        child: Column(
          children: [
            const Center(
              child: Text(
                'Welcome to PharmaCRM! Select a section below or use the drawer.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey), // Smaller font
              ),
            ),
            const SizedBox(height: 12), // Less vertical space
            Row(
              children: List.generate(sections.length, (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 32), // Smaller height
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[200],
                        foregroundColor: isSelected ? Colors.white : Colors.black,
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Text(sections[index], textAlign: TextAlign.center),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                ),
                child: _getSectionWidget(selectedIndex),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
