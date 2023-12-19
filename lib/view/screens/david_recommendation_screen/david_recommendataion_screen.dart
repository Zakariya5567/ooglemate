import 'dart:io';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/bottom_navigation.dart';
import 'package:caroogle/view/widgets/custom_floating_action_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_grid.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../providers/david_recommendataion_screen_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../widgets/pictured_app_bar.dart';
import 'components/david_data_list.dart';
import 'components/david_title_list.dart';

class DavidRecommendationScreen extends StatefulWidget {
  const DavidRecommendationScreen({Key? key}) : super(key: key);

  @override
  State<DavidRecommendationScreen> createState() =>
      _DavidRecommendationScreenState();
}

class _DavidRecommendationScreenState extends State<DavidRecommendationScreen> {
  @override
  void initState() {
    super.initState();
    callingApi(0);
    // 0 mean we are not using pagination
  }

  callingApi(int isPagination) {
    debugPrint("isPagination : $isPagination");
    // if value = 0 its mean first time we are getting data
    // if value = 1 its mean we are doing pagination with increment pages
    //if value = 2 its mean we are doing pagination with decrement pages

    Future.delayed(Duration.zero).then((value) {
      // instance of the profile provider class
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      // instance of the bottom navigation provider class
      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);

      // To set the index of the bottom navigation to 3
      navigationProvider.setNavigationIndex(context, 3);

      // instance of the David Recommendation Screen Provider
      final davidProvider = Provider.of<DavidRecommendationScreenProvider>(
          context,
          listen: false);

      // set loading true to display shimmer
      davidProvider.setLoading(true);

      // calling get profile api
      profileProvider.getProfile(
          context, RouterHelper.davidRecommendationScreen);

      // calling get source api
      davidProvider
          .getSource(context, RouterHelper.davidRecommendationScreen)
          .then((value) {
        // checking for if we are not doing pagination and not coming from filter screen
        if (isPagination == 0 && davidProvider.isFilter == false) {
          // clear filter data if present
          davidProvider.clearFilter();

          // set the source index to default one
          davidProvider.clearTitleIndex();

          // clear the offset of the pagination
          davidProvider.clearOffset();

          // Set searching false because we are not searching
          davidProvider.setIsSearching(false);

          // calling david recommendation api
          davidProvider.getDavidRecommended(
              context, 0, RouterHelper.davidRecommendationScreen);
        }
      });
    });
  }

  // On Page refresh
  Future<void> onRefresh() async {
    // Your refresh logic goes here

    // instance of the David Recommendation Screen Provider
    final davidProvider =
        Provider.of<DavidRecommendationScreenProvider>(context, listen: false);

    // same logic as above
    await Future.delayed(Duration.zero, () {
      davidProvider.clearFilter();
      davidProvider.clearOffset();
      davidProvider.setIsSearching(false);
      davidProvider.getDavidRecommended(
          context, 0, RouterHelper.davidRecommendationScreen);
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
                  context: context,
                  title: david_recommendation,
                  page: 7,
                  isSearch: 1),
              body: Consumer<DavidRecommendationScreenProvider>(
                  builder: (context, controller, child) {
                // check if loading is true then we will show shimmer
                // api response data is null then we will show no data found

                return controller.isLoading == true ||
                        controller.sourceModel.data == null
                    ? ShimmerGrid(pagination: 0)
                    : RefreshIndicator(
                        onRefresh: onRefresh,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Source list
                                DavidTitleList(),
                                HeightSizedBox(context, 0.01),

                                // car cards list
                                const DavidDataList(),
                              ],
                            )),
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
