import 'dart:io';

import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/authentication_provider.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/profile_screen/components/profile_items_list.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/profile_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../utils/api_url.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../../widgets/circular_progress.dart';

class UserSectionProfileScreen extends StatelessWidget {
  const UserSectionProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: greyStatusStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppBar(
            context: context,
            color: cardGreyColor,
            title: userSection,
            page: 'profile',
            icon1: const SizedBox(),
            icon2: const SizedBox(),
            icon3: const SizedBox(),
            icon4: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouterHelper.editProfileScreen);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Image.asset(Images.iconEdit,
                    height: displayWidth(context, 0.045),
                    width: displayWidth(context, 0.045),
                    color: primaryBlack),
              ),
            ),
          ),
          backgroundColor: primaryWhite,
          body:
              Consumer<ProfileProvider>(builder: (context, controller, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: displayWidth(context, 1),
                    decoration: const BoxDecoration(
                        color: cardGreyColor,
                        border:
                            Border(bottom: BorderSide(color: veryLightGrey))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                controller.getProfileModel.data!.photo == null
                                    ? Container(
                                        height: displayWidth(context, 0.25),
                                        width: displayWidth(context, 0.25),
                                        decoration: BoxDecoration(
                                          color: primaryGrey,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: veryLightGrey),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: primaryWhite,
                                          size: displayWidth(context, 0.15),
                                        ),
                                      )
                                    : Container(
                                        height: displayWidth(context, 0.25),
                                        width: displayWidth(context, 0.25),
                                        decoration: BoxDecoration(
                                            color: primaryGrey,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: veryLightGrey),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    "${ApiUrl.baseUrl}${controller.getProfileModel.data!.photo!}"))),
                                      ),
                                WidthSizedBox(context, 0.02),
                                Container(
                                  height: displayHeight(context, 0.08),
                                  width: displayWidth(context, 0.58),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .getProfileModel.data!.name ??
                                              " ",
                                          style: textStyle(
                                              fontSize: 22,
                                              color: lightBlack,
                                              fontFamily: latoBold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      HeightSizedBox(context, 0.01),
                                      Expanded(
                                        child: Text(
                                          controller.getProfileModel.data!
                                                  .email ??
                                              " ",
                                          style: textStyle(
                                              fontSize: 15,
                                              color: primaryGrey,
                                              fontFamily: latoMedium),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          HeightSizedBox(context, 0.05),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        HeightSizedBox(context, 0.03),
                        ProfileItemList(
                            title: favourites,
                            button: CustomIconButton(
                              icon: Images.iconForward,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(RouterHelper.favouriteScreen);
                              },
                              height: displayWidth(context, 0.045),
                              width: displayWidth(context, 0.045),
                              color: primaryGrey,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RouterHelper.favouriteScreen);
                            }),
                        HeightSizedBox(context, 0.03),
                        subscriptionProvider.subscriptionSettingModel.data!
                                    .subscriptionEnabled ==
                                1
                            ? ProfileItemList(
                                title: subscription,
                                button: CustomIconButton(
                                  icon: Images.iconForward,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        RouterHelper.subscriptionScreen);
                                  },
                                  height: displayWidth(context, 0.045),
                                  width: displayWidth(context, 0.045),
                                  color: primaryGrey,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      RouterHelper.subscriptionScreen);
                                })
                            : const SizedBox(),
                        subscriptionProvider.subscriptionSettingModel.data!
                                    .subscriptionEnabled ==
                                1
                            ? HeightSizedBox(context, 0.03)
                            : const SizedBox(),
                        ProfileItemList(
                            title: notifications,
                            button: Consumer<ProfileProvider>(
                                builder: (context, controller, child) {
                              return FlutterSwitch(
                                  height: 22,
                                  width: 45,
                                  activeColor: primaryBlue,
                                  inactiveColor: primaryGrey.withOpacity(0.5),
                                  toggleColor: primaryWhite,
                                  toggleSize: 20,
                                  value: controller.getProfileModel.data!
                                              .notification ==
                                          1
                                      ? true
                                      : false,
                                  onToggle: (newValue) async {
                                    controller.setSwitchValue(newValue);
                                    await controller
                                        .notificationEnableDisable(context,
                                            RouterHelper.preferencesScreen)
                                        .then((value) async {
                                      await controller.getProfile(context,
                                          RouterHelper.preferencesScreen);
                                    });
                                  });
                            }),
                            onTap: () {}),
                        HeightSizedBox(context, 0.03),
                        ProfileItemList(
                            title: logOut,
                            button: const SizedBox(),
                            onTap: () async {
                              final provider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              provider
                                  .logOut(context, RouterHelper.signInScreen)
                                  .then((value) {
                                if (provider.logOutModel.error == false) {
                                  GoogleSignIn().signOut();
                                  //  FacebookAuth.instance.logOut();
                                  controller.clearTextField();
                                  controller.image = null;
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouterHelper.signInScreen,
                                      (route) => false);
                                }
                              });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
