import 'package:bloc_notas/bloc-notas/bd_table/table_db.dart';
import 'package:bloc_notas/bloc-notas/dominio/gateway/gateway_nota.dart';
import 'package:bloc_notas/bloc-notas/dominio/models/models_page/models_page.dart';

class ServicesNotesqLitecifrado extends NoteGateway {
  Pagenotacifrado pageNota;
  ServicesNotesqLitecifrado({required this.pageNota}) : super(tablaPagina);

  Pagenotacifrado toObject(Map<String, dynamic> map) {
    return Pagenotacifrado(
      id: map['id'],
      password: map['password'],
      date: map['date'],
      title: map['title'],
      idnota: map['idnota'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': pageNota.id,
      'password': pageNota.password,
      'date': pageNota.date,
      'title': pageNota.title,
      'idnota': pageNota.idnota,
    };
  }

  // Método para guardar o actualizar un registro en la base de datos
  Future<int> save() async {
    // Verificar si el ID existe antes de actualizar
    List<Pagenotacifrado> existingNotes = await getNotescifradas();
    bool idExists =
        existingNotes.any((existingNote) => existingNote.id == pageNota.id);
    if (idExists) {
      return await updateOrCreate();
    } else {
      // Manejar el caso en el que se intenta actualizar un ID que no existe
      return await create(toMap());
    }
  }

  Future<int> updateOrCreate() async {
    var result = await updateNote(toMap(), pageNota.id);
    if (result == 0) {
      // Si no se actualiza ninguna fila, devolver un código o valor que indique falla en la actualización
      return -1; // Por ejemplo, puedes devolver -1 para indicar la falla en la actualización
    } else {
      return result;
    }
  }

  // Método para eliminar un registro de la base de datos
  Future<void> remove() async {
    await deleteNote(pageNota.id);
  }

  // Método para obtener todos los registros de ServiceDiary
  Future<List<Pagenotacifrado>> getNotescifradas() async {
    var result = await rawQuery('SELECT * FROM $tablaPagina');
    print('Nota cifrada :$result');
    return _listNotascifrada(result);
  }

  // Método para convertir los resultados de la consulta en una lista de objetos ServiceDiary
  List<Pagenotacifrado> _listNotascifrada(List<Map<String, dynamic>> parsed) {
    return parsed.map((map) => toObject(map)).toList();
  }
}
