import 'package:caroogle/providers/trigger_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../helper/routes_helper.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimension.dart';
import '../../../../utils/style.dart';

class TriggerTitleList extends StatelessWidget {
  TriggerTitleList({Key? key}) : super(key: key);

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Consumer<TriggerProvider>(builder: (context, controller, child) {
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
                itemCount: controller.sourceModel.data!.length,
                itemBuilder: (context, index) {
                  final data = controller.sourceModel.data![index];
                  return InkWell(
                    onTap: () {
                      controller.setTitleListIndex(index, data.sourceId!);
                      controller.getCarInTrigger(
                          context, 0, RouterHelper.inventoryScreen);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(05),
                        child: Column(
                          children: [
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
                        )),
                  );
                }),
      );
    });
  }
}
