import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/routes_helper.dart';
import '../../providers/profile_provider.dart';
import '../../utils/api_url.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/style.dart';

customAppBar({
  required BuildContext context,
  required color,
  required title,
  required icon1,
  required icon2,
  required icon3,
  required icon4,
  required page,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 10,
    elevation: 0,
    backgroundColor: color,
    title: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              page == 'inventory'
                  ? InkWell(onTap: () {
                      Navigator.of(context)
                          .pushNamed(RouterHelper.userSectionProfileScreen);
                    }, child: Consumer<ProfileProvider>(
                      builder: (context, controller, child) {
                      return controller.getProfileModel.data == null
                          ? Container(
                              height: displayWidth(context, 0.075),
                              width: displayWidth(context, 0.075),
                              decoration: BoxDecoration(
                                color: primaryGrey,
                                shape: BoxShape.circle,
                                border: Border.all(color: veryLightGrey),
                              ))
                          : controller.getProfileModel.data!.photo == null
                              ? Container(
                                  height: displayWidth(context, 0.075),
                                  width: displayWidth(context, 0.075),
                                  decoration: BoxDecoration(
                                    color: primaryGrey,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: veryLightGrey),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: primaryWhite,
                                    size: displayWidth(context, 0.04),
                                  ),
                                )
                              : Container(
                                  height: displayWidth(context, 0.075),
                                  width: displayWidth(context, 0.075),
                                  decoration: BoxDecoration(
                                      color: primaryGrey,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: veryLightGrey),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "${ApiUrl.baseUrl}${controller.getProfileModel.data!.photo!}",
                                          ))),
                                );
                    }))
                  : InkWell(
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
                    fontSize: 16,
                    color: primaryBlack,
                    fontFamily: rubikRegular),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              icon1,
              WidthSizedBox(context, 0.02),
              icon2,
              WidthSizedBox(context, 0.02),
              icon3,
              WidthSizedBox(context, 0.02),
              icon4
            ],
          )
        ],
      ),
    ),
  );
}
