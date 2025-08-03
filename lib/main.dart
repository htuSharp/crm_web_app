import 'package:crm_web_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crm_web_app/theme/app_theme.dart';

void main() => runApp(CRMApp());

class CRMApp extends StatelessWidget {
  const CRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaCRM',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      // home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
