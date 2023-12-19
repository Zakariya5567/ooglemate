import 'dart:io';

import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/notification_service.dart';
import '../../helper/routes_helper.dart';
import '../../utils/app_constant.dart';
import '../api_exception.dart';
import '../models/connection_model.dart';

class ApiRepo {
  //Time out : 5 minutes = 300000
  //POST REQUEST

  // Getting four parameters
  // context => use for loader and navigation
  // screen =>  router name
  // url => url of the api
  // Map data => json data for api

  postData(BuildContext context, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint("URL ===========>>> $url");
    debugPrint("POST Sending data  ===========>>> $data");

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);
    debugPrint("Bearer token :$bearerToken");

    // Convert json (Map) to form data
    var formData = FormData.fromMap(data);

    // Define header for api
    final header = Options(
      sendTimeout: const Duration(milliseconds: 300000 ),
      receiveTimeout: const Duration(milliseconds: 300000),
      receiveDataWhenStatusError: true,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    try {
      // Calling Api
      final response = await Dio().post(url, data: formData, options: header);

      // return response back
      return response;
    } on DioException catch (exception) {
      // If Exception Occur

      if (exception.type == DioExceptionType.badResponse) {
        // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen
        if (exception.response!.statusCode == 400) {
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }

  //GET REQUEST
  getData(BuildContext context, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint("URL ===========>>> $url");
    debugPrint("GET Param data  ===========>>> $data");

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);
    debugPrint("Bearer token  :$bearerToken");

    // Define header for api
    final header = Options(
      sendTimeout: const Duration(milliseconds: 300000),
      receiveTimeout: const Duration(milliseconds: 300000),
      receiveDataWhenStatusError: true,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );
    try {
      // Calling Api
      final response =
          await Dio().get(url, options: header, queryParameters: data);
      // return response back
      return response;
    } on DioException catch (exception) {
      // If Exception Occur

      if (exception.type == DioExceptionType.badResponse) {
        // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen

        if (exception.response!.statusCode == 400) {
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }

  //PUT REQUEST

  putData(BuildContext context, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint("URL ===========>>> $url");
    debugPrint("sending data  ===========>>> $data");

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);
    debugPrint("Bearer token :$bearerToken");

    // Define header for api
    final header = Options(
      sendTimeout: const Duration(milliseconds: 300000),
      receiveTimeout: const Duration(milliseconds: 300000),
      receiveDataWhenStatusError: true,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    try {
      // Calling Api
      final response =
          await Dio().put(url, queryParameters: data, options: header);

      // return response back
      return response;
    } on DioException catch (exception) {
      if (exception.type == DioExceptionType.badResponse) {
        // If Exception Occur
        if (exception.response!.statusCode == 400) {
          // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }
  //DELETE REQUEST

  deleteData(BuildContext context, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint("URL ===========>>> $url");
    debugPrint("sending data  ===========>>> $data");

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);
    debugPrint("Bearer token :$bearerToken");

    // Define header for api
    final header = Options(
      sendTimeout: const Duration(milliseconds: 300000),
      receiveTimeout: const Duration(milliseconds: 300000),
      receiveDataWhenStatusError: true,
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    try {
      // Calling Api
      final response = await Dio().delete(
        url,
        queryParameters: data,
        options: header,
      );

      // return response back
      return response;
    } on DioException catch (exception) {
      // If Exception Occur
      if (exception.type == DioExceptionType.badResponse) {
        // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen
        if (exception.response!.statusCode == 400) {
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }

  //POST MULTIPART REQUEST
  //When we are uploading some data like (image,file,video,audio)
  //then we are using multipart request

  postMultipartData(BuildContext context, String screen, String url,
      Map<String, dynamic> data) async {
    debugPrint("URL ===========>>> $url");
    debugPrint("sending data  ===========>>> $data");

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);
    debugPrint("Bearer token :$bearerToken");

    // Define header for api
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = "multipart/form-data";
    dio.options.headers["Authorization"] = "Bearer $bearerToken";
    dio.options.connectTimeout = const Duration(milliseconds: 300000);
    dio.options.receiveTimeout = const Duration(milliseconds: 300000 );
    dio.options.connectTimeout = const Duration(milliseconds: 300000);

    // Convert json (Map) to form data
    FormData formData = FormData.fromMap(data);

    try {
      // Calling Api
      final response = await dio.post(
        url,
        data: formData,
      );
      // return response back
      return response;
    } on DioException catch (exception) {
      // If Exception Occur
      if (exception.type == DioExceptionType.badResponse) {
        // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen
        if (exception.response!.statusCode == 400) {
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }

  //Download
  downloadData(
      BuildContext context, String screen, String url, String savePath) async {
    debugPrint("URL ===========>>> $url");

    //Instance of the  PreferencesAddDataProvider
    // because we are only used download in this screen
    final provider =
        Provider.of<PreferencesAddDataProvider>(context, listen: false);

    // instance of shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Get the bearer token which we have stored in sharedPreferences before
    String? bearerToken = sharedPreferences.getString(AppConstant.bearerToken);

    // Define header for api
    // important when download data -->> HttpHeaders.acceptEncodingHeader: "*"

    final header = Options(
      sendTimeout: const Duration(milliseconds: 300000 ),
      receiveTimeout: const Duration(milliseconds: 300000),
      receiveDataWhenStatusError: true,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        HttpHeaders.acceptEncodingHeader: "*"
      },
    );

    // To initialize percentage variable to store percentage of the download in it
    int? percentage;
    try {
      // Calling Api
      // required url, local path and name of the file
      // split. first is the name of the file

      final response = await Dio().download(
        url,
        savePath,
        options: header,
        onReceiveProgress: (rec, total) {
          // set progress to percentage variable
          percentage = ((rec / total) * 100).floor();

          // set percentage in provider class

          provider.setPercentage(percentage!);
          print("Percentage : $percentage");
        },
      );
      return response;
    } on DioException catch (exception) {
      // If Exception Occur
      if (exception.type == DioExceptionType.badResponse) {
        // if response is 400  then we will return back API response otherwise we will navigate to  Error Screen
        if (exception.response!.statusCode == 400) {
          return exception.response;
        } else {
          Future.delayed(Duration.zero, () {
            // calling api exception class to check which exception which have get
            apiException(exception, context, screen);
          });
        }
      } else {
        Future.delayed(Duration.zero, () {
          // calling api exception class to check which exception which have get
          apiException(exception, context, screen);
        });
      }
      return exception;
    }
  }
}
