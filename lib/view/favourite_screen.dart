import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/client_language_provider.dart';
import '../ui_helpers/client_theme.dart';


class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favoritePhotos;

  const FavoritesScreen({super.key, required this.favoritePhotos});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<ClientLanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.getText('favorites')),
        actions: [
          if (favoritePhotos.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                _showSyncConfirmation(context, languageProvider);
              },
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('Sync'),
              style: TextButton.styleFrom(
                foregroundColor: ClientTheme.primaryPurple,
              ),
            ),
        ],
      ),
      body: favoritePhotos.isEmpty
          ? _buildEmptyState(languageProvider)
          : Column(
        children: [
          // Header Card
          Container(
            margin: const EdgeInsets.all(ClientTheme.spacing16),
            padding: const EdgeInsets.all(ClientTheme.spacing20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ClientTheme.primaryPurple.withOpacity(0.1),
                  ClientTheme.lightPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(ClientTheme.radiusLarge),
              border: Border.all(
                color: ClientTheme.primaryPurple.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ClientTheme.primaryPurple,
                        ClientTheme.deepPurple,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_album_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: ClientTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        languageProvider.getText('selected_for_album'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ClientTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: ClientTheme.spacing4),
                      Text(
                        '${favoritePhotos.length} photos selected',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ClientTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: ClientTheme.successGreen,
                  size: 30,
                ),
              ],
            ),
          ),

          // Photo Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: ClientTheme.spacing16,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: ClientTheme.spacing12,
                mainAxisSpacing: ClientTheme.spacing12,
                childAspectRatio: 1.0,
              ),
              itemCount: favoritePhotos.length,
              itemBuilder: (context, index) {
                return Stack(
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
                        borderRadius: BorderRadius.circular(
                          ClientTheme.radiusSmall,
                        ),
                        border: Border.all(
                          color: ClientTheme.accentPink.withOpacity(0.3),
                          width: 2,
                        ),
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
                );
              },
            ),
          ),

          // Sync Info Footer
          Container(
            padding: const EdgeInsets.all(ClientTheme.spacing20),
            decoration: BoxDecoration(
              color: ClientTheme.cardWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: ClientTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: ClientTheme.spacing12),
                Expanded(
                  child: Text(
                    'These photos will be synced to your photographer\'s album',
                    style: TextStyle(
                      fontSize: 12,
                      color: ClientTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ClientLanguageProvider languageProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ClientTheme.spacing40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ClientTheme.primaryPurple.withOpacity(0.1),
                    ClientTheme.lightPurple.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 60,
                color: ClientTheme.primaryPurple.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: ClientTheme.spacing24),
            Text(
              languageProvider.getText('no_favorites'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ClientTheme.textPrimary,
              ),
            ),
            const SizedBox(height: ClientTheme.spacing12),
            Text(
              languageProvider.getText('add_favorites_msg'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: ClientTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSyncConfirmation(BuildContext context, ClientLanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ClientTheme.radiusLarge),
        ),
        title: const Row(
          children: [
            Icon(Icons.cloud_upload_rounded, color: ClientTheme.primaryPurple),
            SizedBox(width: ClientTheme.spacing12),
            Text('Sync Album'),
          ],
        ),
        content: Text(
          'Your ${favoritePhotos.length} selected photos will be synced to the photographer\'s album. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Album synced successfully!'),
                  backgroundColor: ClientTheme.successGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ClientTheme.radiusMedium),
                  ),
                ),
              );
            },
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }
}