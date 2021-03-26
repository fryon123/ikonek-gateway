import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';

class CloudCommunication {
  String token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  CloudCommunication(callback) {
    print(callback);
    _firebaseMessaging.configure(
        onMessage: callback
    );
  }
}
