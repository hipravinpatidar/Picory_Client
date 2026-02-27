import 'package:flutter/material.dart';
import 'package:picory_client/ui_helpers/client_theme.dart';
import 'package:picory_client/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controller/client_language_provider.dart';

void main() {
  runApp(const PicoryClientApp());
}

class PicoryClientApp extends StatelessWidget {
  const PicoryClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientLanguageProvider(),
      child: Consumer<ClientLanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Picory Client',
            debugShowCheckedModeBanner: false,
            theme: ClientTheme.lightTheme,
            home: const ClientSplashScreen(),
          );
        },
      ),
    );
  }
}