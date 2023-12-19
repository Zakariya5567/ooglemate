import 'dart:io';

import 'package:csv/csv.dart';

import '../data/models/inventories/all_inventories_model.dart';

// Add the csv package to your pubspec.yaml file:
class CsvGenerator {
  Future<File> saveDocumentCsv(List<RowData> rowData, String path) async {
    //Define the data that you want to write to the CSV file in a list or a list of lists.
    // Headers
    List<List<String>> listOfRow = [
      [
        "make",
        "model",
        "year",
        "km driven",
        "badge",
        "fuel type",
        "body type",
        "selling price",
        "purchase price"
      ],
    ];

    // Body of the csv
    // add data to the above list
    final data = rowData.map((item) {
      listOfRow.add([
        "${item.make}",
        "${item.model}",
        "${item.year}",
        "${item.kmDriven}",
        "${item.badge}",
        "${item.fuelType}",
        "${item.bodyType}",
        "${item.sellingPrice}",
        "${item.purchasePrice}",
      ]);
    }).toList();

    // Use the ListToCsvConverter class to convert the data to a CSV string:

    String csvData = const ListToCsvConverter().convert(listOfRow);

    // Write the CSV string to a file using the dart:io library:
    // create the name of the csv file

    final file = File(
        '$path/inventory${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}'
        '${DateTime.now().minute}'
        '${DateTime.now().second}'
        '${DateTime.now().millisecond}'
        '${DateTime.now().microsecond}.csv');

    // save the file in storage
    await file.writeAsString(csvData);

    return file;
  }
}
