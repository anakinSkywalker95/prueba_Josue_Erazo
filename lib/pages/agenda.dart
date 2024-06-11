import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tarea/services/firestore.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final Servicios firebaseService = Servicios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda",
            style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/cita');
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                String centro = data['Centro'];
                String estado = data['estado'];
                bool importante = data['importante'];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ListTile(
                    title: Text(noteText,
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Roboto')),
                    subtitle: Text(
                        'Centro: $centro\nEstado: $estado\nImportante: ${importante ? 'Sí' : 'No'}',
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Roboto')),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.go('/cita', extra: {
                                'docID': docID,
                                'initialNote': noteText,
                                'initialCentro': centro,
                                'initialEstado': estado,
                                'initialImportante': importante,
                              });
                            },
                            icon: const Icon(Icons.settings,
                                color: Colors.blueGrey),
                          ),
                          IconButton(
                            onPressed: () => firebaseService.deleteNote(docID),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text('No hay citas',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Roboto')),
              ),
            );
          }
        },
      ),
    );
  }
}
