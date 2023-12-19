import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';
import '../../../../utils/string.dart';

namedAppBar(
    {required BuildContext context,
    required String title,
    required Color color}) {
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 10,
    elevation: title == changPlan ? 1 : 0,
    backgroundColor: color,
    title: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryBlack,
                size: 20,
              )),
          WidthSizedBox(context, 0.01),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textStyle(
                fontSize: 16, color: primaryBlack, fontFamily: rubikRegular),
          ),
        ],
      ),
    ),
  );
}
