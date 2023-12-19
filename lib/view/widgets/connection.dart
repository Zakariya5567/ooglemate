import 'package:caroogle/data/models/connection_model.dart';
import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../helper/routes_helper.dart';
import '../../utils/images.dart';
import '../../utils/style.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionModel args =
        ModalRoute.of(context)!.settings.arguments as ConnectionModel;
    //as ConnectionModel;
    //var c = args as ConnectionModel;
    debugPrint("screen is : ${args.screen}");
    debugPrint("message is : ${args.message}");

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, args.screen);
        return Future.value(true);
      },
      child: Scaffold(
        body: SizedBox(
          height: displayHeight(context, 1),
          width: displayWidth(context, 1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: displayHeight(context, 0.3),
                  width: displayWidth(context, 0.8),
                  child: Image.asset(
                    Images.connection,
                  ),
                ),
                Text(
                  args.message,
                  // "No internet connection",
                  style: textStyle(
                      fontSize: 20,
                      color: primaryBlue,
                      fontFamily: latoSemiBold),
                ),
                HeightSizedBox(context, 0.15),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, args.screen);
                  },
                  child: Container(
                    height: displayHeight(context, 0.055),
                    width: displayWidth(context, 0.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: primaryBlue, width: 1),
                        color: primaryWhite),
                    child: Center(
                      child: Text("Try Again",
                          style: textStyle(
                              fontSize: 16,
                              color: primaryBlue,
                              fontFamily: sfProText)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
