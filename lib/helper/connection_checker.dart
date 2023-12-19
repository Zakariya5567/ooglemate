import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../data/models/connection_model.dart';
import '../helper/routes_helper.dart';

Future<bool> checkInternet(
  BuildContext context,
  String screen,
) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    if (await InternetConnectionChecker().hasConnection) {
      debugPrint("Connected with mobile");
      return true;
    } else {
      debugPrint("no connection");
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(
          context,
          RouterHelper.noConnectionScreen,
          arguments: screen,
        );
      });

      return false;
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    if (await InternetConnectionChecker().hasConnection) {
      debugPrint("Connected with wifi");
      return true;
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, RouterHelper.noConnectionScreen,
            arguments: {"screen", "no Connection"});
      });

      debugPrint("no connection");
      return false;
    }
  } else {
    debugPrint(" not Connected");
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          'No internet connection',
        ),
      );
    });
    return false;
  }
}
