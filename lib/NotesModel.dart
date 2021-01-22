import 'dart:convert';

class Notes{

  String NoteTitle , NoteDesc , NoteId ;

  Notes({this.NoteTitle , this.NoteDesc , this.NoteId }) ;

  factory Notes.fromJson(Map<String, dynamic> jsonData) {
    return Notes(
      NoteId: jsonData['NoteId'],
      NoteTitle: jsonData['NoteTitle'],
      NoteDesc: jsonData['NoteDesc'],
    );
  }

  static Map<String, dynamic> toMap(Notes task) => {
    'NoteId': task.NoteId,
    'NoteTitle': task.NoteTitle,
    'NoteDesc': task.NoteDesc
  };

  static String encodeTasks(List<Notes> tasks) => json.encode(
    tasks
        .map<Map<String, dynamic>>((task) => Notes.toMap(task))
        .toList(),
  );

  static List<Notes> decodeTasks(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Notes>((item) => Notes.fromJson(item))
          .toList();

}