

class Note {

  Note(this._id, this._title, this._description, this._date, this._priority);

   int _id;
   String _title;
   String _description;
   String _date;
   int _priority;


  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  set title(String newTitle){
    if(newTitle.length <= 255){
        _title = newTitle;
    }
  }

  set description(String newDescription){
    _description = newDescription;
  }

  set date(String newDate){
    _date = newDate;
  }

  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <= 2){
      _priority = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id, // This will be auto-incremented in the database so you can pass null for new entries
      'title': _title,
      'description': _description,
      'date': _date,
      'priority': _priority,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      map['id'],
      map['title'],
      map['content'],
      map['dateCreated'],
      map['priority'],
    );
  }
}



