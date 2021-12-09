class Note {
  final int? id;
  final String? title;
  final String? note;
  final DateTime? date;

  Note( {this.id, this.title, this.note, this.date,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date.toString(),
    };
  }
}
