import 'dart:io';

import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/view/screens/search_filer_screen/components/price_change_button_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../helper/routes_helper.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/string.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_floating_action_button.dart';
import '../../widgets/custom_sizedbox.dart';
import '../../widgets/pictured_app_bar.dart';
import '../../widgets/shimmer/shimmer_grid.dart';
import 'components/global_data_list.dart';
import 'components/global_title_list.dart';
import 'components/price_button_list.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({Key? key}) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  @override
  void initState() {
    super.initState();
    callingApi(0);
  }

  callingApi(int isPagination) {
    debugPrint("isPagination : $isPagination");
    // if value = 0 its mean first time we are getting data
    // if value = 1 its mean we are doing pagination with increment pages
    // if value = 2 its mean we are doing pagination with decrement pages

    Future.delayed(Duration.zero).then((value) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);

      navigationProvider.setNavigationIndex(context, 2);

      final globalSearchProvider =
          Provider.of<GlobalScreenProvider>(context, listen: false);

      globalSearchProvider.setLoading(true);

      profileProvider.getProfile(context, RouterHelper.globalSearchScreen);

      globalSearchProvider
          .getSource(context, RouterHelper.globalSearchScreen)
          .then((value) {
        if (isPagination == 0 && globalSearchProvider.isFilter == false) {
          globalSearchProvider.clearFilter();
          globalSearchProvider.clearTitleIndex();
          globalSearchProvider.resetPriceTag();
          globalSearchProvider.clearOffset();
          globalSearchProvider.setIsSearching(false);
          globalSearchProvider.getGlobalSearchData(
              context, 0, RouterHelper.globalSearchScreen);
        }
      });
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final globalSearchProvider =
        Provider.of<GlobalScreenProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      globalSearchProvider.clearFilter();
      globalSearchProvider.clearOffset();
      globalSearchProvider.setIsSearching(false);
      globalSearchProvider.getGlobalSearchData(
          context, 0, RouterHelper.globalSearchScreen);
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
                  context: context, title: home, page: 8, isSearch: 1),
              body: Consumer<GlobalScreenProvider>(
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
                              GlobalTitleList(),
                              HeightSizedBox(context, 0.01),
                              const PriceButtonList(),
                              HeightSizedBox(context, 0.02),
                              const GlobalDataList(),
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
