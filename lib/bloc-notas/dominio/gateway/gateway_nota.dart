import 'package:bloc_notas/bloc-notas/bd_conexcion/conexcion.dart';
import 'package:sqflite/sqflite.dart';

abstract class NoteGateway {
  String table;
  NoteGateway(this.table);

  Future<Database> get database async {
    return await ConexcionBD().opeBD();
  }

  Future<List<Map<String, Object?>>> rawQuery(String sql,
      {List<dynamic> argumentos = const []}) async {
    return (await database).rawQuery(sql, argumentos);
  }
  Future<List<Map<String, Object?>>> rawQuerylist(String sql, List<int> list,
      {List<dynamic> argumentos = const []}) async {
    return (await database).rawQuery(sql, argumentos);
  }
  Future<int> updateNote(Map<String, dynamic> data, int id) async {
    return (await database)
        .update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> create(Map<String, dynamic> date) async {
    return (await database).insert(table, date);
  }

  Future<int> deleteNote(int id) async {
    return (await database).delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
