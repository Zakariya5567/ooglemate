import 'dart:io';

import 'package:caroogle/providers/bottom_navigation_provider.dart';
import 'package:caroogle/providers/dropdown_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/preferences_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/home_screen/components/custom_toggle_button.dart';
import 'package:caroogle/view/screens/home_screen/components/data_list.dart';
import 'package:caroogle/view/screens/home_screen/components/home_title_list.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/custom_floating_action_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/profile_provider.dart';
import '../../widgets/pictured_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    callingApi(0);
  }

  callingApi(int isPagination) {
    debugPrint("isPagination : $isPagination");
    // if value = 0 its mean first time we are getting data
    // if value = 1 its mean we are doing pagination with increment pages
    //if value = 2 its mean we are doing pagination with decrement pages

    Future.delayed(Duration.zero).then((value) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);

      navigationProvider.setNavigationIndex(context, 0);

      final homeProvider =
          Provider.of<HomeScreenProvider>(context, listen: false);
      homeProvider.setLoading(true);

      final preferencesProvider =
          Provider.of<PreferencesProvider>(context, listen: false);
      if (preferencesProvider.allPreferencesModel.data == null) {
        preferencesProvider.getAllPreferences(
            context, 0, RouterHelper.homeScreen);
      }

      profileProvider.getProfile(context, RouterHelper.homeScreen);

      homeProvider.getSource(context, RouterHelper.homeScreen).then((value) {
        if (isPagination == 0 && homeProvider.isFilter == false) {
          homeProvider.clearFilter();
          homeProvider.setIsSearching(false);
          if (homeProvider.toggleIndex == 0) {
            homeProvider.clearTitleIndex();
            homeProvider.clearOffset();
            homeProvider.getRecommended(context, 0, RouterHelper.homeScreen);
          } else if (homeProvider.toggleIndex == 1) {
            homeProvider.clearTitleIndex();
            homeProvider.clearOffset();
            homeProvider.getAllMatches(context, 0, RouterHelper.homeScreen);
          }
        }
      });
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here

    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      homeProvider.clearFilter();
      homeProvider.setIsSearching(false);
      if (homeProvider.toggleIndex == 0) {
        homeProvider.clearOffset();
        homeProvider.getRecommended(context, 0, RouterHelper.homeScreen);
      } else if (homeProvider.toggleIndex == 1) {
        homeProvider.clearOffset();
        homeProvider.getAllMatches(context, 0, RouterHelper.homeScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
          bottom: Platform.isAndroid ? true : false,
          top: Platform.isAndroid ? true : false,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: primaryWhite,
              appBar: picturedAppBar(
                  context: context, title: home, page: 1, isSearch: 1),
              body: Consumer<HomeScreenProvider>(
                  builder: (context, controller, child) {
                return controller.isLoading == true ||
                        controller.sourceModel.data == null
                    ? ShimmerGrid(pagination: 0)
                    : RefreshIndicator(
                        onRefresh: onRefresh,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeTitleList(),
                              HeightSizedBox(context, 0.01),
                              const CustomToggleButton(),
                              HeightSizedBox(context, 0.01),
                              const DataList(),
                            ],
                          ),
                        ),
                      );
              }),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: !isKeyboard
                  ? const CustomFloatingActionButton()
                  : const SizedBox(),
              bottomNavigationBar: const BottomNavigation())),
    );
  }
}
