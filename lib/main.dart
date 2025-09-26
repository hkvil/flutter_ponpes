import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pesantren_app/screens/debug_screen.dart';
import 'core/utils/auth_utils.dart';
import 'core/theme/app_colors.dart';
import 'core/router/app_router.dart';

/// Entry point of the Pesantren application.
///
/// This widget sets up the overall theme, routing configuration, and
/// initial screen for the app. It leverages [MaterialApp] with a
/// seed color derived from the primary green defined in [AppColors], and
/// turns on Material 3 styling. The router is defined in
/// [AppRouter], which maps route names to pages.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';

  final isLoggedIn = await checkIsLoggedIn();
  runApp(PesantrenApp(isLoggedIn: isLoggedIn));
}

class PesantrenApp extends StatelessWidget {
  final bool isLoggedIn;
  const PesantrenApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pesantren UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      initialRoute: isLoggedIn ? AppRouter.home : AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
