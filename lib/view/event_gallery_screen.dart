import 'package:flutter/material.dart';
import 'package:picory_client/view/photo_viewr_screen.dart';
import 'package:provider/provider.dart';
import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';
import 'face_scan_screen.dart';
import 'face_scan_screen.dart';
import 'favourite_screen.dart';

class EventGalleryScreen extends StatefulWidget {
  final String eventName;

  const EventGalleryScreen({super.key, required this.eventName});

  @override
  State<EventGalleryScreen> createState() => _EventGalleryScreenState();
}

class _EventGalleryScreenState extends State<EventGalleryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _favorites = {};

  // Sample photo data
  final List<Map<String, dynamic>> _photos = List.generate(
    24,
        (index) => {
      'id': index,
      'url': 'photo_$index',
    },
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(int photoId) {
    setState(() {
      if (_favorites.contains(photoId)) {
        _favorites.remove(photoId);
      } else {
        _favorites.add(photoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.eventName),
            Text(
              '${_photos.length} ${languageProvider.getText('total_photos')}',
              style: const TextStyle(
                fontSize: 12,
                color: ClientTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          // Favorites Badge
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(
                        favoritePhotos: _photos
                            .where((p) => _favorites.contains(p['id']))
                            .toList(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_rounded),
                color: ClientTheme.primaryPurple,
              ),
              if (_favorites.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: ClientTheme.accentPink,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${_favorites.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(ClientTheme.spacing16),
            color: ClientTheme.cardWhite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: languageProvider.getText('search_photos'),
                      prefixIcon: const Icon(Icons.search_rounded),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: ClientTheme.spacing16,
                        vertical: ClientTheme.spacing12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: ClientTheme.spacing12),
                Container(
                  decoration: BoxDecoration(
                    color: ClientTheme.lightGray,
                    borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune_rounded),
                    color: ClientTheme.primaryPurple,
                  ),
                ),
              ],
            ),
          ),

          // Face Scan Button
          Padding(
            padding: const EdgeInsets.all(ClientTheme.spacing16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FaceScanScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.face_rounded),
                label: Text(languageProvider.getText('face_scan')),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: ClientTheme.spacing16),
                ),
              ),
            ),
          ),

          // Photo Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: ClientTheme.spacing16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: ClientTheme.spacing12,
                mainAxisSpacing: ClientTheme.spacing12,
                childAspectRatio: 1.0,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                final photoId = photo['id'] as int;
                final isFavorite = _favorites.contains(photoId);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewerScreen(
                          photos: _photos,
                          initialIndex: index,
                          favorites: _favorites,
                          onFavoriteToggle: _toggleFavorite,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      // Photo Container
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ClientTheme.primaryPurple.withOpacity(0.2),
                              ClientTheme.lightPurple.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(ClientTheme.radiusSmall),
                          border: isFavorite
                              ? Border.all(color: ClientTheme.accentPink, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_rounded,
                            size: 40,
                            color: ClientTheme.primaryPurple.withOpacity(0.4),
                          ),
                        ),
                      ),

                      // Favorite Badge
                      if (isFavorite)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: ClientTheme.accentPink,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}