import 'package:flutter/material.dart';
import 'package:notepad/database/database.dart';
import 'package:notepad/models/note_model.dart';

class TaskPage extends StatefulWidget {
  final Note? note;

  const TaskPage({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
 
  late FocusNode titleNode;
  late FocusNode noteNode;
  late TextEditingController titleController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    titleNode = FocusNode();
    noteNode = FocusNode();

    titleController = TextEditingController();
    noteController = TextEditingController();
    if (widget.note != null) {
      if (widget.note!.title.toString() != 'null') {
        titleController.text = widget.note!.title.toString().toLowerCase();
      } else {
        titleController.text = 'add title';
      }
      if (widget.note!.note.toString() != 'null') {
        noteController.text = widget.note!.note.toString();
      }
    }
  }

  @override
  void dispose() {
    titleNode.dispose();
    noteNode.dispose();
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: topPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 34,
                      color: Colors.purple,
                    )),
                IconButton(
                    onPressed: () async {
                      if (widget.note == null) {
                        if (titleController.text.isNotEmpty ||
                            noteController.text.isNotEmpty) {
                          DatabaseHelper _insertNote = DatabaseHelper();

                          Note _newNote = Note(
                              title: (titleController.text.isEmpty)
                                  ? null
                                  : titleController.text.toUpperCase(),
                              note: noteController.text.isEmpty
                                  ? null
                                  : noteController.text);
                          await _insertNote.insertNote(_newNote);
                        }
                      } else {
                        if (widget.note!.id != null) {
                          DatabaseHelper _update = DatabaseHelper();
                          Note _updatedNote = Note(
                              id: widget.note!.id,
                              title: titleController.text.toUpperCase(),
                              note: noteController.text);
                          await _update.upDateNotes(_updatedNote);
                        }
                      }
                      Navigator.pop(context);
                      setState(() {
                        titleController.clear();
                        noteController.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.done_rounded,
                      size: 38,
                      color: Colors.purple,
                    )),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 18),
              child: Text('Title',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30, left: 12, right: 12),
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              child: Center(
                child: TextField(
                  focusNode: titleNode,
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(),
                      contentPadding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                      )),
                  onSubmitted: (value) async {
                    noteNode.requestFocus();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Note',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      )),
                  Text('date time'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: bottomPadding,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200),
                child: TextField(
                  maxLines: null,
                  focusNode: noteNode,
                  controller: noteController,
                  onSubmitted: (value) async {
                    titleNode.requestFocus();
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add notes here',
                      contentPadding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
