import 'package:caroogle/providers/david_recommendataion_screen_provider.dart';
import 'package:caroogle/providers/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/dimension.dart';
import '../../../../../utils/style.dart';
import '../../../../helper/routes_helper.dart';

class DavidTitleList extends StatelessWidget {
  DavidTitleList({Key? key}) : super(key: key);

  // instance of the scrollable listener to listen for scroll position

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Consumer<DavidRecommendationScreenProvider>(
        builder: (context, controller, child) {
      return Container(
        color: primaryWhite,
        height: 40,
        width: displayWidth(context, 1),
        child: controller.sourceModel.data == null
            ? const SizedBox()
            : ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                initialScrollIndex: controller.titleListIndex!.toInt(),
                itemPositionsListener: itemPositionsListener,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.sourceModel.data!.length!,
                itemBuilder: (context, index) {
                  final data = controller.sourceModel.data![index];
                  return Consumer<DavidRecommendationScreenProvider>(
                      builder: (context, controller, child) {
                    return InkWell(
                      onTap: () {
                        // set tge selected index of the source
                        controller.setTitleListIndex(index, data.sourceId!);

                        // calling api
                        controller.getDavidRecommended(
                            context, 0, RouterHelper.davidRecommendationScreen);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(05),
                        child: Column(
                          children: [
                            // logic to make first letter of the text convert to upper case
                            Text(
                                data.source!.replaceFirst(data.source![0],
                                    data.source![0].toUpperCase()),
                                textAlign: TextAlign.center,
                                style: controller.titleListIndex == index
                                    ? textStyle(
                                        fontSize: 16,
                                        color: primaryBlue,
                                        fontFamily: latoBold)
                                    : textStyle(
                                        fontSize: 16,
                                        color: primaryGrey,
                                        fontFamily: latoMedium)),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.titleListIndex == index
                                    ? primaryBlue
                                    : primaryWhite,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                }),
      );
    });
  }
}
