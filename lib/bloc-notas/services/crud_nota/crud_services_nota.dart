import 'package:bloc_notas/bloc-notas/bd_table/table_db.dart';
import 'package:bloc_notas/bloc-notas/dominio/gateway/gateway_nota.dart';
import 'package:bloc_notas/bloc-notas/dominio/models/model_note/models_nota.dart';

class ServicesNotesqLite extends NoteGateway {
  Note note;
  ServicesNotesqLite({required this.note}) : super(tablaNota);

  Note toObject(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userName: map['userName'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': note.id,
      'userName': note.userName,
      'content': note.content,
    };
  }

  // Método para guardar o actualizar un registro en la base de datos
  Future<int> save() async {
    // Verificar si el ID existe antes de actualizar
    List<Note> existingNotes = await getNotes();
    bool idExists =
        existingNotes.any((existingNote) => existingNote.id == note.id);
    if (idExists) {
      return await updateOrCreate();
    } else {
      // Manejar el caso en el que se intenta actualizar un ID que no existe
      return await create(toMap());
    }
  }

  Future<int> updateOrCreate() async {
    var result = await updateNote(toMap(), note.id);
    if (result == 0) {
      // Si no se actualiza ninguna fila, devolver un código o valor que indique falla en la actualización
      return -1; // Por ejemplo, puedes devolver -1 para indicar la falla en la actualización
    } else {
      return result;
    }
  }

  // Método para eliminar un registro de la base de datos
  Future<void> remove() async {
    await deleteNote(note.id);
  }

  // Método para obtener todos los registros de ServiceDiary
  Future<List<Note>> getNotes() async {
    var result = await rawQuery('SELECT * FROM $tablaNota');
    print('Soy yo Nota : $result');
    return _listDiaries(result);
  }

  // Método para convertir los resultados de la consulta en una lista de objetos ServiceDiary
  List<Note> _listDiaries(List<Map<String, dynamic>> parsed) {
    return parsed.map((map) => toObject(map)).toList();
  }
}
