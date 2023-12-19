import 'package:caroogle/data/repository/api_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/models/dropdown/body_model.dart';

import '../data/models/dropdown/car_models_model.dart';
import '../data/models/dropdown/color_model.dart';
import '../data/models/dropdown/fuel_type_model.dart';
import '../data/models/dropdown/make_model.dart';
import '../data/models/dropdown/transmission_model.dart';
import '../helper/connection_checker.dart';
import '../utils/api_url.dart';

class DropdownProvider extends ChangeNotifier {
  // isLoading used when call api  if true show loading false to end loading
  bool? isLoading;

  // when user make according to make id we will get model
  // when model api called we will set isModel loading to true to show shimmmer
  // when we will get any response from the api then we will set isModelLoading  false to hide shimmer
  bool? isModelLoading;

  // Use for pagination
  int limit = 10;
  int offset = 0;

  // Instance of model classes
  MakeModel makeModel = MakeModel();
  CarModelsModel carModel = CarModelsModel();
  ColorModel colorModel = ColorModel();
  FuelTypeModel fuelTypeModel = FuelTypeModel();
  BodyModel bodyModel = BodyModel();
  TransmissionModel transmissionModel = TransmissionModel();

  // instance of repository class

  ApiRepo apiRepo = ApiRepo();

  // Function use to to set loading true or false and notify class

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Function use to to set model loading true or false and notify class
  setModelLoading(bool value) {
    isModelLoading = value;
    notifyListeners();
  }

  // ===========================================================================
  // API CALLING

  // GET MAKE API
  // Check internet is a function which get runtime internet status
  // if internet status is true then we will call api
  // if status false then we will move to connection class to show message

  getMake(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isLoading variable true to show loader
        setLoading(true);

        debugPrint(" get Make  ==========================>>>");

        try {
          // calling get method of the repository class to call api
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getMakeUrl, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });

          // store response data in responseBody variable
          final responseBody = response.data;
          debugPrint("Make response body ===============>>> $responseBody");

          // Store response in model class
          makeModel = MakeModel.fromJson(responseBody);

          //to set isLoading variable false to hide loader
          setLoading(false);
        } catch (e) {
          // if we will get any error then set isLoading variable false to hide loader
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // GET CAR MODEL
  getModel(BuildContext context, String screen, id) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isModelLoading variable true to show loader
        setModelLoading(true);

        debugPrint(" get Car Model  ==========================>>>");

        try {
          // calling get method of the repository class to call api

          final url = ApiUrl.getModelUrl + id.toString();
          Response response = await apiRepo.getData(context, screen, url, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });

          // store response data in responseBody variable
          final responseBody = response.data;
          debugPrint(
              " Car Model response body ===============>>> $responseBody");

          // Store response in model class
          carModel = CarModelsModel.fromJson(responseBody);
          //to set isLoading variable false to hide loader
          setModelLoading(false);
        } catch (e) {
          // if we will get any error then set isModelLoading variable false to hide loader

          setModelLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // GET TRANSMISSION
  getTransmission(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isLoading variable true to show loader
        setLoading(true);

        debugPrint(" get transmission  ==========================>>>");

        try {
          // calling get method of the repository class to call api
          Response response = await apiRepo
              .getData(context, screen, ApiUrl.getTransmissionUrl, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });
          // store response data in responseBody variable
          final responseBody = response.data;

          debugPrint(
              " Car transmission response body ===============>>> $responseBody");

          // Store response in model class
          transmissionModel = TransmissionModel.fromJson(responseBody);

          //to set isLoading variable false to hide loader
          setLoading(false);
        } catch (e) {
          // if we will get any error then set isLoading variable false to hide loader
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // GET COLOR
  getColor(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isLoading variable true to show loader
        setLoading(true);

        debugPrint(" get color  ==========================>>>");

        try {
          // calling get method of the repository class to call api
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getColorUrl, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });

          // store response data in responseBody variable
          final responseBody = response.data;
          debugPrint(
              " Car color response body ===============>>> $responseBody");

          // Store response in model class
          colorModel = ColorModel.fromJson(responseBody);

          //to set isLoading variable false to hide loader
          setLoading(false);
        } catch (e) {
          // if we will get any error then set isLoading variable false to hide loader
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // GET BODY TYPE
  getBodyType(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isLoading variable true to show loader
        setLoading(true);

        debugPrint(" get Body  ==========================>>>");

        try {
          // calling get method of the repository class to call api
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getBodyTypeUrl, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });
          // store response data in responseBody variable
          final responseBody = response.data;
          debugPrint("Car Body response body ===============>>> $responseBody");

          // Store response in model class
          bodyModel = BodyModel.fromJson(responseBody);

          //to set isLoading variable false to hide loader
          setLoading(false);
        } catch (e) {
          // if we will get any error then set isLoading variable false to hide loader
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }

  // GET FUEL TYPE
  getFuelType(BuildContext context, String screen) async {
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        //to set isLoading variable true to show loader
        setLoading(true);

        debugPrint(" get Fuel type  ==========================>>>");

        try {
          // calling get method of the repository class to call api
          Response response =
              await apiRepo.getData(context, screen, ApiUrl.getFuelTypeUrl, {
            "limit": -1,
            "offset": 0,
            "order": "desc",
          });

          // store response data in responseBody variable
          final responseBody = response.data;
          debugPrint(
              "Fuel type response body ===============>>> $responseBody");

          // Store response in model class
          fuelTypeModel = FuelTypeModel.fromJson(responseBody);

          //to set isLoading variable false to hide loader
          setLoading(false);
        } catch (e) {
          // if we will get any error then set isLoading variable false to hide loader
          setLoading(false);
        }

        notifyListeners();
      }
    });
  }
}
