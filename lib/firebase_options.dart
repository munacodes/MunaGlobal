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
    apiKey: 'AIzaSyA3k12BcgYSiOGp1IYz-WW55wPEwYjdTwQ',
    appId: '1:730527233229:web:fc2552406bc335508ae584',
    messagingSenderId: '730527233229',
    projectId: 'muna-global-d7d15',
    authDomain: 'muna-global-d7d15.firebaseapp.com',
    databaseURL: 'https://muna-global-d7d15-default-rtdb.firebaseio.com',
    storageBucket: 'muna-global-d7d15.appspot.com',
    measurementId: 'G-RVRDX013GQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFR-5ZqN5PrsGe6-glqle4hGIPDteIAsE',
    appId: '1:730527233229:android:b0391d33a646465b8ae584',
    messagingSenderId: '730527233229',
    projectId: 'muna-global-d7d15',
    databaseURL: 'https://muna-global-d7d15-default-rtdb.firebaseio.com',
    storageBucket: 'muna-global-d7d15.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbTnwyKpdQz5WNseigmqqa12_aQ1EImqE',
    appId: '1:730527233229:ios:ed8f28a30258fa7b8ae584',
    messagingSenderId: '730527233229',
    projectId: 'muna-global-d7d15',
    databaseURL: 'https://muna-global-d7d15-default-rtdb.firebaseio.com',
    storageBucket: 'muna-global-d7d15.appspot.com',
    androidClientId: '730527233229-snafhg36p62jcjssal7sa8ihdu99auca.apps.googleusercontent.com',
    iosClientId: '730527233229-d3vsvg24hbreuqdtf6gmop9vhpelnsu3.apps.googleusercontent.com',
    iosBundleId: 'com.example.munaGlobal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbTnwyKpdQz5WNseigmqqa12_aQ1EImqE',
    appId: '1:730527233229:ios:ed8f28a30258fa7b8ae584',
    messagingSenderId: '730527233229',
    projectId: 'muna-global-d7d15',
    databaseURL: 'https://muna-global-d7d15-default-rtdb.firebaseio.com',
    storageBucket: 'muna-global-d7d15.appspot.com',
    androidClientId: '730527233229-snafhg36p62jcjssal7sa8ihdu99auca.apps.googleusercontent.com',
    iosClientId: '730527233229-d3vsvg24hbreuqdtf6gmop9vhpelnsu3.apps.googleusercontent.com',
    iosBundleId: 'com.example.munaGlobal',
  );
}
