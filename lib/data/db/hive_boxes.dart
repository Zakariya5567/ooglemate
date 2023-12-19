import 'package:caroogle/data/db/search_history.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<SearchHistory> getSearchHistory() =>
      Hive.box<SearchHistory>("search_history");
}
