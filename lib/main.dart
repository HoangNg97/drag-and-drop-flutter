import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DragAndDrop()));
}

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DragAndDropState();
}

class DragAndDropState extends State<DragAndDrop> {
  List<DragAndDropList> list = [];

  @override
  void initState() {
    super.initState();
    list.add(buildBoard("Task", buildTasks(3)));
    list.add(buildBoard("Doing", buildTasks(4)));
    list.add(buildBoard("Done", buildTasks(7)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Drag and Drop"),
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(),
        itemBuilder: (context, itemIndex) => DragAndDropLists(
          axis: Axis.horizontal,
          listPadding: const EdgeInsets.all(5.0),
          listWidth: 200,
          listDraggingWidth: 200,
          onListReorder: (int oldListIndex, int newListIndex) {
            setState(() {
              var movedList = list.removeAt(oldListIndex);
              list.insert(newListIndex, movedList);
            });
          },
          onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex,
              int newListIndex) {
            setState(() {
              var movedItem =
                  list[oldListIndex].children.removeAt(oldItemIndex);
              list[newListIndex].children.insert(newItemIndex, movedItem);
            });
          },
          children: list,
        ),
      ),
      // body: DragAndDropLists(
      //   axis: Axis.horizontal,
      //   listPadding: const EdgeInsets.all(5.0),
      //   listWidth: 200,
      //   listDraggingWidth: 200,
      //   onListReorder: (int oldListIndex, int newListIndex) {
      //     setState(() {
      //       var movedList = list.removeAt(oldListIndex);
      //       list.insert(newListIndex, movedList);
      //     });
      //   },
      //   onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex,
      //       int newListIndex) {
      //     setState(() {
      //       var movedItem = list[oldListIndex].children.removeAt(oldItemIndex);
      //       list[newListIndex].children.insert(newItemIndex, movedItem);
      //     });
      //   },
      //   children: list,
      // ),
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
        lastTarget: const SizedBox(
          child: Center(
            child: Icon(Icons.add),
          ),
          height: 15,
        ),
      );

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
}
