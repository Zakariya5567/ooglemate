import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/providers/tracked_provider.dart';
import 'package:caroogle/providers/trigger_provider.dart';
import 'package:caroogle/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository/api_repo.dart';
import '../helper/connection_checker.dart';
import 'dropdown_provider.dart';

class SearchFilterProvider extends ChangeNotifier {
  //isSelected variable declared for make and model validation
  //is isMakeSelected is false then we will show show validation message \

  bool? isMakeSelected;

  // Search page is used for page id (its mean from which screen user come to
  // filter screen and then we will move to the same screen
  int? searchPage;

  // isLoading variable is declared for loading state of the API
  // When we call Api we are setting loader or shimmer
  // isLoading == true its means we will show loader
  // if loading false we will finish loader and show UI

  bool? isLoading;

  // LIST OF SELECTED ITEM

  // type is used for source
  // make id is the id of make selected item
  // fuel id is the id of fuel selected item
  // badge is the keyword you enter in badge text-field
  // body id is the id of body selected item
  // transmission id is the id of transmission selected item
  // color id is the id of color selected item

  String type = "all";

  int? makeId;
  int? modelId;
  int? fuelId;
  String? badge;
  int? bodyId;
  int? transmissionId;
  int? colorId;

  // Search text is the keyword of the  search text-field which is used on all search screen appbar

  String? searchText;

  // RANGE SLIDER
  //  min year  and max year is the selected value of the year slider
  //  min price and max price is the selected value of the price slider
  //  min km  and max km is the selected value of Km driven   slider

  int? minYear;
  int? maxYear;
  int? minPrice;
  int? maxPrice;
  int? minKm;
  int? maxKm;

  // INITIAL VALUE OF THE RANGE SLIDER
  //  minimum year  and maximum year is the  initial value of the year slider
  //  minimum price and maximum price is the  initial value of the price slider
  //  minimum km  and maximum km is the  initial value of the km driven slider

  double minimumKm = 0;
  double maximumKm = 64371000;

  double minimumPrice = 0;
  double maximumPrice = 2000000000;

  double minimumYear = 1982;
  double maximumYear = DateTime.now().year.toDouble();

  // RANGE INITIALIZATION
  RangeValues kmValues = const RangeValues(0, 64371000);

  RangeValues priceValues = const RangeValues(0, 2000000000);

  RangeValues makeYearValues =
      RangeValues(1982, DateTime.now().year.toDouble());

  // AUTO TEXT FIELD
  // Text field which is used in auto text field widget of the filter screen
  TextEditingController carMakeController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  // TextField
  // Search controller is the controller of the search text-field of the app bar
  // which are used in app bar of the screens
  // car badge controller is the controller of the badge text field

  TextEditingController searchController = TextEditingController();

  TextEditingController carBadgeController = TextEditingController();

  // Repository class instance
  // All Methods of APIs is In Repository class
  ApiRepo apiRepo = ApiRepo();

  // TO set the search page (Screen id)
  setSearchPage(int page) {
    searchPage = page;
    notifyListeners();
  }

  // To set the search history which is used in search history list
  setHistorySearch(String value) {
    searchController.text = value;
    notifyListeners();
  }

  // Methods to set the state of loading
  // Assigning values to isLoading variable
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // If the user select  value on slider the we will set it to the related variable
  // we will differentiate the value according to range slider title
  setRangeValues(
      {required String rangeTitle, required RangeValues rangeValues}) {
    if (rangeTitle == km) {
      kmValues = rangeValues;
    } else if (rangeTitle == priceRange) {
      priceValues = rangeValues;
    } else if (rangeTitle == makeYear) {
      makeYearValues = rangeValues;
    }

    notifyListeners();
  }

  // To clear the data of the dropdown and text-field of the filter screen
  // isSearch is to confirm that the user is searching or get result from the filter screen
  // isSearch 0 -> user from filter screen and 1 for searching
  clearDropdown(int isSearch) {
    makeId = null;
    modelId = null;
    fuelId = null;
    badge = null;
    bodyId = null;
    transmissionId = null;
    colorId = null;
    searchPage = isSearch == 0 ? null : searchPage;
    searchController.clear();
    carBadgeController.clear();

    minYear = null;
    maxYear = null;
    minPrice = null;
    maxPrice = null;
    minKm = null;
    maxKm = null;

    notifyListeners();
  }

  // To set the value of the text-field to its initialized variable

  setTextField() {
    badge = carBadgeController.text;
    searchText = searchController.text;
    notifyListeners();
  }

  // To set value to selected variable

  setMakeSelected(bool value) {
    isMakeSelected = value;
    notifyListeners();
  }

  // FOR DROP DOWN VALIDATION

  setDropdownValueValidation(BuildContext context, int dropdownId) {
    // Dropdown id the to identify which dropdown is to validate
    // DROPDOWN ID 1 FOR MAKE MODEL
    // DROPDOWN ID 2 FOR CAR  MODEL
    // DROPDOWN ID 3 FOR TRANSMISSION MODEL
    // DROPDOWN ID 4 FOR FUEL TYPE MODEL
    // DROPDOWN ID 5 FOR BODY TYPE MODEL
    // DROPDOWN ID 6 FOR COLOR MODEL

    // Instance of the dropdown provider class
    final dropdownProvider =
        Provider.of<DropdownProvider>(context, listen: false);

    // in if condition fist we are looking for id , id the id matched then
    // we are looking for the search item in the dropdown list
    // if matched the the remove the existing id and the assign the new one
    if (dropdownId == 1) {
      for (var element in dropdownProvider.makeModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            carMakeController.text.toLowerCase()) {
          makeId = null;
          makeId = element.id;
          // To set the isMakeSelected value false ( its mean  make is selected
          // now you can select model
          isMakeSelected = false;

          //when make will select then we will call model according to make id
          callModelApi(context, element.id!);
          break;
        } else {
          // if not matched we will set make id to null
          makeId = null;
        }
      }
    } else if (dropdownId == 2) {
      for (var element in dropdownProvider.carModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            carModelController.text.toLowerCase()) {
          modelId = null;
          modelId = element.id;
          isMakeSelected = false;
          break;
        } else {
          modelId = null;
        }
      }
    } else if (dropdownId == 3) {
      for (var element in dropdownProvider.transmissionModel.data!.rows!) {
        if (element.name!.toLowerCase() ==
            transmissionController.text.toLowerCase()) {
          transmissionId = null;
          transmissionId = element.id;
          break;
        } else {
          transmissionId = null;
        }
      }
    } else if (dropdownId == 4) {
      for (var element in dropdownProvider.fuelTypeModel.data!.rows!) {
        if (element.name!.toLowerCase() == fuelController.text.toLowerCase()) {
          fuelId = null;
          fuelId = element.id;
          break;
        } else {
          fuelId = null;
        }
      }
    } else if (dropdownId == 5) {
      for (var element in dropdownProvider.bodyModel.data!.rows!) {
        if (element.name!.toLowerCase() == bodyController.text.toLowerCase()) {
          bodyId = null;
          bodyId = element.id;
          break;
        } else {
          bodyId = null;
        }
      }
    } else if (dropdownId == 6) {
      for (var element in dropdownProvider.colorModel.data!.rows!) {
        if (element.name!.toLowerCase() == bodyController.text.toLowerCase()) {
          colorId = null;
          colorId = element.id;
          break;
        } else {
          colorId = null;
        }
      }
    }
    notifyListeners();
  }

  // Set dropdown value which which we will send to in the API

  setDropDownValue({
    required BuildContext context,
    required String title,
    required int id,
  }) {
    // Title id to identify which dropdown is to value is to set in the
    // related variable

    // if the title will matched then the value will be assign

    if (title == carMake) {
      makeId = id;
      isMakeSelected = false;
      //when make will select then we will call model according to make id
      callModelApi(context, id);
      debugPrint("make id : $makeId");
    } else if (title == carModel) {
      modelId = id;
      debugPrint("model id : $modelId");
    } else if (title == fuelType) {
      fuelId = id;
      debugPrint("fuel id : $fuelId");
    } else if (title == transmission) {
      transmissionId = id;
      debugPrint("transmission id : $transmissionId");
    } else if (title == bodyType) {
      bodyId = id;
      debugPrint("body id : $bodyId");
    } else if (title == colours) {
      colorId = id;
      debugPrint("body id : $colorId");
    }
    notifyListeners();
  }

  // To Set Range of the slider and assign it to to value
  setMaxMinRange(int isSearch) {
    // 0 for search
    // 1 for filter
    if (isSearch == 0) {
      // if searching then we will set all the range will to null
      minYear = null;
      maxYear = null;
      minPrice = null;
      maxPrice = null;
      minKm = null;
      maxKm = null;
    } else {
      // getting value from the Range slider and assign it to variable
      minYear = makeYearValues.start.toInt();
      maxYear = makeYearValues.end.toInt();
      minPrice = priceValues.start.toInt();
      maxPrice = priceValues.end.toInt();
      minKm = kmValues.start.toInt();
      maxKm = kmValues.end.toInt();
    }
    notifyListeners();
  }

  //====================================================================
  // API CALLING

  // Calling api to get the list of the model according to selected make
  callModelApi(BuildContext context, int id) {
    Future.delayed(Duration.zero, () {
      final dropdownProvider =
          Provider.of<DropdownProvider>(context, listen: false);
      dropdownProvider.getModel(
          context, RouterHelper.inventoryAddNewScreen, id);
    });
  }

  // FILTER
  // filter for all screen is same and same methodology to get the data from the api
  // This method is used to search by filter from the navigated screen
  getSearchFilter(
      BuildContext context, int screenId, String screen, bool isSearch) async {
    // isSearch true for searching  and false not searching
    // isSearch true its mean the user are searching from text-field
    debugPrint("page is : $screenId");

    // Screen id is to identify the user come from which screen
    // 1 for home screen
    // 2 for preferences screen
    // 3 for inventory screen
    // 4 for track screen
    // 5 for trigger screen
    // 6 for trigger count scree
    // 7 david recommendation screen
    // 8 global search screen

    notifyListeners();
    // checking for internet
    return checkInternet(context, screen).then((value) async {
      if (value == true) {
        debugPrint(" Screen $screen  ==========================>>>");
        setLoading(true);
        debugPrint(" Search Filter  ==========================>>>");
        debugPrint(" IsSearch  ==========================>>> $isSearch");

        // isSearch true is used  the user is searching by keyword ,

        // if the screen id match then we call the api method of these screen

        if (screenId == 1) {
          // creating instance of the home screen provider
          final homeProvider =
              Provider.of<HomeScreenProvider>(context, listen: false);

          // calling the method of the home screen and set the value to its initialized variable
          homeProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );
          // to check for the user have selected recommended or all matches
          // then we will call the method and get data from the api

          if (homeProvider.toggleIndex == 0) {
            await homeProvider.getRecommended(
                context, 0, RouterHelper.searchFilterScreen);
          } else {
            await homeProvider.getAllMatches(
                context, 0, RouterHelper.searchFilterScreen);
          }
          setLoading(false);
        } else if (screenId == 2) {
          // creating instance of the preferences provider
          final prefProvider =
              Provider.of<PreferencesProvider>(context, listen: false);

          // calling the method of the preferences screen and set the value to its initialized variable
          prefProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );

          // call the method and get data from the api
          prefProvider.getAllPreferences(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 3) {
          // creating instance of the InventoryProvider
          final inventoryProvider =
              Provider.of<InventoryProvider>(context, listen: false);

          // calling the method of the inventory screen and set the value to its initialized variable
          inventoryProvider.setFilter(
            newFilter: true,
            newType: type,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );

          // calling the method and get data from the api

          inventoryProvider.getAllInventories(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 4) {
          // creating instance of the trackedProvider
          final trackedProvider =
              Provider.of<TrackedProvider>(context, listen: false);

          // calling the method of the tracked screen and set the value to its initialized variable

          trackedProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );
          //call the method and get data from the api
          trackedProvider.getAllTrack(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 5) {
          // creating instance of the triggerProvider
          final triggerProvider =
              Provider.of<TriggerProvider>(context, listen: false);

          // calling the method of the trigger screen and set the value to its initialized variable

          triggerProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );
          // calling the method and get data from the api
          triggerProvider.getAllTrigger(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 6) {
          // creating instance of the TriggerProvider
          final triggerProvider =
              Provider.of<TriggerProvider>(context, listen: false);

          // calling the method of the trigger count screen and set the value to its initialized variable

          triggerProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );
          // calling the method and get data from the api
          triggerProvider.getCarInTrigger(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 7) {
          // creating instance of the DavidRecommendationScreenProvider
          final davidProvider = Provider.of<DavidRecommendationScreenProvider>(
              context,
              listen: false);

          // calling the method of the david recommendation screen and set the value to its initialized variable

          davidProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );
          //call the method and get data from the api
          davidProvider.getDavidRecommended(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        } else if (screenId == 8) {
          // creating instance of the globalSearchProvider
          final globalSearchProvider =
              Provider.of<GlobalScreenProvider>(context, listen: false);

          // calling the method of the home screen and set the value to its initialized variable
          globalSearchProvider.setFilter(
            newFilter: true,
            newText: isSearch == true ? searchText : null,
            newMakeId: makeId,
            newModelId: modelId,
            newFuelTypeId: fuelId,
            newBodyTypeId: bodyId,
            newBadge: badge,
            newExteriorColorId: colorId,
            newTransmissionId: transmissionId,
            newPriceMin: minPrice,
            newPriceMax: maxPrice,
            newKmMin: minKm,
            newKmMax: maxKm,
            newYearMin: minYear,
            newYearMax: maxYear,
            newOffset: 0,
            newIsSearching: isSearch == true ? true : false,
          );

          // calling the method of the home screen and set the value to its initialized variable
          globalSearchProvider.getGlobalSearchData(
              context, 0, RouterHelper.searchFilterScreen);
          setLoading(false);
        }
      }
    });
  }
}
