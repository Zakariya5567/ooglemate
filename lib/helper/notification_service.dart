import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/view/screens/car_detail_screen/car_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../providers/profile_provider.dart';
import '../utils/app_constant.dart';

// To initialized notification to handel notification in background
Future<void> backgroundHandler(RemoteMessage message) async {}

// initialized FlutterLocalNotificationsPlugin

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  // To initialized notification
  Future<void> initialize() async {
    //initialization for background
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // initializationSettings  for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    // initializationSettings  for IOS
    const DarwinInitializationSettings initializationSettingsIos =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // Initialization of setting for both android and ios

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    // When the notification in foreground and user click on it
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Payload=====================.>>>>>>: ${response.payload}");
        //Checking for type of notification to navigate to its related screen
        if (response.payload == "PREFERENCE") {
          navigatorKey.currentState!.pushNamed(RouterHelper.homeScreen);
        } else if (response.payload == "TRIGGER") {
          navigatorKey.currentState!.pushNamed(RouterHelper.triggerScreen);
        } else if (response.payload == "NOTIFY") {
        } else {
          navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) {
            return CarDetailScreen(adId: int.parse(response.payload!));
          }));
        }
      },
    );
  }

  // Notification detail for android

  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "high_importance_channel", // id
    'High Importance Notifications', // title
    importance: Importance.max,
    priority: Priority.high,
  );

  // Notification detail for Ios

  static const DarwinNotificationDetails iosNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // After initialize we create channel in displayNotification method

  Future<void> displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: iosNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          // To set type of notification
          payload: message.data['type'] == "PREFERENCE"
              ? message.data['type']
              : message.data['type'] == "TRIGGER"
                  ? message.data['type']
                  : message.data['type'] == "TRACK_PURCHASE" ||
                          message.data['type'] == "TRACK_SOLD"
                      ? message.data['ad_id']
                      : message.data['NOTIFY']);
    } on Exception catch (e) {
      print(e);
    }
  }

  // Function use to create notification locally
  // e.g when download file we will display success message in notification
  Future<void> displayAlertNotification() async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: iosNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        id,
        "Ooglemate",
        "File dawnload succesfully",
        notificationDetails,
        payload: "NOTIFY",
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  // NOTIFICATION HANDLER
  Future<void> handleNotification(context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        debugPrint("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          if (message.notification != null) {
            // creating instance of shared preferences
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            // get the login status of the user
            bool? isLogin = sharedPreferences.getBool(AppConstant.isLogin);
            debugPrint("New Notification");

            // check for status
            if (isLogin == true) {
              // check for notification type to navigate to related screen when user tap on it,
              if (message.data['type'] == "PREFERENCE") {
                navigatorKey.currentState!.pushNamed(RouterHelper.homeScreen);
              } else if (message.data['type'] == "TRIGGER") {
                navigatorKey.currentState!
                    .pushNamed(RouterHelper.triggerScreen);
              } else if (message.data['type'] == "TRACK_PURCHASE" ||
                  message.data['type'] == "TRACK_SOLD") {
                navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (context) {
                  return CarDetailScreen(
                      adId: int.parse(message.data['ad_id']));
                }));
              }
              // set notification status to show notification icon highlight in home screen
              profileProvider.setNotificationStatus(true);
            }
          } else {
            navigatorKey.currentState!.pushNamed(RouterHelper.signInScreen);
          }
        }
      },
    );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        debugPrint("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          debugPrint("message.data ${message.data}");

          //  set notification status in profile provider class to show notification icon highlight in home screen
          profileProvider.setNotificationStatus(true);

          // Display notification
          displayNotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          debugPrint("message.data ${message.data}");

          //  set notification status in profile provider class to show notification icon highlight in home screen
          profileProvider.setNotificationStatus(true);

          // checking for notification type
          if (message.data['type'] == "PREFERENCE") {
            navigatorKey.currentState!.pushNamed(RouterHelper.homeScreen);
          } else if (message.data['type'] == "TRIGGER") {
            navigatorKey.currentState!.pushNamed(RouterHelper.triggerScreen);
          } else if (message.data['type'] == "TRACK_PURCHASE" ||
              message.data['type'] == "TRACK_SOLD") {
            navigatorKey.currentState!
                .push(MaterialPageRoute(builder: (context) {
              return CarDetailScreen(adId: int.parse(message.data['ad_id']));
            }));
          }
        }
      },
    );
  }
}
