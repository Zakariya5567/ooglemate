import 'package:caroogle/providers/car_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/car_detail_list.dart';

class PurchasedDetailList extends StatelessWidget {
  const PurchasedDetailList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CarDetailProvider>(builder: (context, controller, child) {
      final data = controller.carDetailModel.data!;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            DetailList(title: "Add ID", description: "${data.adId ?? " "} "),
            DetailList(title: "Car Make", description: data.make ?? " "),
            DetailList(
                title: "Price",
                description: data.price == null ? " " : "AU\$ ${data.price}"),
            DetailList(title: "Km", description: "${data.kmDriven ?? " "}"),
            DetailList(title: "Fuel Type", description: data.fuelType ?? " "),
            DetailList(title: "Year", description: "${data.year ?? " "}"),
            DetailList(title: "Car Model", description: data.model ?? " "),
            DetailList(title: "Body Type", description: data.bodyType ?? " "),
            DetailList(title: "Add Source", description: data.source ?? " "),
            DetailList(title: "Car Badge", description: data.badge ?? " "),
            DetailList(title: "Ad URL", description: data.url ?? " "),
          ],
        ),
      );
    });
  }
}
