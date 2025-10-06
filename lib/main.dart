import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/utils/auth_utils.dart';
import 'core/theme/app_colors.dart';
import 'core/router/app_router.dart';
import 'providers/achievement_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/banner_menu_utama_provider.dart';
import 'providers/donasi_provider.dart';
import 'providers/informasi_al_ittifaqiah_provider.dart';
import 'providers/kehadiran_provider.dart';
import 'providers/kelas_provider.dart';
import 'providers/lembaga_provider.dart';
import 'providers/prestasi_provider.dart';
import 'providers/santri_provider.dart';
import 'providers/slider_provider.dart';
import 'providers/staff_provider.dart';
import 'providers/tahun_ajaran_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DonasiProvider()),
        ChangeNotifierProvider(create: (_) => SliderProvider()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
        ChangeNotifierProvider(create: (_) => LembagaProvider()),
        ChangeNotifierProvider(create: (_) => BannerMenuUtamaProvider()),
        ChangeNotifierProvider(create: (_) => SantriProvider()),
        ChangeNotifierProvider(create: (_) => KelasProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => KehadiranProvider()),
        ChangeNotifierProvider(create: (_) => PrestasiProvider()),
        ChangeNotifierProvider(
            create: (_) => InformasiAlIttifaqiahProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TahunAjaranProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
