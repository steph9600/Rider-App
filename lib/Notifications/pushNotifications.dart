import 'package:drivers_app/components/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initialize() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
    });
    FirebaseMessaging.onBackgroundMessage(
        (message) => _firebaseMessagingBackgroundHandler(message));
  }

  Future<String> getToken() async {
    String token = await messaging.getToken();
    print("This is a token ::");
    print(token);
    driversRef.child(currentFirebaseUser.uid).child("token").set(token);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
