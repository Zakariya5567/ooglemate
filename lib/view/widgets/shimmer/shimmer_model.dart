import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';
import '../../../utils/images.dart';

class ShimmerModel extends StatelessWidget {
  const ShimmerModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: veryLightGrey,
      highlightColor: cardGreyColor,
      child: Container(
          height: 70,
          width: displayWidth(context, 0.40),
          decoration: const BoxDecoration(
              // color: primaryWhite,
              border:
                  Border(bottom: BorderSide(color: cardGreyColor, width: 1))),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12,
                  color: cardGreyColor,
                  width: displayWidth(context, 0.20),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 12,
                        color: cardGreyColor,
                        width: displayWidth(context, 0.20),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const ImageIcon(
                      AssetImage(Images.iconDropdown),
                      size: 15,
                      color: primaryBlack,
                    )
                  ],
                ),
                const SizedBox()
              ])),
    );
  }
}
