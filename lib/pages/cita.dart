
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarea/services/firestore.dart';

class CitaPage extends StatefulWidget {
  final String? docID;
  final String? initialNote;
  final String? initialCentro;
  final String? initialEstado;
  final bool? initialImportante;

  const CitaPage({
    super.key,
    this.docID,
    this.initialNote,
    this.initialCentro,
    this.initialEstado,
    this.initialImportante,
  });

  @override
  State<CitaPage> createState() => _CitaPageState();
}

class _CitaPageState extends State<CitaPage> {
  final Servicios firebaseService = Servicios();
  final TextEditingController textController = TextEditingController();
  final TextEditingController centroController = TextEditingController();
  String estado = 'creado';
  bool importante = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      textController.text = widget.initialNote!;
    }
    if (widget.initialCentro != null) {
      centroController.text = widget.initialCentro!;
    }
    if (widget.initialEstado != null) {
      estado = widget.initialEstado!;
    }
    if (widget.initialImportante != null) {
      importante = widget.initialImportante!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar Cita", style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () {
              if (widget.docID == null) {
                firebaseService.addNote(
                  textController.text,
                  centroController.text,
                  estado,
                  importante,
                );
              } else {
                firebaseService.updateNote(
                  widget.docID!,
                  textController.text,
                  centroController.text,
                  estado,
                  importante,
                );
              }
              context.pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Seleccione un centro médico", style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            DropdownButtonFormField<String>(
              value: centroController.text.isNotEmpty
                  ? centroController.text
                  : null,
              onChanged: (String? newValue) {
                setState(() {
                  centroController.text = newValue!;
                });
              },
              items: <String>[
                'Clinica Norte',
                'Clinica Sur',
                'Clinica Occidente',
                'Clinica Oriente'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.black, fontFamily: 'Roboto')),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Seleccione un centro médico',
                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Fecha", style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Escriba la fecha', hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto')),
            ),
            const SizedBox(height: 16.0),
            const Text("Jornada", style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            DropdownButtonFormField<String>(
              value: estado.isNotEmpty ? estado : null,
              onChanged: (String? newValue) {
                setState(() {
                  estado = newValue!;
                });
              },
              items: <String>['creado', 'por hacer', 'trabajando', 'finalizado']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.black, fontFamily: 'Roboto')),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Seleccione la jornada',
                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Reservar un doctor para tu cita", style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            CheckboxListTile(
              value: importante,
              onChanged: (bool? newValue) {
                setState(() {
                  importante = newValue!;
                });
              },
              title: const Text('Importante', style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Agrega lógica para buscar doctor
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text('Buscar doctor', style: TextStyle(color: Colors.black, fontFamily: 'Roboto')),
            ),
          ],
        ),
      ),
    );
  }
}
