import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluton_test/model/add_post_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../model/db_models.dart';

class PostsDatabase {
  static final PostsDatabase instance = PostsDatabase._internal();

  static Database? _database;

  PostsDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getApplicationDocumentsDirectory();
    log("-----------------$databasePath");
    final path = join(databasePath.path, 'posts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${SvaedPostsFields.tableName} (
          id ${SvaedPostsFields.intType},
          title ${SvaedPostsFields.textType},
          body ${SvaedPostsFields.textType},
          userId ${SvaedPostsFields.intType},
          likes ${SvaedPostsFields.intType},
          'dislikes' ${SvaedPostsFields.intType}
        )
      ''');
  }

  void create(AddPostModel note) async {
    final db = await instance.database;
    final id = await db
        .insert(SvaedPostsFields.tableName, note.toJson())
        .whenComplete(() {
      log("Data is saved to databse----------------- ${note.id}");
    });
  }

  Future<List<AddPostModel>> readAll() async {
    final db = await instance.database;
    // const orderBy = '${NoteFields.createdTime} DESC';
    final result = await db.query(
      SvaedPostsFields.tableName,
    );
    return result.map((json) => AddPostModel.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      SvaedPostsFields.tableName,
      where: 'id = ?',
      whereArgs: [id],
    ).whenComplete(() {
      log("Data is deleted to databse----------------- $id");
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
