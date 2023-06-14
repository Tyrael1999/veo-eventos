// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDt_5BWYHPUvy8vwWrt99GqDVMJqeFrCqk',
    appId: '1:821100542278:web:8a26a8c2b9296b9f5f4d47',
    messagingSenderId: '821100542278',
    projectId: 'veo-eventos',
    authDomain: 'veo-eventos.firebaseapp.com',
    storageBucket: 'veo-eventos.appspot.com',
    measurementId: 'G-L9W9Y6VR9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATMIyC0uumPZX9aN2pLYBaxisshrNtTg4',
    appId: '1:821100542278:android:9d49dd23a0df35f75f4d47',
    messagingSenderId: '821100542278',
    projectId: 'veo-eventos',
    storageBucket: 'veo-eventos.appspot.com',
  );
}
