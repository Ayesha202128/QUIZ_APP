// project_app/page/result_history_page.dart

import 'package:flutter/material.dart';
import 'package:project_app/D_B/results_db.dart';
import 'package:project_app/D_B/results_db.dart';



class ResultHistoryPage extends StatelessWidget {
  const ResultHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = ResultsDatabase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Quiz Results"),
        backgroundColor: const Color.fromARGB(255, 160, 184, 255),
        foregroundColor: const Color.fromARGB(255, 15, 54, 230),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: db.getResultsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data as List<dynamic>;
          if (results.isEmpty) {
            return const Center(child: Text("No saved results"));
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index] as Map;
              final id = r['id'];
              final total = r['total_questions'];
              final correct = r['correct'];
              final incorrect = r['incorrect'];
              final note = r['note'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text("Score: $correct / $total"),
                  subtitle: Text("Incorrect: $incorrect\nNote: $note"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditNoteDialog(context, db, id, note.toString());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await db.deleteResult(id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Deleted"))
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, ResultsDatabase db, dynamic id, String oldNote) {
    final controller = TextEditingController(text: oldNote);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: "Note")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await db.updateNote(id, controller.text);
              Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note updated")));
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
