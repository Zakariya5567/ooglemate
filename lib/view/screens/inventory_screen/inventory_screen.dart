import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:caroogle/data/models/inventories/inventory_mapping_model.dart';
import 'package:caroogle/helper/csv_generator.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:caroogle/providers/inventory_car_detail_provider.dart';
import 'package:caroogle/providers/inventory_provider.dart';
import 'package:caroogle/providers/search_filter_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/inventory_screen/components/download_dailog_box.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_button_list.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_car_detail_image_section.dart';
import 'package:caroogle/view/screens/inventory_screen/components/inventory_title_list.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/custom_snackbar.dart';
import 'package:caroogle/view/widgets/round_add_button.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../helper/pdf_generator.dart';
import '../../../helper/routes_helper.dart';
import '../../../providers/bottom_navigation_provider.dart';
import '../../../providers/inventory_add_new_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../utils/dimension.dart';
import '../../../utils/style.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_floating_action_button.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/search_sheet.dart';
import 'components/inventory_data_list.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  ScrollController scrollController = ScrollController();
  PdfGenerator pdfGenerator = PdfGenerator();
  CsvGenerator csvGenerator = CsvGenerator();

  late String _localPath;
//  late bool _permissionReady;
  late TargetPlatform? platform;

  // Future<bool> _checkPermission() async {
  //   print("Check permission ------------------------__>>>>>>>>>>>>>>");
  //   if (platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    debugPrint(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      debugPrint("IOS");
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  @override
  void initState() {
    super.initState();
    callingApi(0);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  callingApi(int isPagination) {
    debugPrint("isPagination : $isPagination");
    // if value = 0 its mean first time we are getting data
    // if value = 1 its mean we are doing pagination
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    Future.delayed(Duration.zero, () {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      provider.setLoading(true);
      final navigationProvider =
          Provider.of<BottomNavigationProvider>(context, listen: false);
      navigationProvider.setNavigationIndex(context, 4);
      provider.setIsSearching(false);
      provider.getSource(context, RouterHelper.inventoryScreen).then((value) {
        if (isPagination == 0 && provider.isFilter == false) {
          provider.clearFilter();
          provider.clearTitleIndex();
          provider.clearOffset();
          provider.getAllInventories(context, 0, RouterHelper.inventoryScreen);
        }
      });
    });
  }

  Future<void> onRefresh() async {
    // Your refresh logic goes here
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    await Future.delayed(Duration.zero, () {
      provider.setIsSearching(false);
      provider.clearFilter();
      provider.clearOffset();
      provider.getAllInventories(context, 0, RouterHelper.inventoryScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    // final carDetailProvider =
    //     Provider.of<InventoryCarDetailProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: primaryWhite,
            appBar: customAppBar(
                context: context,
                color: primaryWhite,
                title: carInventory,
                page: 'inventory',
                icon1: const SizedBox(),
                icon2: Consumer<InventoryProvider>(
                    builder: (context, invp, child) {
                  return CustomIconButton(
                      icon: Images.iconDownload,
                      height: displayWidth(context, 0.055),
                      width: displayWidth(context, 0.055),
                      color: primaryGrey,
                      onTap: () async {
                        final data = invp.inventoryModel.data!.rows!;

                        // _permissionReady = await _checkPermission();
                        //await Permission.manageExternalStorage.request();
                        //  if (_permissionReady == true) {
                        await _prepareSaveDir();
                        await Future.delayed(Duration.zero, () async {
                          downloadDialogBox(context, downloadAs, _localPath,
                              data, pdfGenerator, csvGenerator);
                        });
                        // }
                      });
                }),
                icon3: CustomIconButton(
                    icon: Images.iconSearch,
                    height: displayWidth(context, 0.055),
                    width: displayWidth(context, 0.055),
                    color: primaryGrey,
                    onTap: () async {
                      final filterController =
                          Provider.of<SearchFilterProvider>(context,
                              listen: false);
                      filterController.setSearchPage(3);
                      await searchSheet(context);
                    }),
                icon4: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                  return SizedBox(
                    child: profileProvider.isNotify == true
                        ? badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: 0, end: 0),
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
                                  Navigator.of(context).pushNamed(
                                      RouterHelper.notificationScreen);
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
                })),
            body: Consumer<InventoryProvider>(
                builder: (context, controller, child) {
              return controller.isLoading == true ||
                      controller.inventoryModel.data == null ||
                      controller.sourceModel.data == null
                  ? ShimmerList(pagination: 0)
                  : Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: onRefresh,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InventoryTitleList(),
                                HeightSizedBox(context, 0.01),
                                const InventoryButtonList(),
                                HeightSizedBox(context, 0.01),
                                const InventoryDataList(),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            bottom: 25,
                            child: RoundAddButton(
                              onTap: () {
                                final invProvider =
                                    Provider.of<InventoryAddNewProvider>(
                                        context,
                                        listen: false);
                                invProvider.setHide(false);

                                Navigator.of(context).pushNamed(
                                    RouterHelper.inventoryAddNewScreen);
                              },
                            )),
                      ],
                    );
            }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: !isKeyboard
                ? const CustomFloatingActionButton()
                : const SizedBox(),
            bottomNavigationBar: const BottomNavigation()),
      ),
    );
  }
}
