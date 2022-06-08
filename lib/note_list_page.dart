import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_db/db_provider.dart';
import 'package:local_db/note_add_update_page.dart';
import 'package:provider/provider.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List colors = [
    const Color.fromARGB(255, 255, 174, 169),
    const Color.fromARGB(255, 196, 255, 198),
    const Color.fromARGB(255, 255, 250, 205),
    const Color.fromARGB(255, 180, 221, 255)
  ];

  Random random = new Random();

  int indexx = 0;

  void changeIndex() {
    setState(
      () => indexx = random.nextInt(4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          final notes = provider.notes;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  color: colors[indexx],
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(note.title),
                        subtitle: Text(note.description),
                        onTap: () async {
                          final selectedNote =
                              await provider.getNoteById(note.id!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NoteAddUpdatePage();
                              },
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(child: const SizedBox()),
                          IconButton(
                            onPressed: () {
                              provider.deleteNote(note.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    '${note.title} dihapus',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                // return Dismissible(
                //   key: Key(note.id.toString()),
                //   background: Container(color: Colors.red),
                //   onDismissed: (direction) {
                //     provider.deleteNote(note.id!);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     backgroundColor: Colors.red,
                //     content: Text(
                //       'Telah dihapus',
                //       textAlign: TextAlign.center,
                //     ),
                //     duration: Duration(seconds: 1),
                //   ),
                // );
                //   },
                //   child: Card(
                //     child: ListTile(
                //       title: Text(note.title),
                //       subtitle: Text(note.description),
                //       onTap: () async {
                //         final selectedNote =
                //             await provider.getNoteById(note.id!);
                //         Navigator.push(context,
                //             MaterialPageRoute(builder: (context) {
                //           return NoteAddUpdatePage();
                //         }));
                //       },
                //     ),
                //   ),
                // );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NoteAddUpdatePage()));
          changeIndex();
        },
      ),
    );
  }
}
