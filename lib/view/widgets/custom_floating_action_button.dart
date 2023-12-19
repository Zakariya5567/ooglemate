import 'package:caroogle/helper/routes_helper.dart';
import 'package:caroogle/view/widgets/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/search_filter_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
      height: 55,
      width: 55,
      child: FloatingActionButton(
        backgroundColor: primaryBlue,
        child: Image.asset(
          Images.iconSearch,
          scale: 3.0,
          color: primaryWhite,
        ),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, RouterHelper.globalSearchScreen, (route) => false);
        },
      ),
    );
  }
}
