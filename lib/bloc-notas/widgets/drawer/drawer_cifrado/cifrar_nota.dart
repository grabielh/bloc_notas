// ignore_for_file: use_build_context_synchronously

import 'package:bloc_notas/bloc-notas/dominio/models/model_note/models_nota.dart';
import 'package:bloc_notas/bloc-notas/dominio/models/models_page/models_page.dart';
import 'package:bloc_notas/bloc-notas/services/crud_cifrado_nota/crud_cifrado_nota.dart';

import 'package:bloc_notas/bloc-notas/services/crud_nota/crud_services_nota.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CifrarNota extends StatefulWidget {
  const CifrarNota({super.key});

  @override
  State<CifrarNota> createState() => _CifrarNotaState();
}

class _CifrarNotaState extends State<CifrarNota> {
  late TextEditingController _id;
  late TextEditingController _nameNota;
  final TextEditingController _passwordOne = TextEditingController();
  final TextEditingController _passwordTwo = TextEditingController();

  final ServicesNotesqLite noteLite =
      ServicesNotesqLite(note: Note(id: 0, userName: '', content: ''));

  late ServicesNotesqLitecifrado noteLitecifrado;

  String nombre = '';
  int idNota = 0;
  DateTime newDate = DateTime.now();
  DateFormat dd = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();

    setState(() {
      noteLitecifrado = ServicesNotesqLitecifrado(
          pageNota: Pagenotacifrado(
              id: 0, password: '', date: '', title: '', idnota: 0));
    });

    _id = TextEditingController();
    _id.text = idNota.toString();

    _nameNota = TextEditingController();
    _nameNota.text = nombre;
  }

  void _saveNoteDatacifrado() async {
    try {
      if (_id.text.isNotEmpty &&
          _nameNota.text.isNotEmpty &&
          _passwordOne.text.isNotEmpty &&
          _passwordTwo.text.isNotEmpty) {
        String formattedDate = dd.format(newDate);
        /* Pagenotacifrado pageCifrado = Pagenotacifrado(
            id: idNota,
            password: _passwordOne.text,
            date: formattedDate,
            title: nombre,
            idnota: idNota); */
        noteLitecifrado = ServicesNotesqLitecifrado(
          pageNota: Pagenotacifrado(
              id: idNota,
              password: _passwordOne.text,
              date: formattedDate,
              title: nombre,
              idnota: idNota),
        );
        /* print('Id : ${pageCifrado.id}');
        print('Id : ${pageCifrado.password}');
        print('Fecha : ${pageCifrado.date.toString()}');
        print('Nombre :  ${pageCifrado.title}');
        print('Id password : ${pageCifrado.idnota}'); */

        await noteLitecifrado.save();
        FocusScope.of(context).unfocus();

        Future.delayed(const Duration(seconds: 2));
        setState(() {
          noteLite.getNotes();
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Datos guardados')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complete todos los campos')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ocurrió un error al guardar los datos')));
      print('Error al guardar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Listar Notas'),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.all(5),
        child: CustomScrollView(
          slivers: [
            _buildListarNotascreadas(context),
            _buildListarNotascifradas(context)
          ],
        ),
      ),
    );
  }

  //Listar Notas creadas.
  Widget _buildListarNotascreadas(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          FutureBuilder<List<Note>>(
            future: noteLite.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error no hay respuesta del server !');
              } else {
                List<Note>? listNotas = snapshot.data;
                if (listNotas == null || listNotas.isEmpty) {
                  return const Text('No hay notas creadas');
                }
                return SizedBox(
                  width: 400,
                  height: 600,
                  child: ListView.builder(
                    itemCount: listNotas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(listNotas[index].userName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    nombre = listNotas[index].userName;
                                    _nameNota.text = nombre;
                                    idNota = listNotas[index].id;
                                    _id.text = idNota.toString();

                                    _builShowDialogCifrarNota(context, index);
                                  },
                                  icon: const Icon(Icons.password)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  void _builShowDialogCifrarNota(
    BuildContext context,
    index,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Cifrar Nota',
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
                    controller: _passwordOne,
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
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _passwordTwo,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_passwordOne.text != _passwordTwo.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('La contraseña no Coincide!')));
                } else if (_passwordOne.text.isEmpty &&
                    _passwordTwo.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Complete los campo!')));
                } else {
                  _saveNoteDatacifrado();
                  _passwordOne.clear();
                  _passwordTwo.clear();
                  /* ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nota Cifrada !')));
                   */
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _passwordOne.clear();
                _passwordTwo.clear();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //Listar Notas Cifradas
  Widget _buildListarNotascifradas(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          FutureBuilder<List<Pagenotacifrado>>(
            future: noteLitecifrado.getNotescifradas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error no hay respuesta del server !');
              } else {
                List<Pagenotacifrado>? listNotas = snapshot.data;
                if (listNotas == null || listNotas.isEmpty) {
                  return const Text('No hay notas creadas');
                }
                return SizedBox(
                  width: 400,
                  height: 600,
                  child: ListView.builder(
                    itemCount: listNotas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(listNotas[index].id.toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(listNotas[index].title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(listNotas[index].date),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
