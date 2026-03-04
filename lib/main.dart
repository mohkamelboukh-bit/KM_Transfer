import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'conf.dart';
import 'gen/languages.dart';
import 'logic/language.dart';
import 'logic/theme.dart';
import 'screens/loading.dart';
import 'utils/material_ink_well.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageManager()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: SharikApp(),
    ),
  );
}

class SharikApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.watch<ThemeManager>().brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.grey.shade900.withOpacity(0.4),
              systemNavigationBarColor: Colors.blueGrey.shade900,
              systemNavigationBarIconBrightness: Brightness.light,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.grey.shade100.withOpacity(0.6),
              systemNavigationBarColor: Colors.blue.shade100,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child!,
            ),
            minWidth: 400,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(400, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(680, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1100, name: DESKTOP, scaleFactor: 1.2),
            ],
          );
        },
        locale: context.watch<LanguageManager>().language.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: languageListGen.map((e) => e.locale),
        
        // --- الاسم الجديد الاحترافي ---
        title: 'KM-Transfer', 
        
        theme: ThemeData(
          splashFactory: MaterialInkSplash.splashFactory,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent.shade700, // لون جذاب
          dividerColor: Colors.blue.shade400,
          buttonColor: Colors.blue.shade50.withOpacity(0.6),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
            ),
          ),
        ),
        
        darkTheme: ThemeData(
          splashFactory: MaterialInkSplash.splashFactory,
          brightness: Brightness.dark,
          accentColor: Colors.cyanAccent.shade400, // لون جذاب في الليل
          cardColor: Colors.blueGrey.shade800.withOpacity(0.9),
          dividerColor: Colors.cyanAccent.shade100,
          buttonColor: Colors.blueGrey.shade700,
        ),
        
        themeMode: context.watch<ThemeManager>().theme,
        home: LoadingScreen(),
      ),
    );
  }
}
