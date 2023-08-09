import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath(); //Get the path to the database
    return sql.openDatabase(path.join(dbPath, 'places.db'), //Open the database
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

//Method TO INSERT DATA INTO THE DATABASE:
  static Future<void> insertData(
      String tableName, Map<String, dynamic> tableData) async {
    final db = await DBHelper.database();
    //"INSERT" --> Command to insert data into the database:
    db.insert(tableName, tableData,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

//Method TO GET DATA FROM THE DATABASE:
  static Future<List<Map<String, dynamic>>> getData(String tablename) async {
    final db = await DBHelper.database();
    //"QUERY" --> Command to get data from the database:
    return db.query(tablename);
  }
}
