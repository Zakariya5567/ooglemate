import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/bottom_navigation_provider.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  // Bottom navigation the the bottom navigation bar of the app

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
        builder: (context, controller, child) {
      return Container(
        height: displayHeight(context, 0.07),
        width: displayWidth(context, 1),
        decoration: BoxDecoration(
          color: primaryWhite,
          // border: const Border(top: BorderSide(color: veryLightGrey, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: displayWidth(context, 0.45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // home screen
                    GestureDetector(
                      onTap: () {
                        controller.setNavigationIndex(context, 0);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouterHelper.homeScreen, (route) => false);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(Images.iconRecommended),
                              size: displayWidth(context, 0.06),
                              color: controller.currentIndex == 0
                                  ? primaryBlue
                                  : lightGrey,
                            ),
                            Text(
                              recommended,
                              style: textStyle(
                                  fontSize: 10,
                                  color: controller.currentIndex == 0
                                      ? primaryBlue
                                      : lightGrey,
                                  fontFamily: latoRegular),
                            )
                          ],
                        ),
                      ),
                    ),

                    // preferences screen
                    GestureDetector(
                      onTap: () {
                        controller.setNavigationIndex(context, 1);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouterHelper.preferencesScreen, (route) => false);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(Images.iconPreferences),
                              size: displayWidth(context, 0.06),
                              color: controller.currentIndex == 1
                                  ? primaryBlue
                                  : lightGrey,
                            ),
                            Text(
                              preferences,
                              style: textStyle(
                                  fontSize: 10,
                                  color: controller.currentIndex == 1
                                      ? primaryBlue
                                      : lightGrey,
                                  fontFamily: latoRegular),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Icon -> global search screen
              GestureDetector(
                onTap: () {
                  controller.setNavigationIndex(context, 2);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RouterHelper.globalSearchScreen, (route) => false);
                },
                child: SizedBox(
                  child: Column(
                    children: [
                      ImageIcon(
                        const AssetImage(Images.iconPreferences),
                        color: controller.currentIndex == 2
                            ? primaryBlue
                            : lightGrey,
                        size: 0,
                      ),
                      Text(
                        '',
                        style: textStyle(
                            fontSize: 10,
                            color: controller.currentIndex == 2
                                ? primaryBlue
                                : lightGrey,
                            fontFamily: latoRegular),
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: displayWidth(context, 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // david recommendation screen
                    GestureDetector(
                      onTap: () {
                        controller.setNavigationIndex(context, 3);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouterHelper.davidRecommendationScreen,
                            (route) => false);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(Images.iconUnicorn),
                              size: displayWidth(context, 0.06),
                              color: controller.currentIndex == 3
                                  ? primaryBlue
                                  : lightGrey,
                            ),
                            Text(
                              david_recommendation,
                              style: textStyle(
                                  fontSize: 10,
                                  color: controller.currentIndex == 3
                                      ? primaryBlue
                                      : lightGrey,
                                  fontFamily: latoRegular),
                            )
                          ],
                        ),
                      ),
                    ),

                    // inventory screen
                    GestureDetector(
                      onTap: () {
                        controller.setNavigationIndex(context, 4);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouterHelper.inventoryScreen, (route) => false);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(Images.iconInventory),
                              size: displayWidth(context, 0.06),
                              color: controller.currentIndex == 4
                                  ? primaryBlue
                                  : lightGrey,
                            ),
                            Text(
                              inventory,
                              style: textStyle(
                                  fontSize: 10,
                                  color: controller.currentIndex == 4
                                      ? primaryBlue
                                      : lightGrey,
                                  fontFamily: latoRegular),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// =============================================================================

// class BottomNavigation extends StatelessWidget {
//   const BottomNavigation({Key? key}) : super(key: key);
//
//   // Bottom navigation the the bottom navigation bar of the app
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BottomNavigationProvider>(
//         builder: (context, controller, child) {
//       return BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           unselectedFontSize: 8,
//           selectedFontSize: 8,
//           selectedItemColor: primaryBlue,
//           unselectedItemColor: primaryGrey,
//           backgroundColor: primaryWhite,
//           elevation: 5,
//           currentIndex: controller.currentIndex,
//           onTap: (index) {
//             // set the current index of the bottom navigation bar
//             // the function is declared inside BottomNavigationProvider
//
//             controller.setNavigationIndex(index);
//
//             // Using switch for index to navigate to related screen
//             // index 0 => homeScreen
//             // index 1 => preferencesScreen
//             // index 2 => global search screen
//             // index 3 => davidRecommendationScreen
//             // index 4 => inventoryScreen
//
//             switch (index) {
//               case 0:
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     RouterHelper.homeScreen, (route) => false);
//                 break;
//               case 1:
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     RouterHelper.preferencesScreen, (route) => false);
//                 break;
//               case 2:
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     RouterHelper.globalSearchScreen, (route) => false);
//                 break;
//               case 3:
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     RouterHelper.davidRecommendationScreen, (route) => false);
//                 break;
//               case 4:
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                     RouterHelper.inventoryScreen, (route) => false);
//                 break;
//             }
//           },
//           items: const <BottomNavigationBarItem>[
//             // home
//             BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage(Images.iconRecommended)),
//                 label: recommended),
//             // preferences
//             BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage(Images.iconPreferences)),
//                 label: preferences),
//             // global search
//             BottomNavigationBarItem(
//                 icon: ImageIcon(
//                   AssetImage(Images.iconUnicorn),
//                   size: 0,
//                 ),
//                 label: ''),
//
//             // david recommendation
//             BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage(Images.iconUnicorn)),
//                 label: david_recommendation),
//             // inventory
//             BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage(Images.iconInventory)),
//                 label: inventory),
//           ]);
//     });
//   }
// }
