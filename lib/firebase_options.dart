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
    apiKey: 'AIzaSyBDF41_6oZhcWMXCFpIDkqINXsgXPyth7U',
    appId: '1:567202365649:web:c6f4bf5dede4b8e5b585f0',
    messagingSenderId: '567202365649',
    projectId: 'intelligent-pharmacy-1830d',
    authDomain: 'intelligent-pharmacy-1830d.firebaseapp.com',
    storageBucket: 'intelligent-pharmacy-1830d.appspot.com',
    measurementId: 'G-8BN23QK6ED',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwHkvzkgXuR1FQJhRJW3POJNyxbTXrMDw',
    appId: '1:567202365649:android:2cd2a7664b446189b585f0',
    messagingSenderId: '567202365649',
    projectId: 'intelligent-pharmacy-1830d',
    storageBucket: 'intelligent-pharmacy-1830d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtEWCv-vC_BjV3pGGfUHmBMMEakgYLiuo',
    appId: '1:567202365649:ios:1831b1abd95370d6b585f0',
    messagingSenderId: '567202365649',
    projectId: 'intelligent-pharmacy-1830d',
    storageBucket: 'intelligent-pharmacy-1830d.appspot.com',
    iosBundleId: 'com.example.intelligentpharmacy.intelligentPharmacy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBtEWCv-vC_BjV3pGGfUHmBMMEakgYLiuo',
    appId: '1:567202365649:ios:deb233d07de68b37b585f0',
    messagingSenderId: '567202365649',
    projectId: 'intelligent-pharmacy-1830d',
    storageBucket: 'intelligent-pharmacy-1830d.appspot.com',
    iosBundleId: 'com.example.intelligentpharmacy.intelligentPharmacy.RunnerTests',
  );
}
