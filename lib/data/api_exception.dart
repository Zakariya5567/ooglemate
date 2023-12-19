
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../helper/routes_helper.dart';
import 'models/connection_model.dart';

apiException(DioException exception, BuildContext context, String screen) {
  if (exception.type == DioExceptionType.unknown) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          "Internet connection error",
        ),
      );
    });
    debugPrint("Internet connection error");
  } else if (exception.type == DioExceptionType.cancel) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          "Request to API server was cancelled",
        ),
      );
    });
    debugPrint("Request to API server was cancelled");
  } else if (exception.type == DioExceptionType.receiveTimeout) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          "Receive timeout error",
        ),
      );
    });
    debugPrint("Receive timeout with API server");
  } else if (exception.type == DioExceptionType.sendTimeout) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          "Send timeout error",
        ),
      );
    });
    debugPrint("Send timeout with API server");
  } else if (exception.type == DioExceptionType.connectionTimeout) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(
        context,
        RouterHelper.noConnectionScreen,
        arguments: ConnectionModel(
          screen,
          "Connection timeout error",
        ),
      );
    });
    debugPrint("Connection timeout with API server");
  } else if (exception.type == DioExceptionType.badResponse) {
    switch (exception.response!.statusCode) {
      case 400:
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
            context,
            RouterHelper.noConnectionScreen,
            arguments: ConnectionModel(
              screen,
              "Error 400 Bad Request",
            ),
          );
        });
        break;
      case 404:
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
            context,
            RouterHelper.noConnectionScreen,
            arguments: ConnectionModel(
              screen,
              "Error 404 Not Found",
            ),
          );
        });
        break;
      case 500:
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
            context,
            RouterHelper.noConnectionScreen,
            arguments: ConnectionModel(
              screen,
              "500 Server Error",
            ),
          );
        });
        break;
      default:
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(
            context,
            RouterHelper.noConnectionScreen,
            arguments: ConnectionModel(
              screen,
              "Something went Wrong",
            ),
          );
        });
    }
  }
}
