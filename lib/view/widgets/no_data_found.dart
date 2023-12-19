import 'package:caroogle/utils/colors.dart';
import 'package:caroogle/utils/dimension.dart';
import 'package:caroogle/utils/style.dart';
import 'package:flutter/cupertino.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            height: displayHeight(context, 0.80),
            width: displayWidth(context, 1),
            alignment: Alignment.center,
            color: primaryWhite,
            child: Text(
              "No Data Found!",
              style: textStyle(
                  fontSize: 16, color: primaryBlack, fontFamily: latoSemiBold),
            ),
          ),
        ]);
  }
}
