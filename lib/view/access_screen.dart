import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';
import 'event_gallery_screen.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  bool _isScanning = false;
  late AnimationController _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _scanAnimation.dispose();
    super.dispose();
  }

  void _handleQRScan() {
    setState(() => _isScanning = true);
    // Simulate QR scanning
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
        _navigateToGallery('Wedding Celebration');
      }
    });
  }

  void _handleManualCode() {
    if (_codeController.text.length == 6) {
      _navigateToGallery('Wedding Celebration');
    }
  }

  void _navigateToGallery(String eventName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EventGalleryScreen(eventName: eventName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('app_name')),
        actions: [
          // Language Toggle
          Container(
            margin: const EdgeInsets.only(right: ClientTheme.spacing12),
            decoration: BoxDecoration(
              color: ClientTheme.lightGray,
              borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
            ),
            child: Row(
              children: [
                _buildLanguageButton('EN', !languageProvider.isHindi, () {
                  if (languageProvider.isHindi) languageProvider.toggleLanguage();
                }),
                _buildLanguageButton('हिं', languageProvider.isHindi, () {
                  if (!languageProvider.isHindi) languageProvider.toggleLanguage();
                }),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ClientTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: ClientTheme.spacing20),

            // Welcome Text
            Text(
              languageProvider.getText('scan_to_access'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ClientTheme.textPrimary,
              ),
            ),

            const SizedBox(height: ClientTheme.spacing40),

            // QR Scan Card
            _buildQRScanCard(languageProvider),

            const SizedBox(height: ClientTheme.spacing24),

            // Divider with OR
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ClientTheme.spacing16),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: ClientTheme.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: ClientTheme.spacing24),

            // Manual Code Entry Card
            _buildManualCodeCard(languageProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ClientTheme.spacing16,
          vertical: ClientTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isActive ? ClientTheme.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : ClientTheme.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildQRScanCard(ClientLanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ClientTheme.spacing24),
        child: Column(
          children: [
            // QR Scanner Frame
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isScanning ? ClientTheme.primaryPurple : ClientTheme.textLight,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(ClientTheme.radiusLarge),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Corner Brackets
                  if (!_isScanning) ..._buildCornerBrackets(),

                  // QR Icon or Scanning Animation
                  if (_isScanning)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ClientTheme.primaryPurple,
                            ),
                            strokeWidth: 4,
                          ),
                        ),
                        const SizedBox(height: ClientTheme.spacing16),
                        Text(
                          languageProvider.getText('scanning'),
                          style: const TextStyle(
                            color: ClientTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  else
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 80,
                      color: ClientTheme.textLight,
                    ),

                  // Scanning Line Animation
                  if (_isScanning)
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: 240 * _scanAnimation.value,
                          child: Container(
                            width: 240,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  ClientTheme.primaryPurple,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: ClientTheme.spacing20),

            // Instructions
            Text(
              languageProvider.getText('position_qr'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: ClientTheme.textSecondary,
              ),
            ),

            const SizedBox(height: ClientTheme.spacing24),

            // Scan Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _handleQRScan,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(languageProvider.getText('scan_qr')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const bracketColor = ClientTheme.primaryPurple;
    const bracketSize = 30.0;
    const bracketThickness = 4.0;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: bracketColor, width: bracketThickness),
              left: BorderSide(color: bracketColor, width: bracketThickness),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: bracketColor, width: bracketThickness),
              right: BorderSide(color: bracketColor, width: bracketThickness),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: bracketColor, width: bracketThickness),
              left: BorderSide(color: bracketColor, width: bracketThickness),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: bracketColor, width: bracketThickness),
              right: BorderSide(color: bracketColor, width: bracketThickness),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildManualCodeCard(ClientLanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ClientTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Icon(
              Icons.password_rounded,
              size: 50,
              color: ClientTheme.primaryPurple.withOpacity(0.3),
            ),

            const SizedBox(height: ClientTheme.spacing20),

            // Title
            Text(
              languageProvider.getText('enter_code'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ClientTheme.textPrimary,
              ),
            ),

            const SizedBox(height: ClientTheme.spacing20),

            // Code Input
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              maxLength: 6,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                hintText: languageProvider.getText('enter_6_digit'),
                hintStyle: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 0,
                ),
                counterText: '',
              ),
            ),

            const SizedBox(height: ClientTheme.spacing24),

            // Continue Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _handleManualCode,
                child: Text(languageProvider.getText('continue')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}