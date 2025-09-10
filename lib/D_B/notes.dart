
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesDatabase{

final table =Supabase.instance.client.from('table_create');     //table pic kore rakci mane table er access pabo.

//insert

Future<void>createNotes(String content)async{  //app run howar por database use kobo so future and table er create  

await table.insert({'content': content});         //multiple column insert korte hole parameter 2 ta add korbo then parameter e , diye add korbo

}

// update er  kaj 

Future<void>updateNotes(dynamic noteId, String content)async{

await table.update({'content': content}).eq('id', noteId);  

}
// retrive page er vitor korbo
// delete

Future<void>deleteNotes(dynamic noteId)async{
  await table.delete().eq('id', noteId);


}

}