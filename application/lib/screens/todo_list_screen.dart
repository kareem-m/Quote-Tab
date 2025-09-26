import 'package:flutter/material.dart';
import 'package:quote_tab_todo/screens/login_screen.dart';
import 'package:quote_tab_todo/services/login_service.dart';
import 'package:quote_tab_todo/services/sound_effects.dart';
import 'package:quote_tab_todo/services/todo_service.dart';
import 'package:quote_tab_todo/util/constants.dart';
import 'package:quote_tab_todo/widgets/loading_widget.dart';
import 'package:quote_tab_todo/widgets/task_item.dart';
import 'package:uuid/uuid.dart';

class TodoListScreen extends StatefulWidget {
  final String username;
  const TodoListScreen({super.key, required this.username});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isLoading = false;
  final FocusNode _newTodoFocusNode = FocusNode();
  late List<dynamic> todos = [];
  final _todoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initializeTodos();
  }

  @override
  void dispose() {
    _newTodoFocusNode.dispose();
    _todoController.dispose();
    super.dispose();
  }

  Future<void> _initializeTodos() async {
    setState(() {
      isLoading = true;
    });
    final fetchedTodos = await TodoService.getTodos();
    if (mounted) {
      setState(() {
        isLoading = false;
        todos = fetchedTodos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Quote Todo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            LoginService.setLogout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _initializeTodos,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //edged background
            Container(
              decoration: BoxDecoration(
                color: mainAppColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
            Column(
              children: [
                //welcome
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Welcome, ${widget.username}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),

                //border
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(32),
                    ),

                    //listView
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return TaskItem(
                          todo: todos[index],
                          onCompleted: () async {
                            //باخد نسخة عشان لما اغير ترتيبها في الواجهة اعرف اخد برضو البيانات و ماخدهاش بال index
                            final todoBeforeUpdate = todos[index];
                            bool lastState = todos[index]['completed'];
                            //play soundeffect
                            if (lastState == false) {
                              await SoundEffects.done();
                            }
                            //change in ui first
                            setState(() {
                              todos[index]['completed'] =
                                  !todos[index]['completed'];
                              todos.sort(
                                (a, b) => a['completed'].toString().compareTo(
                                  b['completed'].toString(),
                                ),
                              );
                            });
                            //server request
                            final success = await TodoService.changeCompleted(
                              todoBeforeUpdate['_id'],
                              !lastState,
                            );
                            //if request failed
                            if (!success && mounted) {
                              setState(() {
                                todos[index]['completed'] =
                                    !todos[index]['completed'];
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: mainAppColor,
                                  title: const Text('Error'),
                                  content: const Text(
                                    'Failed to check your task, Please try again.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          onDeleted: () async {
                            //باخد نسخة عشان لما امسح اعرف يبقى معايا ال id
                            dynamic taskTodelete = todos[index];
                            //remove from ui
                            setState(() {
                              todos.removeAt(index);
                            });

                            //delete request
                            final bool success = await TodoService.deleteTodo(
                              taskTodelete['_id'],
                            );

                            //if request failed
                            if (!success && mounted) {
                              setState(() {
                                todos.insert(index, taskTodelete);
                              });

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: mainAppColor,
                                  title: const Text('Error'),
                                  content: const Text(
                                    'Failed to delete, Please try again.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                      itemCount: todos.length,
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              LoadingWidget(color: const Color.fromARGB(255, 34, 42, 60)),
          ],
        ),
      ),

      //add new task
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                _newTodoFocusNode.requestFocus();
              });
              // _newTodoFocusNode.requestFocus();
            });
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    left: 15,
                    right: 15
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: TextField(
                          focusNode: _newTodoFocusNode,
                          controller: _todoController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(border: InputBorder.none),
                          onSubmitted: (value) async {
                            Navigator.pop(context);
                            _todoController.clear();
                            final uuid = Uuid();
                            final newid = uuid.v1();
                            final newTodo = {
                              '_id': newid,
                              'title': value,
                              'completed': false,
                            };
                            //عشان يحط الجديدة فوق اول واحدة completed
                            int firstCompletedIndex = todos.indexWhere(
                              (task) => task['completed'] == true,
                            );
                            setState(() {
                              //لو في completed حطها قبلها ولو مفيش حطها اخر واحدة
                              if (firstCompletedIndex == -1) {
                                todos.add(newTodo);
                              } else {
                                todos.insert(firstCompletedIndex, newTodo);
                              }
                            });

                            final success = await TodoService.setNewTodo(
                              value,
                              id: newid,
                            );

                            if (!success && mounted) {
                              setState(() {
                                todos.removeAt(firstCompletedIndex);
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: mainAppColor,
                                  title: Text('Error'),
                                  content: Text(
                                    'Failed to add a new task, Please try again.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}