import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = Todo.todoList();
  final _todoController = TextEditingController();
  List<Todo> _foundTodos = [];

  @override
  void initState() {
    _foundTodos = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    searchBox(),
                    Expanded(
                        child: ListView(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: const Text(
                              'All ToDos',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            )),
                        for (Todo todoo in _foundTodos.reversed)
                          TodoItem(
                            todo: todoo,
                            onTodoChanged: _handleTodoChange,
                            onDeleteItem: _deleteTodoItem,
                          ),
                      ],
                    ))
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                        decoration: const InputDecoration(
                            hintText: "Add a new Todo item",
                            border: InputBorder.none)),
                  )),
                  Container(
                      margin: const EdgeInsets.only(bottom: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          _addTodoItem(_todoController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tdBlue,
                          minimumSize: const Size(60, 60),
                          elevation: 10,
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 40),
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
        todo.isDone = !todo.isDone;
    });
  }
  
  void _deleteTodoItem(String id) {
    setState(() {
        todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoItem(String todoText) {
    setState(() {
        todosList.add(Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todoText));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if(enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList.where((item) => item.todoText!.toLowerCase()
      .contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundTodos = results;
    });
  }

  Widget searchBox() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          onChanged: (value) => _runFilter(value),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey),
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: tdBGColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, color: tdBlack, size: 30),
            Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/avatar.jpeg')))
          ],
        ));
  }
}
