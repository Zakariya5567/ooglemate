import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'circular_progress.dart';

loaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            backgroundColor: primaryWhite,
            insetPadding: const EdgeInsets.all(100),
            contentPadding: const EdgeInsets.all(25),
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: const SizedBox(
                height: 80,
                //  color: lightGrey,
                width: 80,
                child: CircularProgress()));
      });
}
