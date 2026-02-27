import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';
import 'access_screen.dart';

class ClientSplashScreen extends StatefulWidget {
  const ClientSplashScreen({super.key});

  @override
  State<ClientSplashScreen> createState() => _ClientSplashScreenState();
}

class _ClientSplashScreenState extends State<ClientSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate to access screen after delay
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AccessScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);

    return Scaffold(
      backgroundColor: ClientTheme.softWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ClientTheme.softWhite,
              ClientTheme.primaryPurple.withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ClientTheme.primaryPurple,
                              ClientTheme.deepPurple,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(ClientTheme.radiusXLarge),
                          boxShadow: [
                            BoxShadow(
                              color: ClientTheme.primaryPurple.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.photo_library_rounded,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: ClientTheme.spacing32),

                      // App Name
                      Text(
                        languageProvider.getText('app_name'),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: ClientTheme.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: ClientTheme.spacing12),

                      // Tagline
                      Text(
                        languageProvider.getText('tagline'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: ClientTheme.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: ClientTheme.spacing40),

                      // Subtle Loading Indicator
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ClientTheme.primaryPurple.withOpacity(0.6),
                          ),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}