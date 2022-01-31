import 'package:sqflite/sqflite.dart';
import 'package:todole/data/taskdb.dart';

class Helper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Creating a new task");
          return db.execute(
            "CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "priority INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
  static Future <int> insert(Task? task) async{
    print("Inserting a new task");
    return await _db?.insert(_tableName, task!.toJson())??1;
  }
}