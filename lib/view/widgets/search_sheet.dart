import 'dart:async';
import 'package:caroogle/data/db/search_history.dart';
import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/global_search_provider.dart';
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../data/db/hive_boxes.dart';
import '../../helper/debouncer.dart';
import '../../providers/home_screen_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/search_filter_provider.dart';
import '../../providers/tracked_provider.dart';
import '../../providers/trigger_provider.dart';
import '../../utils/api_url.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';
import 'custom_sizedbox.dart';

// 1 for home screen
// 2 for preferences screen
// 3 for inventory screen
// 4 for track screen
// 5 for trigger screen
// 6 for trigger count scree
// 7 david recommendation screen
// 8 global search screen

searchSheet(BuildContext context) {
  return showGeneralDialog(
    barrierLabel: "search",
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 100),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Material(
            elevation: 5,
            child: Consumer<SearchFilterProvider>(
                builder: (context, controller, child) {
              return Container(
                width: displayWidth(context, 1),
                decoration: const BoxDecoration(
                  color: primaryWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        color: primaryWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Consumer<ProfileProvider>(builder:
                                      (context, profileProvider, child) {
                                    return profileProvider
                                                .getProfileModel.data ==
                                            null
                                        ? Container(
                                            height:
                                                displayWidth(context, 0.075),
                                            width: displayWidth(context, 0.075),
                                            decoration: BoxDecoration(
                                              color: primaryGrey,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: veryLightGrey),
                                            ))
                                        : profileProvider.getProfileModel.data!
                                                    .photo ==
                                                null
                                            ? Container(
                                                height: displayWidth(
                                                    context, 0.075),
                                                width: displayWidth(
                                                    context, 0.075),
                                                decoration: BoxDecoration(
                                                  color: primaryGrey,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: veryLightGrey),
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: primaryWhite,
                                                  size: displayWidth(
                                                      context, 0.04),
                                                ),
                                              )
                                            : Container(
                                                height: displayWidth(
                                                    context, 0.075),
                                                width: displayWidth(
                                                    context, 0.075),
                                                decoration: BoxDecoration(
                                                    color: primaryGrey,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: veryLightGrey),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          "${ApiUrl.baseUrl}${profileProvider.getProfileModel.data!.photo!}",
                                                        ))),
                                              );
                                  }),
                                ),
                                WidthSizedBox(context, 0.01),
                                SizedBox(
                                  // height: 50,
                                  width: displayWidth(context, 0.55),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: controller.searchController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(fontSize: 14),
                                    obscureText: false,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      // check for search text field is not empty

                                      if (controller.searchController.text
                                          .trim()
                                          .isNotEmpty) {
                                        Future.delayed(Duration.zero, () async {
                                          // dismiss the sheet
                                          Navigator.of(context).pop();

                                          // store history in local db "hive"
                                          // to store search text and date time
                                          final history = SearchHistory(
                                              text: controller
                                                  .searchController.text
                                                  .trim(),
                                              date: DateTime.now());

                                          // instance of the hive db
                                          // Boxes is a local db
                                          final box = Boxes.getSearchHistory();

                                          // set text field text in controller
                                          controller.setTextField();

                                          // calling api to search data according to keyword
                                          controller.getSearchFilter(
                                              context,
                                              controller.searchPage!,
                                              RouterHelper.searchFilterScreen,
                                              true);

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 1 for home screen
                                          if (controller.searchPage == 1) {
                                            // instance of the home provider

                                            final homeProvider =
                                                Provider.of<HomeScreenProvider>(
                                                    context,
                                                    listen: false);

                                            // check the user have selected recommended or all matches
                                            // and also check for api response

                                            if (homeProvider.recommendationModel
                                                        .error ==
                                                    false &&
                                                homeProvider.toggleIndex == 0) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }

                                            // check the user have selected recommended or all matches
                                            // and also check for api response

                                            if (homeProvider.allMatchesModel
                                                        .error ==
                                                    false &&
                                                homeProvider.toggleIndex == 1) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 2 for preference screen

                                          if (controller.searchPage == 2) {
                                            // instance of the preference provider

                                            final prefProvider = Provider.of<
                                                    PreferencesProvider>(
                                                context,
                                                listen: false);

                                            // check for api response

                                            if (prefProvider.allPreferencesModel
                                                    .error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one

                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 3 for inventory screen

                                          if (controller.searchPage == 3) {
                                            // instance of the preference provider

                                            final inventoryProvider =
                                                Provider.of<InventoryProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (inventoryProvider
                                                    .inventoryModel.error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 4 for tracked screen

                                          if (controller.searchPage == 4) {
                                            // instance of the tracked provider
                                            final trackedProvider =
                                                Provider.of<TrackedProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (trackedProvider
                                                    .allTrackedCarModel.error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 5 for Trigger screen

                                          if (controller.searchPage == 5) {
                                            // instance of the Trigger provider
                                            final triggerProvider =
                                                Provider.of<TriggerProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (triggerProvider
                                                    .allTriggerModel.error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one

                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                if (history.text.isNotEmpty) {
                                                  // add data to the list
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 6 for Trigger count screen

                                          if (controller.searchPage == 6) {
                                            // instance of the Trigger provider
                                            final triggerProvider =
                                                Provider.of<TriggerProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (triggerProvider
                                                    .carinTriggerModel.error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                // add data to the list
                                                if (history.text.isNotEmpty) {
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 7 for  david recommendation screen

                                          if (controller.searchPage == 7) {
                                            // instance of the david recommendation provider

                                            final davidProvider = Provider.of<
                                                    DavidRecommendationScreenProvider>(
                                                context,
                                                listen: false);

                                            // check for api response
                                            if (davidProvider
                                                    .davidRecommendationModel
                                                    .error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one
                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                // add data to the list
                                                if (history.text.isNotEmpty) {
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }

                                          // ====================================================================================

                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 8 for  global search screen

                                          if (controller.searchPage == 8) {
                                            // instance of the david recommendation provider
                                            final globalSearchProvider =
                                                Provider.of<
                                                        GlobalScreenProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response

                                            if (globalSearchProvider
                                                    .globalSearchModel.error ==
                                                false) {
                                              // if the search list length is greater then 20 we will remove last item from the list
                                              // if list less then 20 then we will add new item to the list

                                              if (box.length > 20) {
                                                // delete data from the list and add new one

                                                box
                                                    .deleteAt(
                                                        box.length - box.length)
                                                    .then((value) =>
                                                        box.add(history));
                                              } else {
                                                // add data to the list
                                                if (history.text.isNotEmpty) {
                                                  box.add(history);
                                                }
                                              }
                                            }
                                          }
                                        });
                                      }
                                    },
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(fontSize: 12),
                                      fillColor: primaryWhite,
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Search",
                                      hintStyle: textStyle(
                                          fontSize: 12,
                                          color: lightGrey,
                                          fontFamily: latoRegular),
                                      contentPadding: EdgeInsets.zero,
                                      border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomIconButton(
                                    icon: Images.iconFilter,
                                    color: primaryBlack,
                                    height: displayWidth(context, 0.045),
                                    width: displayWidth(context, 0.045),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed(
                                          RouterHelper.searchFilterScreen);
                                    }),
                                WidthSizedBox(context, 0.03),
                                CustomIconButton(
                                    icon: Images.iconCross,
                                    height: displayWidth(context, 0.045),
                                    width: displayWidth(context, 0.045),
                                    color: primaryBlack,
                                    onTap: () {
                                      // 1 mean its searching section
                                      controller.clearDropdown(1);

                                      Navigator.of(context).pop();

                                      // checking for text field is not empty

                                      if (controller.searchController.text
                                          .trim()
                                          .isEmpty) {
                                        Future.delayed(Duration.zero, () async {
                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 1 for home screen

                                          if (controller.searchPage! == 1) {
                                            // instance of the home provider
                                            final homeProvider =
                                                Provider.of<HomeScreenProvider>(
                                                    context,
                                                    listen: false);

                                            // check the user have selected recommended or all matches
                                            // and also check for api response

                                            if (homeProvider.recommendationModel
                                                        .error ==
                                                    false &&
                                                homeProvider.toggleIndex == 0) {
                                              // calling recommended api
                                              homeProvider.getRecommended(
                                                  context,
                                                  0,
                                                  RouterHelper.homeScreen);
                                            }

                                            // check the user have selected recommended or all matches
                                            // and also check for api response

                                            if (homeProvider.allMatchesModel
                                                        .error ==
                                                    false &&
                                                homeProvider.toggleIndex == 1) {
                                              // calling all matches api
                                              homeProvider.getAllMatches(
                                                  context,
                                                  0,
                                                  RouterHelper.homeScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 2 for preference screen

                                          if (controller.searchPage! == 2) {
                                            // instance of the preference provider
                                            final prefProvider = Provider.of<
                                                    PreferencesProvider>(
                                                context,
                                                listen: false);

                                            // check for api response
                                            if (prefProvider.allPreferencesModel
                                                    .error ==
                                                false) {
                                              // calling all preferences api
                                              prefProvider.getAllPreferences(
                                                  context,
                                                  0,
                                                  RouterHelper
                                                      .preferencesScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 3 for inventory screen

                                          if (controller.searchPage! == 3) {
                                            // instance of the preference provider
                                            final inventoryProvider =
                                                Provider.of<InventoryProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (inventoryProvider
                                                    .inventoryModel.error ==
                                                false) {
                                              // calling inventory api
                                              inventoryProvider
                                                  .getAllInventories(
                                                      context,
                                                      0,
                                                      RouterHelper
                                                          .inventoryScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 4 for tracked screen

                                          if (controller.searchPage! == 4) {
                                            // instance of the tracked provider
                                            final trackedProvider =
                                                Provider.of<TrackedProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (trackedProvider
                                                    .allTrackedCarModel.error ==
                                                false) {
                                              // calling tracked api
                                              trackedProvider.getAllTrack(
                                                  context,
                                                  0,
                                                  RouterHelper
                                                      .trackedCarScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 5 for Trigger screen

                                          if (controller.searchPage! == 5) {
                                            // instance of the Trigger provider
                                            final triggerProvider =
                                                Provider.of<TriggerProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (triggerProvider
                                                    .allTriggerModel.error ==
                                                false) {
                                              // calling trigger api
                                              triggerProvider.getAllTrigger(
                                                  context,
                                                  0,
                                                  RouterHelper
                                                      .trackedCarScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 6 for Trigger count screen

                                          if (controller.searchPage! == 6) {
                                            // instance of the Trigger provider
                                            final triggerProvider =
                                                Provider.of<TriggerProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response

                                            if (triggerProvider
                                                    .carinTriggerModel.error ==
                                                false) {
                                              // calling trigger count screen api
                                              triggerProvider.getCarInTrigger(
                                                  context,
                                                  0,
                                                  RouterHelper
                                                      .triggerCountScreen);
                                            }
                                          }

                                          // ====================================================================================
                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 7 for  david recommendation screen

                                          if (controller.searchPage! == 7) {
                                            // instance of the david recommendation provider
                                            final davidProvider = Provider.of<
                                                    DavidRecommendationScreenProvider>(
                                                context,
                                                listen: false);

                                            // check for api response
                                            if (davidProvider
                                                    .davidRecommendationModel
                                                    .error ==
                                                false) {
                                              // calling david recommended api
                                              davidProvider.getDavidRecommended(
                                                  context,
                                                  0,
                                                  RouterHelper
                                                      .davidRecommendationScreen);
                                            }
                                          }

                                          // ====================================================================================

                                          // checking for screen
                                          // search page is basically id of the screen
                                          // 8 for  global search screen

                                          if (controller.searchPage! == 8) {
                                            // instance of the david recommendation provider
                                            final globalSearchProvider =
                                                Provider.of<
                                                        GlobalScreenProvider>(
                                                    context,
                                                    listen: false);

                                            // check for api response
                                            if (globalSearchProvider
                                                    .globalSearchModel.error ==
                                                false) {
                                              // set searching false
                                              globalSearchProvider
                                                  .setIsSearching(false);

                                              // clear all filters
                                              globalSearchProvider
                                                  .clearFilter();

                                              // calling global search api
                                              globalSearchProvider
                                                  .getGlobalSearchData(
                                                      context,
                                                      0,
                                                      RouterHelper
                                                          .globalSearchScreen);
                                            }
                                          }
                                        });
                                      }
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                      ValueListenableBuilder<Box<SearchHistory>>(
                          valueListenable:
                              Boxes.getSearchHistory().listenable(),
                          builder: (context, box, _) {
                            final search =
                                box.values.toList().cast<SearchHistory>();
                            return SizedBox(
                              height: search.isEmpty
                                  ? 10
                                  : displayHeight(context, 0.2),
                              child: ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: search.length,
                                  itemBuilder: (context, index) {
                                    final searchData = search[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // set history text in text field
                                              controller.searchController.text =
                                                  searchData.text;

                                              // calling api to get data
                                              controller.setHistorySearch(
                                                  searchData.text);
                                            },
                                            child: Text(
                                              searchData.text,
                                              textAlign: TextAlign.center,
                                              style: textStyle(
                                                  fontSize: 15,
                                                  color: primaryBlack,
                                                  fontFamily: latoRegular),
                                            ),
                                          ),
                                          CustomIconButton(
                                              icon: Images.iconCross,
                                              color: primaryBlack,
                                              height:
                                                  displayWidth(context, 0.035),
                                              width:
                                                  displayWidth(context, 0.035),
                                              onTap: () async {
                                                // delete item from the search history
                                                final box =
                                                    Boxes.getSearchHistory();
                                                box.delete(searchData.key);
                                              }),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
}
