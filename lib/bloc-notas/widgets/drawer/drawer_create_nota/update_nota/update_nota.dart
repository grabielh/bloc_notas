// ignore_for_file: use_build_context_synchronously

import 'package:bloc_notas/bloc-notas/dominio/models/model_note/models_nota.dart';
import 'package:bloc_notas/bloc-notas/services/crud_nota/crud_services_nota.dart';
import 'package:flutter/material.dart';

import '../../drawer_homescreens.dart';

class UpdateNota extends StatefulWidget {
  final Note updateNota;
  const UpdateNota({Key? key, required this.updateNota}) : super(key: key);

  @override
  State<UpdateNota> createState() => _UpdateNotaState();
}

class _UpdateNotaState extends State<UpdateNota> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _content = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores de texto con los valores existentes de la nota
    _id.text = widget.updateNota.id.toString();
    _name.text = widget.updateNota.userName;
    _content.text = widget.updateNota.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Actualizar Nota'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          width: 400,
          child: CustomScrollView(
            slivers: [
              _buildActualizaNotaCamposEntrada(context, _id, _name, _content),
              _builBotonCreanota(context, _id, _name, _content),
            ],
          ),
        ),
      ),
    );
  }

//Crear nota
  Widget _buildActualizaNotaCamposEntrada(
      BuildContext context,
      TextEditingController id,
      TextEditingController name,
      TextEditingController content) {
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
                  controller: id,
                  decoration: const InputDecoration(
                      labelText: 'id',
                      labelStyle: TextStyle(color: Colors.white)),
                  enabled: false,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                width: 150,
                child: TextField(
                  controller: name,
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
            //color: Colors.white,
            padding: const EdgeInsets.all(5),
            width: 300,
            height: 200,
            child: TextField(
              controller: content,
              decoration: const InputDecoration(
                labelText: 'Escriba una nota .......',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
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
            int? id = int.tryParse(_id.text);
            Note newNota =
                Note(id: id!, userName: name.text, content: content.text);
            if (newNota.id != id ||
                newNota.content.isEmpty ||
                newNota.userName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete los campos')));
            } else {
              ServicesNotesqLite noteLite = ServicesNotesqLite(note: newNota);
              noteLite.save();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota Actualizada!')));
              await Future.delayed(const Duration(seconds: 1));

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DrawerHomeEscreens(),
              ));
            }
          },
          child: const Text(
            'Actualizar nota',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
