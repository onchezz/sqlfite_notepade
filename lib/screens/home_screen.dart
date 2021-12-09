// import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepad/database/database.dart';
import 'package:notepad/models/enum.dart';
import 'package:notepad/models/note_model.dart';

import 'package:notepad/screens/task_screen.dart';
import 'package:notepad/screens/user.dart';

import 'package:notepad/wigets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Note mynote = Note();
  DatabaseHelper dbHelper = DatabaseHelper();
  late ScrollController _itemcontroller;
  late bool isList;
  late bool isVisble;
  late bool shrinkEffect;
  late bool showFab;
  late bool isTop;
  late bool isheight;

  // Object? _value;

  // late myPopUP _selection;

  // myPopUP _selection = myPopUP.list;

  @override
  void initState() {
    _itemcontroller = ScrollController();
    shrinkEffect = true;
    isList = true;
    isVisble = false;
    showFab = true;
    isTop = true;
    isheight = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double _topPadding = MediaQuery.of(context).padding.top;

    myModal() {
      return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              height: 600,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 20),
            );
          });
    }

    void _shrink() {
      setState(() {
        shrinkEffect = !shrinkEffect;
      });
    }

    void _onChangeList() {
      setState(() {
        isList = !isList;
      });
    }

    scroll() {
      setState(() {
        _itemcontroller.animateTo(
            isTop
                ? _itemcontroller.position.maxScrollExtent
                : _itemcontroller.position.minScrollExtent,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn);
        _shrink();
        isTop = !isTop;
      });
    }

    Widget noteList(var snapshot, int index) {
      return GestureDetector(
        onTap: () async {
          Note updateNote = Note(
            id: snapshot.data[index].id,
            title: snapshot.data[index].title,
            note: snapshot.data[index].note,
          );
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskPage(note: updateNote)))
              .then((value) => setState(() {
                    isVisble = false;

                    // _itemcontroller.animateTo(
                    //     _itemcontroller.position.maxScrollExtent,
                    //     duration: const Duration(seconds: 1),
                    //     curve: Curves.fastOutSlowIn);
                  }));
          setState(() {
            isVisble = false;
          });
        },
        onLongPress: () {
          setState(() {
            isVisble = true;
          });
        },
        child: NoteCard(
          child: Stack(
            children: [
              Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (snapshot.data[index].title == null)
                          ? RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: snapshot.data[index].note.toString(),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 24.0,
                                ),
                              ),
                            )
                          : RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: snapshot.data[index].title.toString(),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                      (snapshot.data[index].note == null)
                          ? RichText(
                              maxLines: 1,
                              text: TextSpan(
                                text: 'No note Added',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 14.0,
                                ),
                              ))
                          : RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: '${snapshot.data[index].note}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 18.0,
                                ),
                              ))
                    ],
                  ),
                ],
              ),
              Visibility(
                visible: isVisble,
                child: Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () async {
                          await dbHelper.deleteNote(snapshot.data[index].id);
                          setState(() {
                            isVisble = false;
                          });
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          size: 28.0,
                          color: Colors.red,
                        ))),
              )
            ],
          ),
        ),
      );
    }

    _future() {
      return FutureBuilder(
          future: dbHelper.getNotes(),
          initialData: const [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if (snapshot.data.length >= 8) {
            //   isheight = true;
            //   print('eight reached');
            // }
            if (snapshot.data != null) {
              if (snapshot.data.length <= 0) {
                showFab = false;
                isheight = false;
              }

              Widget mine = Expanded(
                  child: isList
                      ? ListView.builder(
                          controller: _itemcontroller,
                          shrinkWrap: true,
                          // reverse: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            // if (snapshot.data[index].id < 8) {
                            //   showFab = true;
                            // }

                            return noteList(snapshot, index);
                          })
                      : StaggeredGridView.countBuilder(
                          controller: _itemcontroller,
                          itemCount: snapshot.data.length,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          // reverse: true,
                          itemBuilder: (BuildContext context, index) {
                            // if ((snapshot.data[index].id < 8)) {
                            //   showFab = true;
                            // }
                            return noteList(snapshot, index);
                          },
                          staggeredTileBuilder: (index) => StaggeredTile.extent(
                              1, snapshot.data[index].note == null ? 100 : 150),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                      opacity: shrinkEffect ? 1 : 0,
                      duration: const Duration(milliseconds: 600),
                      // visible: shrinkEffect,
                      child: Text(
                          (snapshot.data.length <= 0)
                              ? ''
                              :
                              // shrinkEffect
                              //     ?
                              (snapshot.data.length == 1)
                                  ? '${snapshot.data.length} note'
                                  : '${snapshot.data.length} notes'
                          // : ''
                          ,
                          style: const TextStyle(fontSize: 14))),
                  (snapshot.data.length <= 0)
                      ? const Center(
                          child: Text('no items'),
                        )
                      : NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            if (notification.direction ==
                                ScrollDirection.reverse) {
                              setState(() {
                                shrinkEffect = false;
                                showFab = false;
                              });
                            } else if (notification.direction ==
                                ScrollDirection.forward) {
                              setState(() {
                                shrinkEffect = true;
                                showFab = true;
                              });
                            } else if (_itemcontroller
                                    .position.maxScrollExtent ==
                                _itemcontroller.offset) {
                              setState(() {
                                showFab = true;
                                isTop = !isTop;
                                isheight = true;
                              });
                            } else if (_itemcontroller
                                    .position.minScrollExtent ==
                                _itemcontroller.initialScrollOffset) {
                              setState(() {
                                isTop = true;
                                isheight = false;
                              });
                            }

                            return true;
                          },
                          child: mine,

                          // Expanded(
                          //     child: isList
                          //         ? ListView.builder(
                          //             controller: _itemcontroller,
                          //             shrinkWrap: true,
                          //             // reverse: true,
                          //             itemCount: snapshot.data.length,
                          //             itemBuilder: (context, index) {
                          //               return noteList(snapshot, index);
                          //             })
                          //         : StaggeredGridView.countBuilder(
                          //             controller: _itemcontroller,
                          //             itemCount: snapshot.data.length,
                          //             crossAxisCount: 2,
                          //             shrinkWrap: true,
                          //             // reverse: true,
                          //             itemBuilder:
                          //                 (BuildContext context, int index) {
                          //               return noteList(snapshot, index);
                          //             },
                          //             staggeredTileBuilder: (int index) =>
                          //                 StaggeredTile.extent(
                          //                     1,
                          //                     snapshot.data[index].note == null
                          //                         ? 100
                          //                         : 150),
                          //             mainAxisSpacing: 10,
                          //             crossAxisSpacing: 10,
                          //           )

                          //     // GridView.builder(
                          //     //     controller: _itemcontroller,
                          //     //     gridDelegate:
                          //     //         const SliverGridDelegateWithFixedCrossAxisCount(
                          //     //       crossAxisCount: 2,
                          //     //       crossAxisSpacing: 10,
                          //     //     ),
                          //     //     itemCount: snapshot.data.length,
                          //     //     itemBuilder:
                          //     //         (BuildContext context, int index) {
                          //     //       return noteList(snapshot, index);
                          //     //     },
                          //     //   ),
                          //     ),
                        ),
                ],
              );
            } else {
              return const Center(
                child: Text('loading ...'),
              );
            }
          });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: myModal,
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 38,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 38,
              color: Colors.black,
            ),
            onSelected: (result) {},
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                // value: myPopUP.user,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [Icon(Icons.person), Text('user')],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [Icon(Icons.list), Text('list')],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: const [Icon(Icons.settings), Text('settings')],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          // top: _topPadding,
          left: 12,
          right: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedDefaultTextStyle(
                curve: Curves.linearToEaseOut,
                child: const Text.rich(TextSpan(
                  text: 'Notes',
                )),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: shrinkEffect ? 40 : 24,
                ),
                duration: const Duration(seconds: 1)),
            Expanded(
              child: _future(),
            )
          ],
        ),
      ),
      floatingActionButton: showFab
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              // onOpen: _shrink,
              onClose: () {
                showFab = true;
              },
              overlayOpacity: 0.2,
              children: [
                (isheight)
                    ? SpeedDialChild(
                        label: isTop ? 'last note' : 'first note',
                        onTap: () {
                          scroll();
                        },
                        child: isTop
                            ? const Icon(Icons.arrow_downward_outlined)
                            : const Icon(Icons.arrow_upward_outlined),
                      )
                    : SpeedDialChild(),
                SpeedDialChild(
                  label: isList ? 'grid view' : 'list view',
                  onTap: _onChangeList,
                  child: isList
                      ? const Icon(Icons.grid_on)
                      : const Icon(Icons.list),
                ),
                SpeedDialChild(
                  label: 'add note',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TaskPage(
                                  note: null,
                                ))).then((value) => {
                          setState(
                            () {},
                          ),
                        });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : null,
    );
  }
}
