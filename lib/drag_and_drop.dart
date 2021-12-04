import 'package:dndmodule/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({Key? key}) : super(key: key);
  static const double boardWidth = 300;

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
        listWidth: DragAndDrop.boardWidth,
        listDraggingWidth: DragAndDrop.boardWidth,
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
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(7),
          ),
        ),
        children: tasks,
        header: Container(
          width: DragAndDrop.boardWidth,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(7),
              ),
              color: Colors.black12),
          padding: const EdgeInsets.all(10),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        leftSide: const VerticalDivider(
          color: Colors.transparent,
          width: 5,
          thickness: 5,
        ),
        rightSide: const VerticalDivider(
          color: Colors.transparent,
          width: 5,
          thickness: 5,
        ),
        footer: Container(
          color: Colors.transparent,
          height: 5,
        ),
        lastTarget: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.all(5),
          alignment: AlignmentDirectional.center,
          child: buildAddButton(name),
        ),
      );

  buildItem(String item) => DragAndDropItem(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(5),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        customTitleTask(item),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                          child: customTitleTask(item),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.account_circle_outlined),
                    ),
                  ],
                ),
                Text(
                  item +
                      item +
                      item +
                      item +
                      item +
                      item +
                      item +
                      item +
                      item +
                      item +
                      item,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                  child: const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.access_time),
                        Text('dd-mm-yyyy'),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.comment_outlined),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  buildTasks(int length) => List<DragAndDropItem>.generate(
        length,
        (index) => buildItem('Task $index'),
      );

  customTitleTask(String text) => Container(
        margin: const EdgeInsets.all(4),
        // padding: EdgeInsets.only(left: 5),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      );

  buildAddButton(String board) => IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.add),
        color: Colors.red,
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
