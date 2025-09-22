import 'package:flutter/material.dart';
import 'package:project_app/D_B/results_db.dart';

class ResultHistoryPage extends StatefulWidget {
  const ResultHistoryPage({super.key});

  @override
  State<ResultHistoryPage> createState() => _ResultHistoryPageState();
}

class _ResultHistoryPageState extends State<ResultHistoryPage> {
  final ResultsDatabase db = ResultsDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Quiz Results"),
        backgroundColor: const Color.fromARGB(255, 160, 184, 255),
        foregroundColor: const Color.fromARGB(255, 15, 54, 230),
        centerTitle: true,
        elevation: 2,
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final r = results[index] as Map<String, dynamic>;
              final id = r['id'];
              final total = r['total_questions'];
              final correct = r['correct'];
              final incorrect = r['incorrect'];
              final note = r['note'] ?? '';
              final dateTime = r['created_at'] != null ? DateTime.parse(r['created_at']).toLocal() : null;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: Text("Score: $correct / $total", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Incorrect: $incorrect"),
                      if (note.isNotEmpty) Text("Note: $note"),
                      if (dateTime != null) Text("Date: ${dateTime.toString().split('.')[0]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Edit Note",
                        onPressed: () => _showEditNoteDialog(context, id, note),
                      ),
                      IconButton(
                         icon: const Icon(Icons.delete, color: Colors.blue),
                        tooltip: "Delete Result",
                        onPressed: () => _confirmDelete(context, id),
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

  void _showEditNoteDialog(BuildContext context, dynamic id, String oldNote) {
    final controller = TextEditingController(text: oldNote);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Note"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await db.updateNote(id, controller.text);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note updated")));
                setState(() {}); // Refresh UI
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this result? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await db.deleteResult(id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Result deleted")));
                setState(() {}); 
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
