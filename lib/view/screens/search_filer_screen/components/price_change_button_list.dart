// import 'package:caroogle/providers/search_filter_provider.dart';
// import 'package:caroogle/utils/string.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../utils/colors.dart';
// import '../../../../utils/dimension.dart';
// import '../../../../utils/style.dart';
//
// class PriceChangeButtonList extends StatelessWidget {
//   PriceChangeButtonList({required this.controller});
//   var controller;
//   List buttons = ["Low", "Good", "Best"];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: displayHeight(context, 0.075),
//       width: displayWidth(context, 1),
//       child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: buttons.length,
//           itemBuilder: (context, index) {
//             return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//                   onTap: () {
//                     controller.setPriceChangesIndex(index);
//                   },
//                   child: Container(
//                     width: displayWidth(context, 0.33),
//                     decoration: BoxDecoration(
//                         color: controller.priceChangeIndex == index
//                             ? primaryBlue
//                             : primaryWhite,
//                         borderRadius: BorderRadius.circular(25),
//                         border: Border.all(
//                             color: controller.priceChangeIndex == index
//                                 ? primaryBlue
//                                 : lightBlue,
//                             width: 1)),
//                     child: Center(
//                       child: Text(buttons[index],
//                           style: textStyle(
//                               fontSize: 14,
//                               color: controller.priceChangeIndex == index
//                                   ? primaryWhite
//                                   : lightBlue,
//                               fontFamily: sfProText)),
//                     ),
//                   ),
//                 ));
//           }),
//     );
//   }
// }
