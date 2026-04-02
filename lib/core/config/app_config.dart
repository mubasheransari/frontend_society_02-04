import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:4000';
    if (Platform.isAndroid) return 'http://10.0.2.2:4000';
    if (Platform.isIOS || Platform.isMacOS) return 'http://localhost:4000';
    return 'http://localhost:4000';
  }
}
