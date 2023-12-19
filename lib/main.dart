import 'package:caroogle/data/db/search_history.dart';
import 'package:caroogle/helper/provider_helper.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'helper/notification_service.dart';
import 'helper/routes_helper.dart';
import 'helper/scroll_behaviour.dart';

// creating a global navigation key
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize firebase
  await Firebase.initializeApp();

  //NOTIFICATION
  //Request for permission
  FirebaseMessaging.instance.requestPermission();
  //Initialize notification service class
  await NotificationService().initialize();

  //Hive database
  await Hive.initFlutter();
  Hive.registerAdapter(SearchHistoryAdapter());
  await Hive.openBox<SearchHistory>("search_history");

  //Device Orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderHelper.providers,
      child: MaterialApp(
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              ),
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'ooglemate',
          theme: ThemeData(
            primarySwatch: const MaterialColor(0xFF424F9F, primaryColor),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
          initialRoute: RouterHelper.initial,
          routes: RouterHelper.routes),
    );
  }
}
