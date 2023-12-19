import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/providers/preferences_add_data_provider.dart';
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
import 'dart:io';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_snackbar.dart';

class UploadCSV extends StatefulWidget {
  UploadCSV({Key? key}) : super(key: key);

  @override
  State<UploadCSV> createState() => _UploadCSVState();
}

class _UploadCSVState extends State<UploadCSV> {
  FilePickerResult? result;

  late String _localPath;
  // late bool _permissionReady;
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

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
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
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  pickFile(BuildContext context) async {
    final provider =
        Provider.of<PreferencesAddDataProvider>(context, listen: false);
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
    return Consumer<PreferencesAddDataProvider>(
        builder: (context, controller, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pleaseUploadYourSaleData,
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
            HeightSizedBox(context, 0.08),
            CustomButton(
              buttonName: btnUpload,
              onPressed: () {
                if (controller.file != null) {
                  controller
                      .uploadCsv(context, RouterHelper.preferencesAddDataScreen)
                      .then((value) {
                    if (controller.uploadCsvModel.data != null) {
                      bool isSuccess = false;
                      for (var element in controller.uploadCsvModel.data!) {
                        if (element.trim().isEmpty) {
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
                            .pushNamed(RouterHelper.csvMappingScreen);
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
            HeightSizedBox(context, 0.04),
            CustomButton(
              buttonName: controller.downloading == true
                  ? "Downloading ${controller.percentage} %"
                  : btnDownloadSampleCsv,
              onPressed: () async {
                // _permissionReady = await _checkPermission();
                // await Permission.manageExternalStorage.request();
                // if (_permissionReady) {

                await _prepareSaveDir();
                await Future.delayed(Duration.zero, () {
                  controller
                      .getCsvFile(
                          context, RouterHelper.preferencesAddDataScreen)
                      .then((value) {
                    controller.downloadCsvFile(context,
                        RouterHelper.preferencesAddDataScreen, _localPath);
                  });
                });
                //}
              },
              buttonGradient: gradientWhite,
              buttonTextColor: primaryBlue,
              padding: 0,
            ),
          ],
        ),
      );
    });
  }
}
