import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ToDo {
  final int id;
  String todoText;
  final bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    required this.isDone,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 30, 0, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDo> todoList = [
    ToDo(id: 1, todoText: 'Task 1', isDone: false),
    ToDo(id: 2, todoText: 'Task 2', isDone: true),
  ];

  TextEditingController textController = TextEditingController();
  TextEditingController editController = TextEditingController();
  late int editingIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final reversedIndex = todoList.length - 1 - index;
                  return ToDoItem(
                    todo: todoList[reversedIndex],
                    onToDoChanged: (ToDo updatedToDo) {
                      setState(() {
                        todoList[reversedIndex] = updatedToDo;
                      });
                    },
                    onDeleteItem: () {
                      setState(() {
                        todoList.removeAt(reversedIndex);
                      });
                    },
                    onEditItem: () {
                      _showEditToDoDialog(context, reversedIndex);
                    },
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddToDoDialog(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 36),
                SizedBox(width: 20),
                Text('Add To Do'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToDoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter ToDo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addNewToDo();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _addNewToDo() {
    String todoText = textController.text.trim();
    if (todoText.isNotEmpty) {
      setState(() {
        todoList.insert(
          0,
          ToDo(id: todoList.length + 1, todoText: todoText, isDone: false),
        );
        textController.clear();
      });
    }
  }

  void _showEditToDoDialog(BuildContext context, int index) {
    editController.text = todoList[index].todoText;
    editingIndex = index;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: editController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Edit ToDo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _editToDo();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _editToDo() {
    String editedText = editController.text.trim();
    if (editedText.isNotEmpty) {
      setState(() {
        todoList[editingIndex].todoText = editedText;
      });
    }
  }
}

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function() onDeleteItem;
  final Function() onEditItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onToDoChanged(ToDo(
          id: todo.id,
          todoText: todo.todoText,
          isDone: !todo.isDone,
        ));
      },
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (value) {
          onToDoChanged(ToDo(
            id: todo.id,
            todoText: todo.todoText,
            isDone: value ?? false,
          ));
        },
      ),
      title: Text(
        todo.todoText,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEditItem,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDeleteItem,
          ),
        ],
      ),
    );
  }
}
