import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/main.dart';

class ToDo {
  bool isDone = false; //진행여부
  String title; //할일

  ToDo(this.title, {this.isDone = false});
}

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final _items = <ToDo>[];
  var _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남은 할일'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                RaisedButton(
                  onPressed: () => _addTodo(ToDo(_todoController.text)),
                  color: Colors.blue,
                  child: Text(
                    '추가하기',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 5.0,
              height: 30.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('todo').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasError) {
                  return Text('ERROR');
                } 
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Expanded(
                  child: ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return _buildWidget(document);
                    }).toList(),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidget(DocumentSnapshot doc) {
    final todo = ToDo(doc['title'], isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleTodo(doc),
      title: Text(
        todo.title,
        style: todo.isDone
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic)
            : null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(doc),
      ),
    );
  }

  void _addTodo(ToDo todo) {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': todo.title, 'isDone': todo.isDone});
    _todoController.text = '';
  }

  // @override
  // Future<void> deleteTodo(ToDo todo) async {
  //   return todoCollection.document(todo.id).delete();
  // }

  void _deleteTodo(DocumentSnapshot doc) async {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  void _toggleTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).update({
      'isDone': !doc['isDone'],
    });
  }
}
