import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isScanning = false;
  bool _scanComplete = false;
  int _photosFound = 0;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _startFaceScan() async {
    setState(() {
      _isScanning = true;
      _scanComplete = false;
    });

    _scanController.repeat();

    // Simulate AI scanning
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      _scanController.stop();
      setState(() {
        _isScanning = false;
        _scanComplete = true;
        _photosFound = 12 + math.Random().nextInt(8); // 12-20 photos
      });
    }
  }

  void _viewFilteredPhotos() {
    Navigator.pop(context);
    // In real app, would navigate to filtered gallery
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('face_scan')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ClientTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: ClientTheme.spacing20),

            // Title
            Text(
              languageProvider.getText('scan_your_face'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ClientTheme.textPrimary,
              ),
            ),

            const SizedBox(height: ClientTheme.spacing12),

            // Subtitle
            Text(
              languageProvider.getText('hold_still'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: ClientTheme.textSecondary,
              ),
            ),

            const SizedBox(height: ClientTheme.spacing40),

            // Face Scan Frame
            Center(
              child: Container(
                width: 280,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ClientTheme.radiusXLarge),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ClientTheme.primaryPurple.withOpacity(0.1),
                      ClientTheme.lightPurple.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Face Outline
                    Center(
                      child: CustomPaint(
                        size: const Size(220, 280),
                        painter: FaceOutlinePainter(
                          isScanning: _isScanning,
                          scanComplete: _scanComplete,
                        ),
                      ),
                    ),

                    // AI Scanning Animation
                    if (_isScanning)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: ScanningLinePainter(
                                progress: _scanController.value,
                              ),
                            );
                          },
                        ),
                      ),

                    // Center Icon
                    Center(
                      child: Icon(
                        _scanComplete ? Icons.check_circle_rounded : Icons.face_rounded,
                        size: 100,
                        color: _scanComplete
                            ? ClientTheme.successGreen
                            : _isScanning
                            ? ClientTheme.primaryPurple
                            : ClientTheme.textLight,
                      ),
                    ),

                    // Scanning Particles
                    if (_isScanning) ..._buildScanningParticles(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: ClientTheme.spacing32),

            // Status Text
            if (_isScanning)
              Column(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        ClientTheme.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: ClientTheme.spacing16),
                  Text(
                    languageProvider.getText('ai_scanning'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ClientTheme.primaryPurple,
                    ),
                  ),
                ],
              ),

            // Success Message
            if (_scanComplete)
              Container(
                padding: const EdgeInsets.all(ClientTheme.spacing20),
                decoration: BoxDecoration(
                  color: ClientTheme.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
                  border: Border.all(
                    color: ClientTheme.successGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: ClientTheme.successGreen,
                      size: 50,
                    ),
                    const SizedBox(height: ClientTheme.spacing12),
                    Text(
                      '$_photosFound ${languageProvider.getText('photos_found')}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ClientTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: ClientTheme.spacing32),

            // Action Buttons
            if (!_isScanning && !_scanComplete)
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _startFaceScan,
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(languageProvider.getText('scan_your_face')),
                ),
              ),

            if (_scanComplete)
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _viewFilteredPhotos,
                  child: const Text('View My Photos'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScanningParticles() {
    return List.generate(8, (index) {
      final angle = (index * math.pi * 2) / 8;
      return AnimatedBuilder(
        animation: _scanController,
        builder: (context, child) {
          final radius = 120 + (30 * math.sin(_scanController.value * math.pi * 2));
          return Positioned(
            left: 140 + radius * math.cos(angle + _scanController.value * math.pi * 2),
            top: 175 + radius * math.sin(angle + _scanController.value * math.pi * 2),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: ClientTheme.primaryPurple.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    });
  }
}

// Custom Painter for Face Outline
class FaceOutlinePainter extends CustomPainter {
  final bool isScanning;
  final bool scanComplete;

  FaceOutlinePainter({required this.isScanning, required this.scanComplete});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = scanComplete
          ? ClientTheme.successGreen
          : isScanning
          ? ClientTheme.primaryPurple
          : ClientTheme.textLight.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw face oval
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawOval(rect, paint);

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = scanComplete ? ClientTheme.successGreen : ClientTheme.primaryPurple
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;

    // Top-left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), cornerPaint);

    // Top-right
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Scanning Line
class ScanningLinePainter extends CustomPainter {
  final double progress;

  ScanningLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          ClientTheme.primaryPurple.withOpacity(0.8),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 4))
      ..strokeWidth = 4;

    final y = size.height * progress;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}