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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDNaZUS764q_08qHMiyrkZPjdq5SNXANbU',
    appId: '1:494269889530:web:5e53ee16a51f3bb5730243',
    messagingSenderId: '494269889530',
    projectId: 'time-manager-1bc06',
    authDomain: 'time-manager-1bc06.firebaseapp.com',
    storageBucket: 'time-manager-1bc06.appspot.com',
    measurementId: 'G-DWSFHNQ9P3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQdduXRo8hxsClBpi-UvI_aesu0QPBFkg',
    appId: '1:494269889530:android:d6a39f42f4cb4126730243',
    messagingSenderId: '494269889530',
    projectId: 'time-manager-1bc06',
    storageBucket: 'time-manager-1bc06.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4lArz4KyrkgejyXRknAd-UC8m4YiduNw',
    appId: '1:494269889530:ios:412f939f83be413a730243',
    messagingSenderId: '494269889530',
    projectId: 'time-manager-1bc06',
    storageBucket: 'time-manager-1bc06.appspot.com',
    iosBundleId: 'com.example.timeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4lArz4KyrkgejyXRknAd-UC8m4YiduNw',
    appId: '1:494269889530:ios:309f063fbf6663ce730243',
    messagingSenderId: '494269889530',
    projectId: 'time-manager-1bc06',
    storageBucket: 'time-manager-1bc06.appspot.com',
    iosBundleId: 'com.example.timeApp.RunnerTests',
  );
}
