import 'dart:io';

import 'package:caroogle/providers/inventory_add_new_provider.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../helper/routes_helper.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_snackbar.dart';

class InventoryUploadCSV extends StatefulWidget {
  const InventoryUploadCSV({Key? key}) : super(key: key);

  @override
  State<InventoryUploadCSV> createState() => _InventoryUploadCSVState();
}

class _InventoryUploadCSVState extends State<InventoryUploadCSV> {
  FilePickerResult? result;

  late String _localPath;
  //late bool _permissionReady;
  late TargetPlatform? platform;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  // Future<bool> _checkPermission() async {
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

  // Future<void> _prepareSaveDir() async {
  //   _localPath = (await _findLocalPath())!;
  //
  //   print(_localPath);
  //   final savedDir = Directory(_localPath);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     savedDir.create();
  //   }
  // }

  // Future<String?> _findLocalPath() async {
  //   if (platform == TargetPlatform.android) {
  //     return "/sdcard/download/";
  //   } else {
  //     var directory = await getApplicationDocumentsDirectory();
  //     return '${directory.path}${Platform.pathSeparator}Download';
  //   }
  // }

  pickFile(BuildContext context) async {
    final provider =
        Provider.of<InventoryAddNewProvider>(context, listen: false);
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result!.files.first.path!);
      provider.setFile(file!);
      debugPrint("file: $file");
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryAddNewProvider>(
        builder: (context, controller, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chooseFile,
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: latoBold),
            ),
            HeightSizedBox(context, 0.02),
            Container(
                height: displayHeight(context, 0.15),
                width: displayWidth(context, 1),
                decoration: BoxDecoration(
                    color: primaryWhite,
                    border: Border.all(color: primaryGrey, width: 1.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: CustomIconButton(
                        icon: controller.file == null
                            ? Images.iconCirclePlus
                            : Images.checkMark,
                        onTap: () {
                          pickFile(context);
                        },
                        height: displayWidth(context, 0.1),
                        width: displayWidth(context, 0.1),
                        color: primaryBlue))),
            HeightSizedBox(context, 0.015),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  pickFile(context);
                },
                child: Container(
                  height: 30,
                  width: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryBlue),
                      gradient: gradientBlue),
                  child: Center(
                    child: Text(btnAdd,
                        style: textStyle(
                            fontSize: 14,
                            color: primaryWhite,
                            fontFamily: sfProText)),
                  ),
                ),
              ),
            ),
            HeightSizedBox(context, 0.06),
            CustomButton(
              buttonName: btnUpload,
              onPressed: () async {
                if (controller.file != null) {
                  controller
                      .uploadInventoryCsv(
                          context, RouterHelper.inventoryAddNewScreen)
                      .then((value) {
                    if (controller.uploadInventoryModel.data != null) {
                      bool isSuccess = false;
                      for (var element
                          in controller.uploadInventoryModel.data!) {
                        if (element!.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                              context,
                              " Please upload valid csv file, Headers cannot be empty",
                              1));
                          isSuccess = false;
                          break;
                        } else {
                          isSuccess = true;
                        }
                      }
                      if (isSuccess) {
                        Navigator.of(context)
                            .pushNamed(RouterHelper.inventoryCsvMappingScreen);
                      }
                    }
                    controller.file = null;
                  });
                }
              },
              buttonGradient: gradientBlue,
              buttonTextColor: primaryWhite,
              padding: 0,
            ),
          ],
        ),
      );
    });
  }
}
