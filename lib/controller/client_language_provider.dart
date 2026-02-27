import 'package:flutter/material.dart';

class ClientLanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en'; // 'en' or 'hi'

  String get currentLanguage => _currentLanguage;
  bool get isHindi => _currentLanguage == 'hi';

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'en' ? 'hi' : 'en';
    notifyListeners();
  }

  String getText(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'app_name': 'Picory Client',
      'tagline': 'Your Memories, Delivered.',
      'scan_qr': 'Scan QR Code',
      'enter_code': 'Enter Access Code',
      'access_code': 'Access Code',
      'continue': 'Continue',
      'enter_6_digit': 'Enter 6-digit code',
      'scan_to_access': 'Scan to Access Gallery',
      'position_qr': 'Position QR code within the frame',
      'event_gallery': 'Event Gallery',
      'total_photos': 'Total Photos',
      'search_photos': 'Search photos...',
      'filter': 'Filter',
      'face_scan': 'Face Scan',
      'scan_your_face': 'Scan Your Face',
      'ai_scanning': 'AI is analyzing...',
      'hold_still': 'Hold still for best results',
      'photos_found': 'Photos Found',
      'download': 'Download',
      'share': 'Share',
      'favorite': 'Favorite',
      'favorites': 'Favorites',
      'selected_for_album': 'Selected for Album',
      'no_favorites': 'No favorites yet',
      'add_favorites_msg': 'Select photos to add to your album',
      'scanning': 'Scanning',
      'photo_of': 'Photo',
      'swipe_navigate': 'Swipe to navigate',
    },
    'hi': {
      'app_name': 'पिकोरी क्लाइंट',
      'tagline': 'आपकी यादें, डिलीवर।',
      'scan_qr': 'QR कोड स्कैन करें',
      'enter_code': 'एक्सेस कोड दर्ज करें',
      'access_code': 'एक्सेस कोड',
      'continue': 'जारी रखें',
      'enter_6_digit': '6-अंकीय कोड दर्ज करें',
      'scan_to_access': 'गैलरी एक्सेस के लिए स्कैन करें',
      'position_qr': 'QR कोड को फ्रेम में रखें',
      'event_gallery': 'इवेंट गैलरी',
      'total_photos': 'कुल फोटो',
      'search_photos': 'फोटो खोजें...',
      'filter': 'फ़िल्टर',
      'face_scan': 'फेस स्कैन',
      'scan_your_face': 'अपना चेहरा स्कैन करें',
      'ai_scanning': 'AI विश्लेषण कर रहा है...',
      'hold_still': 'सर्वोत्तम परिणाम के लिए स्थिर रहें',
      'photos_found': 'फोटो मिली',
      'download': 'डाउनलोड',
      'share': 'शेयर',
      'favorite': 'पसंदीदा',
      'favorites': 'पसंदीदा',
      'selected_for_album': 'एल्बम के लिए चयनित',
      'no_favorites': 'अभी तक कोई पसंदीदा नहीं',
      'add_favorites_msg': 'अपने एल्बम में जोड़ने के लिए फोटो चुनें',
      'scanning': 'स्कैनिंग',
      'photo_of': 'फोटो',
      'swipe_navigate': 'नेविगेट करने के लिए स्वाइप करें',
    },
  };
}