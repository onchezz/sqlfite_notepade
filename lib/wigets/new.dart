//  GestureDetector(
//                                       onTap: () async {
//                                         Note updateNote = Note(
//                                           id: snapshot.data[index].id,
//                                           title: snapshot.data[index].title,
//                                           note: snapshot.data[index].note,
//                                         );
//                                         Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         TaskPage(
//                                                             note: updateNote)))
//                                             .then((value) => setState(() {
//                                                   isVisble = false;

//                                                   _itemcontroller.animateTo(
//                                                       _itemcontroller.position
//                                                           .maxScrollExtent,
//                                                       duration: const Duration(
//                                                           seconds: 1),
//                                                       curve:
//                                                           Curves.fastOutSlowIn);
//                                                 }));
//                                         setState(() {
//                                           isVisble = false;
//                                         });
//                                       },
//                                       onLongPress: () {
//                                         setState(() {
//                                           isVisble = true;
//                                         });
//                                       },
//                                       child: NoteCard(
//                                         child: Stack(
//                                           children: [
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 (snapshot.data[index].title ==
//                                                         null)
//                                                     ? RichText(
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         text: TextSpan(
//                                                           text: snapshot
//                                                               .data[index].note
//                                                               .toString(),
//                                                           style: TextStyle(
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.9),
//                                                             fontSize: 24.0,
//                                                           ),
//                                                         ),
//                                                       )
//                                                     : RichText(
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         text: TextSpan(
//                                                           text: snapshot
//                                                               .data[index].title
//                                                               .toString(),
//                                                           style: TextStyle(
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.9),
//                                                             fontSize: 24.0,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                 (snapshot.data[index].note ==
//                                                         null)
//                                                     ? RichText(
//                                                         maxLines: 1,
//                                                         text: TextSpan(
//                                                           text: 'No note Added',
//                                                           style: TextStyle(
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.7),
//                                                             fontSize: 14.0,
//                                                           ),
//                                                         ))
//                                                     : RichText(
//                                                         maxLines: 3,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         text: TextSpan(
//                                                           text:
//                                                               '${snapshot.data[index].note}',
//                                                           style: TextStyle(
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.7),
//                                                             fontSize: 18.0,
//                                                           ),
//                                                         ))
//                                               ],
//                                             ),
//                                             Visibility(
//                                               visible: isVisble,
//                                               child: Positioned(
//                                                   top: 0,
//                                                   right: 0,
//                                                   child: IconButton(
//                                                       onPressed: () async {
//                                                         await dbHelper
//                                                             .deleteNote(snapshot
//                                                                 .data[index]
//                                                                 .id);
//                                                         setState(() {
//                                                           isVisble = false;
//                                                         });
//                                                       },
//                                                       icon: const Icon(
//                                                         Icons.delete_forever,
//                                                         size: 28.0,
//                                                         color: Colors.red,
//                                                       ))),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     );
                                 