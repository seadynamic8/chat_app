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
    apiKey: 'AIzaSyBlJmNcUwl3rlAUXWXJ7VzQMbSeG7cGHD8',
    appId: '1:1069232687356:web:cc687d9f8098a53d64af79',
    messagingSenderId: '1069232687356',
    projectId: 'dazzely',
    authDomain: 'dazzely.firebaseapp.com',
    storageBucket: 'dazzely.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWrmrs_as5JaDIEDW0NPmhvK8rS4mod48',
    appId: '1:1069232687356:android:c7c7f4cf2711a5be64af79',
    messagingSenderId: '1069232687356',
    projectId: 'dazzely',
    storageBucket: 'dazzely.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFihX4vi1fFCxnmfYOc6BNf83MQZRMlFM',
    appId: '1:1069232687356:ios:d190736e8311500f64af79',
    messagingSenderId: '1069232687356',
    projectId: 'dazzely',
    storageBucket: 'dazzely.appspot.com',
    iosBundleId: 'com.stcache.dazzelyChatTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFihX4vi1fFCxnmfYOc6BNf83MQZRMlFM',
    appId: '1:1069232687356:ios:bea4a2d3e2b5dba064af79',
    messagingSenderId: '1069232687356',
    projectId: 'dazzely',
    storageBucket: 'dazzely.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}