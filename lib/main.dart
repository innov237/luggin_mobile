import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luggin/screens/splash.dart';
import 'package:easy_localization/easy_localization.dart';

void main() => runApp(
      EasyLocalization(
        child: MyApp(),
        path: "resources/lang",
        saveLocale: true,
        supportedLocales: [
          Locale("fr", "CA"),
          Locale("en", "EN"),
        ],
        fallbackLocale: Locale("en", "EN"),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2488b9),
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xFF2488B9),
        scaffoldBackgroundColor: Color(0XFFF7FBFB),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(),
    );
  }
}
