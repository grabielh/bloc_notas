import 'dart:async';

import 'package:bloc_notas/bloc-notas/bd_table/table_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConexcionBD {
  static const String dataBasenotas = 'Bdnotas';
  static const int versionDatabase = 1;

  Future<Database> opeBD() async {
    try {
      String path = join(await getDatabasesPath(), dataBasenotas);
      Database db = await openDatabase(path,
          version: versionDatabase,
          onConfigure: onConfigure,
          onCreate: onCreate);

      await onConfigure(db);
      await onCreate(db, versionDatabase);
      return db;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onConfigure(Database db) async {
    try {
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (e) {
      print("Error al configurar la base de datos: $e");
    }
  }

  Future<void> onCreate(Database db, int version) async {
    try {
      for (var script in obtenerModelosTablaNota()) {
        await db.execute(script);
      }
    } catch (e) {
      print("Error al crear la tabla: $e");
    }
  }
}
