import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CustomDbClass {
  CustomDbClass._internal();
  static final instance =
      CustomDbClass._internal(); //this one and the one before it is said to be there to prevent the creation of multiple instance of the db all the time . by locking the front door and giving access to only this one

  Database? _database;

  Future<Database> get getter async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'sql.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          """CREATE TABLE lectureTrackers(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT, date TEXT, accomplised INTEGER)""",
        );
      },
    );
    return _database!;
  }
}

//this is for fetching all data from the database works for any table
Future<List<Map>> fetchAll({
  required Database dbLocator,
  required String tableName,
  required int limit,
}) async {
  List<Map> allData = await dbLocator.rawQuery(
    "SELECT * FROM $tableName ORDER BY id DESC LIMIT $limit ",
  ); //the order by has its obvious meaning , the DESC mean descending since i want from most recent to old, ASC as ascending
  return allData;
}

//this is for inserting specifically into the lectureTrackers table
Future<void> insertIntoLectureTrackers({
  required Database dbLocator,
  required String title,
  required String date,
  required int accomplised,
}) async {
  await dbLocator.rawInsert(
    """INSERT INTO lectureTrackers(title, date, accomplised) VALUES(?, ?, ?)""",
    [title, date, accomplised],
  );
}

//this is for deleting every data in the pastLectures itself
Future<void> deleteAllRowsPastLectures({required Database dbLocator}) async {
  await dbLocator.rawDelete(
    """DELETE FROM lectureTrackers""",
  ); //add the WHERE to delete a particular row
}
