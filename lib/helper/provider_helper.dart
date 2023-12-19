import 'package:caroogle/providers/bottom_navigation_provider.dart';
import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/favourite_provider.dart';
import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:caroogle/providers/notification_provider.dart';
import 'package:caroogle/providers/preferences_add_data_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/providers/search_filter_provider.dart';
import 'package:caroogle/providers/tracked_provider.dart';
import 'package:caroogle/providers/trigger_provider.dart';
import 'package:provider/provider.dart';
import '../providers/dropdown_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/authentication_provider.dart';
import '../providers/inventory_add_new_provider.dart';
import '../providers/inventory_car_detail_provider.dart';
import '../providers/set_trigger_provider.dart';

// Define all  providers in a single list,
// To manage and provide access to providers across different parts of the app
class ProviderHelper {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<BottomNavigationProvider>(
        create: (context) => BottomNavigationProvider()),
    ChangeNotifierProvider<HomeScreenProvider>(
        create: (context) => HomeScreenProvider()),
    ChangeNotifierProvider<CarDetailProvider>(
        create: (context) => CarDetailProvider()),
    ChangeNotifierProvider<InventoryProvider>(
        create: (context) => InventoryProvider()),
    ChangeNotifierProvider<InventoryCarDetailProvider>(
        create: (context) => InventoryCarDetailProvider()),
    ChangeNotifierProvider<InventoryAddNewProvider>(
        create: (context) => InventoryAddNewProvider()),
    ChangeNotifierProvider<PreferencesProvider>(
        create: (context) => PreferencesProvider()),
    ChangeNotifierProvider<ProfileProvider>(
        create: (context) => ProfileProvider()),
    ChangeNotifierProvider<TrackedProvider>(
        create: (context) => TrackedProvider()),
    ChangeNotifierProvider<TriggerProvider>(
        create: (context) => TriggerProvider()),
    ChangeNotifierProvider<SearchFilterProvider>(
        create: (context) => SearchFilterProvider()),
    ChangeNotifierProvider<SetTriggerProvider>(
        create: (context) => SetTriggerProvider()),
    ChangeNotifierProvider<PreferencesAddDataProvider>(
        create: (context) => PreferencesAddDataProvider()),
    ChangeNotifierProvider<NotificationProvider>(
        create: (context) => NotificationProvider()),
    ChangeNotifierProvider<FavouriteProvider>(
        create: (context) => FavouriteProvider()),
    ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
    ChangeNotifierProvider<SubscriptionProvider>(
        create: (context) => SubscriptionProvider()),
    ChangeNotifierProvider<DropdownProvider>(
        create: (context) => DropdownProvider()),
    ChangeNotifierProvider<DavidRecommendationScreenProvider>(
        create: (context) => DavidRecommendationScreenProvider()),
    ChangeNotifierProvider<GlobalScreenProvider>(
        create: (context) => GlobalScreenProvider()),
  ];
}
