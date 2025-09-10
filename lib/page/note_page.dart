
import 'package:http/http.dart';
import 'package:project_app/D_B/notes.dart';
import 'package:flutter/material.dart';

import 'package:project_app/const/colors.dart';                    // <-- যদি blue color const থেকে নাও

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _noteController = TextEditingController();
  final notesdb = NotesDatabase();                                   // access paici notes databaee

  void addNewNotes() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              //alert dialog mane dialog box show korbe
              title: Text("Add New Note"),
              content: TextField(
                controller: _noteController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);                        //navigator.pop mane cancel hoye jabe context ta
                      _noteController.clear();                       //note controller cole jabe
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      //akn save er kaj
                      try {
                        final newNote = _noteController.text;
                        await notesdb
                            .createNotes(_noteController.text);      //notesdb er acces pabo karon obj create korar jonoo

                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                              SnackBar(content: Text("Insertion done")));
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error :$e")));
                        }
                      }
                    },
                    child: Text("Save")),
              ],
            )
            );
  }

  void updateNotes(dynamic id,String oldcontent){
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
              //alert dialog mane dialog box show korbe
              title: Text("Update note"),
              content: TextField(
                controller: _noteController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);                        //navigator.pop mane cancel hoye jabe context ta
                      _noteController.clear();                       //note controller cole jabe
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      //akn save er kaj
                      try {
                        // final updateNote =_noteController.text;
                        await notesdb.updateNotes(id, _noteController.text);     //notesdb er acces pabo karon obj create korar jonoo

                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                              SnackBar(content: Text("Updation done")));
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error :$e")));
                        }
                      }
                    },
                    child: Text("Save")),
              ],
            )
            );
  }

  void deleteNotes(dynamic id)async{
    try{
      await notesdb.deleteNotes(id);
       if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                              SnackBar(content: Text("Deletion done")));
                        }

    }catch(e){
       if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                              SnackBar(content: Text("Error :$e")));
                        }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 160, 184, 255),                                       // <-- CHANGED: Background color blue
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(color: Color.fromARGB(255, 15, 54, 230)),                   // <-- CHANGED: Title white
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 160, 184, 255),                                     // <-- Optional: AppBar background same blue
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: addNewNotes, child: Icon(Icons.add)),
          body: StreamBuilder(stream: notesdb.table.stream(primaryKey: ['id']),
           builder: (context,snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            final notes = snapshot.data!;  //amr j data paci oita store kore rakce
            return ListView.builder(
              itemCount: notes.length,                   //integer type er vaue pass kori
              itemBuilder: (context,index){
                final note = notes[index];        //prottek ta data er index  pass korlam
                final id=note['id'];            //column pass korlam every column
                final content =note['content'];

                return Card(
                  child: ListTile(
                    leading: Text("$id"),
                    title: Text(content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          deleteNotes(id);
                        }, icon: Icon(Icons.delete)),
                        IconButton(onPressed: (){
                          updateNotes(id, content);
                        }, icon: Icon(Icons.edit)),
                      ],
                    ),
                  
                  ),
                ); 

                


              });  //item re list onujai build kore
           }),
    );
  }
}
