import 'package:hive/hive.dart';
part 'search_history.g.dart';

@HiveType(typeId: 0)
class SearchHistory extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime date;

  SearchHistory({required this.text, required this.date});
}
