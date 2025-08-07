import 'package:crm_web_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:crm_web_app/theme/app_theme.dart';
import 'package:crm_web_app/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(CRMApp());
}

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
