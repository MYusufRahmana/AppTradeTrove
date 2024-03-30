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
    apiKey: 'AIzaSyB_u3_ecybWdkJ_UFmQpOwhFjGGRjEnJ9s',
    appId: '1:218627885414:web:65bca4bc4f18483f1620a7',
    messagingSenderId: '218627885414',
    projectId: 'tradeapp-1130a',
    authDomain: 'tradeapp-1130a.firebaseapp.com',
    databaseURL: 'https://tradeapp-1130a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tradeapp-1130a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj7Ti-KLLqsxc8Z6foCcjy1cM96ZPRyps',
    appId: '1:218627885414:android:4b9cf11d5f9c51481620a7',
    messagingSenderId: '218627885414',
    projectId: 'tradeapp-1130a',
    databaseURL: 'https://tradeapp-1130a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tradeapp-1130a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDY5H4kUDuoiA9KWnrhquh57cL5flQdl8c',
    appId: '1:218627885414:ios:e78bf9730303f70b1620a7',
    messagingSenderId: '218627885414',
    projectId: 'tradeapp-1130a',
    databaseURL: 'https://tradeapp-1130a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tradeapp-1130a.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDY5H4kUDuoiA9KWnrhquh57cL5flQdl8c',
    appId: '1:218627885414:ios:5c055d2627cb34f91620a7',
    messagingSenderId: '218627885414',
    projectId: 'tradeapp-1130a',
    databaseURL: 'https://tradeapp-1130a-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'tradeapp-1130a.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
