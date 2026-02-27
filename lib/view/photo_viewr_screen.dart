import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<Map<String, dynamic>> photos;
  final int initialIndex;
  final Set<int> favorites;
  final Function(int) onFavoriteToggle;

  const PhotoViewerScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _handleFavorite() {
    final photoId = widget.photos[_currentIndex]['id'] as int;
    widget.onFavoriteToggle(photoId);
    setState(() {}); // Rebuild to show updated favorite state
  }

  void _handleDownload() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Photo downloaded successfully'),
        backgroundColor: ClientTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
        ),
      ),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening share menu...'),
        backgroundColor: ClientTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);
    final photoId = widget.photos[_currentIndex]['id'] as int;
    final isFavorite = widget.favorites.contains(photoId);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showControls
          ? AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: Text(
          '${languageProvider.getText('photo_of')} ${_currentIndex + 1}/${widget.photos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      )
          : null,
      body: Stack(
        children: [
          // Photo PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _toggleControls,
                child: Center(
                  child: Hero(
                    tag: 'photo_${widget.photos[index]['id']}',
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ClientTheme.primaryPurple.withOpacity(0.3),
                            ClientTheme.lightPurple.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(ClientTheme.radiusLarge),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 120,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Bottom Controls
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(ClientTheme.spacing20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Swipe Indicator
                      Text(
                        languageProvider.getText('swipe_navigate'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: ClientTheme.spacing20),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Download Button
                          _buildActionButton(
                            icon: Icons.download_rounded,
                            label: languageProvider.getText('download'),
                            onPressed: _handleDownload,
                          ),

                          // Favorite Button
                          _buildActionButton(
                            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                            label: languageProvider.getText('favorite'),
                            onPressed: _handleFavorite,
                            isActive: isFavorite,
                            activeColor: ClientTheme.accentPink,
                          ),

                          // Share Button
                          _buildActionButton(
                            icon: Icons.share_rounded,
                            label: languageProvider.getText('share'),
                            onPressed: _handleShare,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Page Indicators
          if (_showControls && widget.photos.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ClientTheme.spacing16,
                    vertical: ClientTheme.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.photos.length > 10 ? 10 : widget.photos.length,
                          (index) {
                        if (widget.photos.length > 10 && index == 9) {
                          return Text(
                            '...',
                            style: TextStyle(color: Colors.white.withOpacity(0.5)),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? activeColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isActive
                ? (activeColor ?? ClientTheme.primaryPurple)
                : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: Colors.white,
            iconSize: 28,
          ),
        ),
        const SizedBox(height: ClientTheme.spacing8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}