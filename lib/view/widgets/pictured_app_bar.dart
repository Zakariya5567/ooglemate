import 'package:badges/badges.dart' as badges;
import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/routes_helper.dart';
import '../../providers/search_filter_provider.dart';
import '../../utils/api_url.dart';
import '../../utils/app_constant.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';
import 'custom_icon_button.dart';

//isSearch 0 for searchIcon hide and 1 for show

// Page is used for page is , from which screen this widget is called
// 1 for home screen
// 2 for preferences screen
// 3 for inventory screen
// 4 for track screen
// 5 for trigger screen
// 6 for trigger count scree
// 7 david recommendation screen
// 8 global search screen

picturedAppBar({
  required BuildContext context,
  required title,
  required page,
  required isSearch,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 10,
    elevation: 0,
    backgroundColor: primaryWhite,
    title: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(onTap: () {
                Navigator.of(context)
                    .pushNamed(RouterHelper.userSectionProfileScreen);
              }, child: Consumer<ProfileProvider>(
                  builder: (context, controller, child) {
                return controller.getProfileModel.data == null
                    ? Container(
                        height: displayWidth(context, 0.075),
                        width: displayWidth(context, 0.075),
                        decoration: BoxDecoration(
                          color: primaryGrey,
                          shape: BoxShape.circle,
                          border: Border.all(color: veryLightGrey),
                        ))
                    : controller.getProfileModel.data!.photo == null
                        ? Container(
                            height: displayWidth(context, 0.075),
                            width: displayWidth(context, 0.075),
                            decoration: BoxDecoration(
                              color: primaryGrey,
                              shape: BoxShape.circle,
                              border: Border.all(color: veryLightGrey),
                            ),
                            child: Icon(
                              Icons.person,
                              size: displayWidth(context, 0.04),
                            ),
                          )
                        : Container(
                            height: displayWidth(context, 0.075),
                            width: displayWidth(context, 0.075),
                            decoration: BoxDecoration(
                                color: primaryGrey,
                                shape: BoxShape.circle,
                                border: Border.all(color: veryLightGrey),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "${ApiUrl.baseUrl}${controller.getProfileModel.data!.photo!}",
                                    ))),
                          );
              })),
              WidthSizedBox(context, 0.012),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textStyle(
                    fontSize: 15, color: primaryBlack, fontFamily: latoMedium),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isSearch == 0
                  ? const SizedBox()
                  : CustomIconButton(
                      icon: Images.iconSearch,
                      height: displayWidth(context, 0.055),
                      width: displayWidth(context, 0.055),
                      color: primaryGrey,
                      onTap: () async {
                        // instance of filter screen provider
                        final filterController =
                            Provider.of<SearchFilterProvider>(context,
                                listen: false);
                        // set the page id
                        filterController.setSearchPage(page);

                        // open search sheet
                        await searchSheet(context);
                      }),
              WidthSizedBox(context, 0.02),
              CustomIconButton(
                  icon: Images.iconTrack,
                  color: primaryGrey,
                  height: displayWidth(context, 0.055),
                  width: displayWidth(context, 0.055),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RouterHelper.trackedCarScreen);
                  }),
              WidthSizedBox(context, 0.02),
              CustomIconButton(
                  icon: Images.iconTrigger,
                  height: displayWidth(context, 0.055),
                  width: displayWidth(context, 0.055),
                  color: primaryGrey,
                  onTap: () {
                    Navigator.of(context).pushNamed(RouterHelper.triggerScreen);
                  }),
              WidthSizedBox(context, 0.02),
              Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                return SizedBox(
                  child: profileProvider.isNotify == true
                      ? badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 0, end: 0),
                          badgeStyle: const badges.BadgeStyle(
                            borderSide: BorderSide(color: primaryWhite),
                            shape: badges.BadgeShape.circle,
                            badgeColor: primaryBlue,
                            elevation: 5,
                          ),
                          child: CustomIconButton(
                              icon: Images.iconNotification,
                              height: displayWidth(context, 0.055),
                              width: displayWidth(context, 0.055),
                              color: primaryGrey,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(RouterHelper.notificationScreen);
                              }),
                        )
                      : CustomIconButton(
                          icon: Images.iconNotification,
                          height: displayWidth(context, 0.055),
                          width: displayWidth(context, 0.055),
                          color: primaryGrey,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RouterHelper.notificationScreen);
                          }),
                );
              })
            ],
          )
        ],
      ),
    ),
  );
}
