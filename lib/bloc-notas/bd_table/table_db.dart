const String tablaNota = 'blocnota';
const String tablaPagina = 'pagenota';

List<String> obtenerModelosTablaNota() {
  return [
    crearTabla(
      tablaNota,
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'userName TEXT, '
      'content TEXT',
    ),
    crearTabla(
      tablaPagina,
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'password TEXT, '
      'date TEXT, '
      'title TEXT, '
      'idnota INTEGER, '
      'FOREIGN KEY(idnota) REFERENCES $tablaNota (id)',
    ),
  ];
}

String crearTabla(String nombreTabla, String columnas) {
  return 'CREATE TABLE IF NOT EXISTS $nombreTabla ($columnas)';
}
