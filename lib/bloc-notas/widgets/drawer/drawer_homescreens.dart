// ignore_for_file: use_build_context_synchronously

import 'package:bloc_notas/bloc-notas/dominio/models/model_note/models_nota.dart';
import 'package:bloc_notas/bloc-notas/dominio/models/models_page/models_page.dart';
import 'package:bloc_notas/bloc-notas/services/crud_cifrado_nota/crud_cifrado_nota.dart';
import 'package:bloc_notas/bloc-notas/services/crud_nota/crud_services_nota.dart';
import 'package:bloc_notas/bloc-notas/widgets/drawer/drawer_cifrado/cifrar_nota.dart';
import 'package:bloc_notas/bloc-notas/widgets/drawer/drawer_create_nota/create_nota/insert_create_nota.dart';
import 'package:bloc_notas/bloc-notas/widgets/drawer/drawer_create_nota/update_nota/update_nota.dart';
import 'package:flutter/material.dart';

class DrawerHomeEscreens extends StatefulWidget {
  const DrawerHomeEscreens({super.key});

  @override
  State<DrawerHomeEscreens> createState() => _HomeEscreensState();
}

class _HomeEscreensState extends State<DrawerHomeEscreens> {
  late TextEditingController _id;
  late TextEditingController _nameNota;
  final TextEditingController _password = TextEditingController();

  late ServicesNotesqLite noteLite;
  late ServicesNotesqLitecifrado noteLitecifrado;

  int idAxuliar = 0;
  String nomaNota = '';

  @override
  void initState() {
    super.initState();
    _id = TextEditingController();
    _id.text = idAxuliar.toString();
    _nameNota = TextEditingController();
    _nameNota.text = nomaNota;

    setState(() {
      noteLite =
          ServicesNotesqLite(note: Note(id: 0, userName: '', content: ''));
      noteLitecifrado = ServicesNotesqLitecifrado(
          pageNota: Pagenotacifrado(
              id: 0, password: '', date: '', title: '', idnota: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Listar Notas'),
        ),
      ),
      drawer: _buildDrawer(
        context,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.all(5),
        child: CustomScrollView(
          slivers: [_buildListarNotascreadas(context)],
        ),
      ),
    );
  }

  //Drawer Menu de opciones
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(207, 255, 255, 255),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF274754),
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            height: 200,
            child: const Icon(
              Icons.note_add_outlined,
              color: Colors.white,
              size: 80,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const InsertCreateNota(),
                  ));
                },
                child: const Text(
                  'crear Nota',
                  style: TextStyle(color: Color(0XFF2a9d90)),
                )),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CifrarNota(),
                  ));
                },
                child: const Text(
                  'cifrar Nota',
                  style: TextStyle(color: Color(0XFF2a9d90)),
                )),
          )
        ],
      ),
    );
  }

  //Listar Notas creadas.
  Widget _buildListarNotascreadas(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          FutureBuilder(
            future: noteLitecifrado.getNotescifradas(),
            builder: (context, snapshotCifrado) {
              return FutureBuilder<List<Note>>(
                future: noteLite.getNotes(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting) &&
                      (snapshotCifrado.connectionState ==
                          ConnectionState.waiting)) {
                    return const CircularProgressIndicator();
                  } else if ((snapshot.hasError) &&
                      (snapshotCifrado.hasError)) {
                    return const Text('Error no hay respuesta del server !');
                  } else {
                    List<Note>? listNotas = snapshot.data;
                    List<Pagenotacifrado>? listNotascifradas =
                        snapshotCifrado.data;
                    if (listNotas == null || listNotas.isEmpty) {
                      return const Text('No hay notas creadas');
                    }
                    return SizedBox(
                      width: 400,
                      height: 500,
                      child: ListView.builder(
                        itemCount: listNotas.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 0,
                                          left: 20,
                                          right: 0,
                                          bottom: 0),
                                      child: Text(listNotas[index].userName)),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 0,
                                          left: 20,
                                          right: 0,
                                          bottom: 0),
                                      child:
                                          Text(listNotas[index].id.toString())),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _builShowDialogDelete(
                                          context, listNotas[index].id);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _id.text =
                                            listNotas[index].id.toString();
                                        _nameNota.text =
                                            listNotas[index].userName;
                                      });

                                      Note updateNotanew = Note(
                                          id: listNotas[index].id,
                                          userName: listNotas[index].userName,
                                          content: listNotas[index].content);

                                      bool existe = listNotascifradas!.any(
                                          (element) =>
                                              element.id ==
                                              listNotas[index].id);
                                      if (existe) {
                                        _builShowDialogCifrarNota(
                                            context,
                                            listNotascifradas[index].password,
                                            updateNotanew);
                                        print('Nota cifrada');
                                      } else {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => UpdateNota(
                                              updateNota: updateNotanew),
                                        ));
                                        print('Nota no cifrada');
                                      }
                                    },
                                    icon: const Icon(Icons.edit_document),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _id.text =
                                            listNotas[index].id.toString();
                                        _nameNota.text =
                                            listNotas[index].userName;
                                      });

                                      Note updateNotanew = Note(
                                          id: listNotas[index].id,
                                          userName: listNotas[index].userName,
                                          content: listNotas[index].content);

                                      bool existe = listNotascifradas!.any(
                                          (element) =>
                                              element.id ==
                                              listNotas[index].id);
                                      if (existe) {
                                        _builShowDialogCifrarNotavistaprevia(
                                            context,
                                            listNotascifradas[index].password,
                                            updateNotanew);
                                        print('Nota cifrada');
                                      } else {
                                        _builShowDialogVistaPrevianota(
                                            context, listNotas[index].content);
                                      }
                                    },
                                    icon: const Icon(Icons.search_outlined),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  // Vista de nota cifrada!
  void _builShowDialogCifrarNota(
      BuildContext context, passworCifrado, Note nota) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Decifrar Nota',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _id,
                    decoration: const InputDecoration(
                      labelText: 'id',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      enabled: false,
                    ),
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _nameNota,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Nota',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      enabled: false,
                    ),
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Note updateNotanew = Note(
                    id: nota.id,
                    userName: nota.userName,
                    content: nota.content);
                if (_password.text == passworCifrado) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateNota(updateNota: updateNotanew),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta !')));
                }
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //Eliminar ShowDialog
  void _builShowDialogDelete(BuildContext context, idDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text('Eliminar Nota'),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  '¿Seguro decea eliminar esta nota?',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                noteLite.deleteNote(idDelete);
                setState(() {
                  noteLite.getNotes();
                });
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //Vista previa
  void _builShowDialogVistaPrevianota(BuildContext context, nota) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Vista Previa',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  width: 300,
                  height: 300,
                  child: Text(
                    nota,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //cifrado vista previa
  void _builShowDialogCifrarNotavistaprevia(
      BuildContext context, passworCifrado, Note nota) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Decifrar Nota',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _id,
                    decoration: const InputDecoration(
                      labelText: 'id',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      enabled: false,
                    ),
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _nameNota,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Nota',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      enabled: false,
                    ),
                    keyboardType: TextInputType.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Note updateNotanew = Note(
                    id: nota.id,
                    userName: nota.userName,
                    content: nota.content);
                if (_password.text == passworCifrado) {
                  Navigator.of(context).pop();
                  _builShowDialogVistaPrevianota(
                      context, updateNotanew.content);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta !')));
                }
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}