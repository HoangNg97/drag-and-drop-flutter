import 'package:dndmodule/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DragAndDropState();
}

class DragAndDropState extends State<DragAndDrop> {
  List<DragAndDropList> boards = [];
  late List<DragAndDropItem> taskBoard;
  late List<DragAndDropItem> doingBoard;
  late List<DragAndDropItem> doneBoard;

  @override
  void initState() {
    super.initState();

    taskBoard = buildTasks(2);
    doingBoard = buildTasks(3);
    doneBoard = buildTasks(4);

    boards.add(buildBoard("Task", taskBoard));
    boards.add(buildBoard("Doing", doingBoard));
    boards.add(buildBoard("Done", doneBoard));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Drag and Drop"),
      ),
      body: DragAndDropLists(
        scrollController: ScrollController(),
        axis: Axis.horizontal,
        listPadding: const EdgeInsets.all(5.0),
        listWidth: 200,
        listDraggingWidth: 200,
        onListReorder: (int oldListIndex, int newListIndex) {
          setState(() {
            var movedList = boards.removeAt(oldListIndex);
            boards.insert(newListIndex, movedList);
          });
        },
        onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex,
            int newListIndex) {
          setState(() {
            var movedItem =
                boards[oldListIndex].children.removeAt(oldItemIndex);
            boards[newListIndex].children.insert(newItemIndex, movedItem);
          });
        },
        children: boards,
        lastListTargetSize: 0,
        lastItemTargetHeight: 0,
      ),
    );
  }

  buildBoard(String name, List<DragAndDropItem> tasks) => DragAndDropList(
      children: tasks,
      header: Container(
        width: 200,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(7),
            ),
            color: Colors.redAccent),
        padding: const EdgeInsets.all(20),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      leftSide: const VerticalDivider(
        color: Colors.redAccent,
        width: 5,
        thickness: 5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.redAccent,
        width: 5,
        thickness: 5,
      ),
      footer: Container(
        color: Colors.redAccent,
        height: 5,
      ),
      lastTarget: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadiusDirectional.circular(5),
        ),
        alignment: AlignmentDirectional.center,
        child: buildAddButton(name),
      ));

  buildItem(String item) => DragAndDropItem(
        child: Card(
          color: Colors.black12,
          child: ListTile(
            title: Text(
              item,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      );

  buildTasks(int length) => List<DragAndDropItem>.generate(
        length,
        (index) => buildItem('Task $index'),
      );

  buildAddButton(String board) => IconButton(
        icon: const Icon(Icons.add),
        color: Colors.black,
        onPressed: () {
          setState(() {
            late List<DragAndDropItem> children;
            if (board == 'Task') {
              children = taskBoard;
            } else if (board == 'Doing') {
              children = doingBoard;
            } else {
              children = doneBoard;
            }
            children.add(buildItem('Task ${children.length}'));
          });
        },
      );
}
