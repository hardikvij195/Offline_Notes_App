import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scc_offline_notes_app/NotesModel.dart';
import 'package:scc_offline_notes_app/SharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesDashboard extends StatefulWidget {
  @override
  _NotesDashboardState createState() => _NotesDashboardState();
}

class _NotesDashboardState extends State<NotesDashboard> {
  TextEditingController textEditingController1 = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();

  List<Notes> notesList = List<Notes>();

  Future<void> NoteAdded(Notes notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notesList.add(notes);
    // for (int i = 0; i < notesList.length; i++) {
    //   print(notesList[i].NoteTitle);
    // }
    final String encodedData = Notes.encodeTasks(notesList);
    prefs.setString("notes", encodedData);
  }

  //GETTING LIST OF ALL TASK
  Future<List<Notes>> getStringValuesSF(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(id) ?? '';

    setState(() {
      notesList = Notes.decodeTasks(stringValue);
    });

    return notesList;
  }

  @override
  void initState() {
    // TODO: implement initState
    getStringValuesSF("notes");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),

                TextField(
                  controller: textEditingController1,
                  decoration: InputDecoration(hintText: "Note Title"),
                ),

                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: textEditingController2,
                  decoration: InputDecoration(hintText: "Note Desc"),
                ),

                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      var now = new DateTime.now();
                      var format = new DateFormat('yyyyMMddHHmmss');
                      String Id = format.format(now);
                      print("Id -- " + Id);
                      Notes nt = new Notes(
                          NoteId: Id,
                          NoteTitle: textEditingController1.text.trim(),
                          NoteDesc: textEditingController2.text.trim());
                      NoteAdded(nt);
                    });
                  },
                  color: Colors.indigo,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // RaisedButton(
                //   onPressed: (){
                //
                //
                //     String note = getStringValuesSF('1').toString();
                //     print("Note Name - " + note);
                //
                //   },
                //   color: Colors.indigo,
                //   child: Text("Get" , style: TextStyle(color: Colors.white),),
                // ),

                Expanded(
                  child: notesList.length != 0
                      ? ListView.builder(
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            return item(notesList[index]);
                          },
                        )
                      : Center(
                          child: Text("No Note Present"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget item(Notes notes) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.assignment, size: 45),
            title: Text(notes.NoteTitle),
            subtitle: Text(notes.NoteDesc),
          ),
        ],
      ),
    );
  }
}
