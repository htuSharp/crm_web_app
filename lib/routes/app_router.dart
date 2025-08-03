// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/datamanagement/data_management_page.dart';
import '../pages/inventory_page.dart';
import '../pages/invoice_page.dart';
import '../pages/retailer_bills_page.dart';
import '../pages/mr_planner_page.dart';
import '../pages/activity_log_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case '/':
        builder = (_) => const HomePage();
        break;
      case '/dashboard':
        builder = (_) => const DashboardPage();
        break;
      case '/data-management':
        builder = (_) => const DataManagementPage();
        break;
      case '/inventory':
        builder = (_) => const InventoryPage();
        break;
      case '/stock-invoices':
        builder = (_) => const InvoicePage();
        break;
      case '/retailer-bills':
        builder = (_) => const RetailerBillsPage();
        break;
      case '/mr-planner':
        builder = (_) => const MRPlannerPage();
        break;
      case '/activity-log':
        builder = (_) => const ActivityLogPage();
        break;
      default:
        builder = (_) =>
            const Scaffold(body: Center(child: Text('Page not found')));
    }

    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     const begin = Offset(1.0, 0.0);
    //     const end = Offset.zero;
    //     const curve = Curves.easeInOut;

    //     var tween = Tween(
    //       begin: begin,
    //       end: end,
    //     ).chain(CurveTween(curve: curve));
    //     return SlideTransition(position: animation.drive(tween), child: child);
    //   },
    //   transitionDuration: const Duration(milliseconds: 400),
    // );

    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     final curve = Curves.easeInOut;
    //     final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
    //     return ScaleTransition(
    //       scale: curvedAnimation,
    //       child: child,
    //     );
    //   },
    //   transitionDuration: const Duration(milliseconds: 400),
    // );

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(scale: curvedAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
