import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Replace the placeholder values below with your Firebase project credentials,
/// or run `flutterfire configure` to generate this file automatically.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAhgeI9GObIoZLrOCnkIrO7pyiu8cDgks',
    appId: '1:895233325265:web:3db9ce2860ec041a4c6df0',
    messagingSenderId: '895233325265',
    projectId: 'minoo-6858f',
    authDomain: 'minoo-6858f.firebaseapp.com',
    storageBucket: 'minoo-6858f.firebasestorage.app',
    measurementId: 'G-M41RNCC4LP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAv1fZDxa5O9K45nCouB9Ln_A5sx_CElRU',
    appId: '1:895233325265:android:de2596de01fccd444c6df0',
    messagingSenderId: '895233325265',
    projectId: 'minoo-6858f',
    storageBucket: 'minoo-6858f.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkmiE489Oxmum8euuzRKUu2u-MmEA238A',
    appId: '1:895233325265:ios:dc5ef8c4b6176ba84c6df0',
    messagingSenderId: '895233325265',
    projectId: 'minoo-6858f',
    storageBucket: 'minoo-6858f.firebasestorage.app',
    iosBundleId: 'com.example.minooDeleivery',
  );
}
