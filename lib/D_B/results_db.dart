
import 'package:project_app/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultsDatabase {
  final table = Supabase.instance.client.from('quiz_results');
  final authService = AuthService();

  Future<void> insertResult(int total, int correct, int incorrect, {String note = 'No note'}) async {
    final uid = authService.getCurrentUserUid();
    if (uid == null) {
      throw Exception('No user signed in');
    }
    await table.insert({
      'uid': uid,
      'total_questions': total,
      'correct': correct,
      'incorrect': incorrect,
      'note': note,
    });
  }

  Future<void> updateNote(dynamic id, String note) async {
    await table.update({'note': note}).eq('id', id);
  }

  Future<void> deleteResult(dynamic id) async {
    await table.delete().eq('id', id);
  }

  Stream<dynamic> getResultsStream() {
    return table.stream(primaryKey: ['id']);
  }
}
