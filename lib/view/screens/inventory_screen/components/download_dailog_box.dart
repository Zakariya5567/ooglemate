import 'package:caroogle/data/models/inventories/all_inventories_model.dart';
import 'package:caroogle/helper/notification_service.dart';
import 'package:caroogle/helper/pdf_generator.dart';
import 'package:caroogle/utils/images.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/widgets/custom_button.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../../helper/csv_generator.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';
import '../../../widgets/custom_snackbar.dart';

Future downloadDialogBox(BuildContext context, String title, String path,
    List<RowData> data, PdfGenerator pdfGenerator, CsvGenerator csvGenerator) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            contentPadding: const EdgeInsets.all(15),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              color: primaryWhite,
              width: displayWidth(context, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomIconButton(
                        icon: Images.iconCross,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        height: displayWidth(context, 0.055),
                        width: displayWidth(context, 0.055),
                        color: primaryGrey),
                  ),
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textStyle(
                          fontSize: 16,
                          color: primaryBlack,
                          fontFamily: rubikRegular),
                    ),
                  ),
                  HeightSizedBox(context, 0.03),
                  CustomButton(
                      buttonName: btnCsv,
                      onPressed: () async {
                        await Future.delayed(Duration.zero, () async {
                          await csvGenerator
                              .saveDocumentCsv(data, path)
                              .then((value) {
                            Navigator.of(context).pop();

                            NotificationService().displayAlertNotification();

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     customSnackBar(
                            //         context, 'File download successfully', 0));
                          });
                        });
                      },
                      buttonGradient: gradientBlue,
                      buttonTextColor: primaryWhite,
                      padding: 5),
                  HeightSizedBox(context, 0.02),
                  CustomButton(
                      buttonName: btnPdf,
                      onPressed: () async {
                        await Future.delayed(Duration.zero, () async {
                          await pdfGenerator.generate(data, path).then((value) {
                            Navigator.of(context).pop();

                            NotificationService().displayAlertNotification();

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     customSnackBar(
                            //         context, 'File download successfully', 0));
                          });
                        });
                      },
                      buttonGradient: gradientBlue,
                      buttonTextColor: primaryWhite,
                      padding: 5),
                  HeightSizedBox(context, 0.02),
                ],
              ),
            ));
      });
}
