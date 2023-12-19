import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/view/screens/authentication_screen/forget_password_screen.dart';
import 'package:caroogle/view/screens/car_detail_screen/car_detail_screen.dart';
import 'package:caroogle/view/screens/favourite_screen/favourite_screen.dart';
import 'package:caroogle/view/screens/home_screen/home_screen.dart';
import 'package:caroogle/view/screens/inventory_screen/inventory_add_new_screen.dart';
import 'package:caroogle/view/screens/inventory_screen/inventory_car_detail_screen.dart';
import 'package:caroogle/view/screens/inventory_screen/inventory_screen.dart';
import 'package:caroogle/view/screens/subscription_screen/change_plan_screen.dart';
import 'package:caroogle/view/screens/preferences_screen/preferences_csv_mapping_screen.dart';
import 'package:caroogle/view/screens/preferences_screen/preferences_add_data_screen.dart';
import 'package:caroogle/view/screens/preferences_screen/preferences_screen.dart';
import 'package:caroogle/view/screens/profile_screen/edit_profile_screen.dart';
import 'package:caroogle/view/screens/profile_screen/user_section_profile_screen.dart';
import 'package:caroogle/view/screens/search_filer_screen/search_filter_screen.dart';
import 'package:caroogle/view/screens/subscription_screen/subscription_screen.dart';
import 'package:caroogle/view/screens/tracked_car_screen/tracked_car_screen.dart';
import 'package:caroogle/view/screens/trigger_screen/set_trigger_screen.dart';
import 'package:caroogle/view/screens/trigger_screen/trigger_count_screen.dart';
import 'package:caroogle/view/screens/trigger_screen/trigger_screen.dart';
import 'package:flutter/material.dart';

import '../view/screens/authentication_screen/signin_screen.dart';
import '../view/screens/authentication_screen/signup_screen.dart';
import '../view/screens/david_recommendation_screen/david_recommendataion_screen.dart';
import '../view/screens/global_search_screen/global_search_screen.dart';
import '../view/screens/inventory_screen/inventory_csv_mapping_screen.dart';
import '../view/screens/notification_screen/notification_screen.dart';
import '../view/screens/packege_plan_screen/add_card_screen.dart';
import '../view/screens/packege_plan_screen/choose_plan_screen.dart';
import '../view/screens/packege_plan_screen/thankyou_screen.dart';
import '../view/screens/splash_screen/splash_screen.dart';
import '../view/screens/subscription_screen/billing_history_screen.dart';
import '../view/widgets/connection.dart';

// A class in which all screen routes is declared
class RouterHelper {
  //defines which routes of the class

  static const initial = "/";
  static const signInScreen = "/signInScreen";
  static const signUpScreen = "/signUpScreen";
  static const choosePlanScreen = "/choosePlanScreen";
  static const addCardScreen = "/addCardScreen";
  static const thankYouScreen = "/thankYouScreen";
  static const homeScreen = "/homeScreen";
  static const carDetailScreen = "/carDetailScreen";
  static const trackedCarScreen = "/trackedCarScreen";
  static const triggerScreen = "/triggerScreen";
  static const setTriggerScreen = "/setTriggerScreen";
  static const notificationScreen = "/notificationScreen";
  static const searchFilterScreen = "/searchFilterScreen";
  static const userSectionProfileScreen = "/userSectionProfileScreen";
  static const editProfileScreen = "/editProfileScreen";
  static const favouriteScreen = "/favouriteScreen";
  static const subscriptionScreen = "/subscriptionScreen";
  static const billingHistoryScreen = "/billingHistoryScreen";
  static const changePlanScreen = "/changePlanScreen";
  static const preferencesScreen = "/preferencesScreen";
  static const preferencesAddDataScreen = "/preferencesAddDataScreen";
  static const inventoryScreen = "/inventoryScreen";
  static const inventoryAddNewScreen = "/inventoryAddNewScreen";
  static const inventoryCarDetailScreen = "/inventoryCarDetailScreen";
  static const triggerCountScreen = "/triggerCountScreen";
  static const csvMappingScreen = "/csvMappingScreen";
  static const inventoryCsvMappingScreen = "/inventoryCsvMappingScreen";
  static const noConnectionScreen = "/noConnectionScreen";
  static const forgetPasswordScreen = "/forgetPasswordScreen";
  static const davidRecommendationScreen = "/davidRecommendationScreen";
  static const globalSearchScreen = "/globalSearchScreen";

  // initialize all class
  static Map<String, Widget Function(BuildContext context)> routes = {
    initial: (context) => const SplashScreen(),
    signInScreen: (context) => SignInScreen(),
    signUpScreen: (context) => SignUpScreen(),
    forgetPasswordScreen: (context) => ForgetPasswordScreen(),
    choosePlanScreen: (context) => ChoosePlanScreen(),
    addCardScreen: (context) => AddCardScreen(),
    thankYouScreen: (context) => ThankYouScreen(),
    homeScreen: (context) => const HomeScreen(),
    davidRecommendationScreen: (context) => const DavidRecommendationScreen(),
    carDetailScreen: (context) => CarDetailScreen(),
    trackedCarScreen: (context) => const TrackedCarScreen(),
    triggerScreen: (context) => const TriggerScreen(),
    setTriggerScreen: (context) => const SetTriggerScreen(),
    notificationScreen: (context) => const NotificationScreen(),
    searchFilterScreen: (context) => const SearchFilterScreen(),
    userSectionProfileScreen: (context) => const UserSectionProfileScreen(),
    editProfileScreen: (context) => const EditProfileScreen(),
    favouriteScreen: (context) => const FavouriteScreen(),
    subscriptionScreen: (context) => const SubscriptionScreen(),
    billingHistoryScreen: (context) => const BillingHistoryScreen(),
    changePlanScreen: (context) => const ChangePlanScreen(),
    preferencesScreen: (context) => const PreferencesScreen(),
    preferencesAddDataScreen: (context) => PreferencesAddDataScreen(),
    inventoryScreen: (context) => const InventoryScreen(),
    inventoryAddNewScreen: (context) => const InventoryAddNewScreen(),
    inventoryCarDetailScreen: (context) => const InventoryCarDetailScreen(),
    triggerCountScreen: (context) => const TriggerCountScreen(),
    csvMappingScreen: (context) => const PreferencesCSVMappingScreen(),
    inventoryCsvMappingScreen: (context) => const InventoryCSVMappingScreen(),
    noConnectionScreen: (context) => const NoConnection(),
    globalSearchScreen: (context) => const GlobalSearchScreen(),
  };
}
