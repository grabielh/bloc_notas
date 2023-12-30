// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:bloc_notas/bloc-notas/dominio/models/model_note/models_nota.dart';
import 'package:bloc_notas/bloc-notas/services/crud_nota/crud_services_nota.dart';
import 'package:bloc_notas/bloc-notas/widgets/drawer/drawer_homescreens.dart';
import 'package:flutter/material.dart';

class InsertCreateNota extends StatefulWidget {
  const InsertCreateNota({super.key});

  @override
  State<InsertCreateNota> createState() => _InsertCreateNotaState();
}

class _InsertCreateNotaState extends State<InsertCreateNota> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _content = TextEditingController();
  late ServicesNotesqLite noteLite;

  @override
  void initState() {
    super.initState();
    noteLite = ServicesNotesqLite(note: Note(id: 0, userName: '', content: ''));
    asignarPrymarykey();
  }

// asignar id unico
  void asignarPrymarykey() async {
    int id = int.tryParse(_id.text) ?? 1;
    List<Note> listaNotas = await noteLite.getNotes();
    bool existe = listaNotas.any((element) => element.id == id);
    if (existe) {
      int newID = id;
      while (listaNotas.any((element) => element.id == newID)) {
        newID++;
      }
      setState(() {
        _id.text = newID.toString(); // Actualizar el valor del campo _id.text
      });
    }
  }

  void _saveNoteData() async {
    try {
      if (_name.text.isNotEmpty && _content.text.isNotEmpty) {
        int id = int.tryParse(_id.text) ?? 1;
        String name = _name.text;
        String content = _content.text;
        noteLite = ServicesNotesqLite(
            note: Note(id: id, userName: name, content: content));

        await noteLite.save();
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
          child: Text('Crear Nota'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          width: 400,
          child: CustomScrollView(
            slivers: [
              _buildcreanotaCamposentrada(context),
              _builBotonCreanota(context, _id, _name, _content)
            ],
          ),
        ),
      ),
    );
  }

  //Crear nota
  Widget _buildcreanotaCamposentrada(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: 100,
                child: TextField(
                  controller: _id,
                  decoration: const InputDecoration(
                      labelText: 'id',
                      labelStyle: TextStyle(color: Colors.white)),
                  keyboardType: TextInputType.number,
                  enabled: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                width: 150,
                child: TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                      labelText: 'Nombre',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white)),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: 300,
            child: TextField(
              controller: _content,
              decoration: const InputDecoration(
                  labelText: 'Escriba una nota .......',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelStyle: TextStyle(color: Colors.white)),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  //Boton "Crear nota"
  Widget _builBotonCreanota(BuildContext context, TextEditingController id,
      TextEditingController name, TextEditingController content) {
    return SliverToBoxAdapter(
      child: Container(
        width: 400,
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () async {
            _saveNoteData();
            await Future.delayed(const Duration(seconds: 1));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DrawerHomeEscreens(),
            ));
          },
          child: const Text(
            'Crea nota',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
