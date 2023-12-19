import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:caroogle/data/models/inventories/all_inventories_model.dart';
import '../providers/inventory_provider.dart';

class PdfGenerator {
  final provider = InventoryProvider();
  Future<File> generate(
    List<RowData> rowData,
    String path,
  ) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildInvoice(rowData),
      ],
    ));

    return saveDocument(
      name:
          'inventory${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}'
          '${DateTime.now().minute}'
          '${DateTime.now().second}'
          '${DateTime.now().millisecond}'
          '${DateTime.now().microsecond}.pdf',
      pdf: pdf,
      path: path,
    );
  }

  Widget buildInvoice(List<RowData> rowData) {
    final headers = [
      'make',
      'model',
      'year',
      'km driven',
      'badge',
      'fuel type',
      'body type',
      'selling price',
      'purchase price',
    ];
    final data = rowData!.map((item) {
      return [
        '${item.make}',
        '${item.model}',
        '${item.year}',
        '${item.kmDriven}',
        '${item.badge}',
        '${item.fuelType}',
        '${item.bodyType}',
        '${item.sellingPrice}',
        '${item.purchasePrice}'
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellStyle: const TextStyle(fontSize: 10),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      cellHeight: 40,
      rowDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: PdfColors.grey400,
            width: 0.5,
          ),
        ),
      ),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
        8: Alignment.centerLeft,
      },
    );
  }

  Future<File> saveDocument({
    required String name,
    required Document pdf,
    required String path,
  }) async {
    final bytes = await pdf.save();
    final file = File('$path/$name');
    await file.writeAsBytes(bytes).then((value) {});
    // await OpenFile.open(file.path);
    return file;
  }
}
