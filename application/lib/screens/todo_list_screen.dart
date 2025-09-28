import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_tab_todo/models/task.dart';
import 'package:quote_tab_todo/screens/login_screen.dart';
import 'package:quote_tab_todo/services/login_service.dart';
import 'package:quote_tab_todo/services/sound_effects.dart';
import 'package:quote_tab_todo/services/todo_service.dart';
import 'package:quote_tab_todo/util/constants.dart';
import 'package:quote_tab_todo/widgets/loading_widget.dart';
import 'package:quote_tab_todo/widgets/task_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TodoListScreen extends StatefulWidget {
  final String username;
  const TodoListScreen({super.key, required this.username});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> with WidgetsBindingObserver{
  bool isLoading = false;

  late List<Task> todos = [];
  
  final FocusNode _newTodoFocusNode = FocusNode();
  late final TextEditingController _todoController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _todoController = TextEditingController();
    // _refreshTodos();  ---> from the server
    loadTodos(); // ---> loads locally
    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _newTodoFocusNode.dispose();
    _todoController.dispose();
    super.dispose();
  }

  //when app closed then save todos locally
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      //saves locally
      saveTodos();
    }
  }

  void saveTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('usedOnce', true);

    final tasksBox = Hive.box<Task>('tasksBox');
    tasksBox.clear();
    tasksBox.addAll(todos);
  }

  void loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final tasksBox = Hive.box<Task>('tasksBox');
    setState(() {
      todos.addAll(tasksBox.values);
    });
    if(!(prefs.getBool('usedOnce') ?? false)){
      _refreshTodos();
    }
  }

  Future<void> _refreshTodos() async {
    setState(() {
      isLoading = true;
    });

    //json decoded list ----> list<Map<String, dynamic>>
    final fetchedTodos = await TodoService.getTodos();

    if (mounted) {
      setState(() {
        isLoading = false;
        todos = fetchedTodos.map((t) => Task(id: t['_id'], title: t['title'], completed: t['completed'])).toList();
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
            LoginService.setLogoutOnStorage();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _refreshTodos,
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
                            final taskToUpdate = todos[index];
                            //play soundeffect
                            if (taskToUpdate.completed == false) {
                              await SoundEffects.done();
                            }
                            //change in ui first
                            setState(() {
                              todos[index].completed =
                                  !todos[index].completed;
                              todos.sort(
                                (a, b) => a.completed.toString().compareTo(
                                  b.completed.toString(),
                                ),
                              );
                            });
                            //server request
                            final success = await TodoService.changeCompleted(
                              taskToUpdate
                            );
                            //if request failed
                            if (!success && mounted) {
                              setState(() {
                                todos[index].completed =
                                    !todos[index].completed;
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
                            final taskTodelete = todos[index];
                            //remove from ui
                            setState(() {
                              todos.removeAt(index);
                            });

                            //delete request
                            final bool success = await TodoService.deleteTodo(
                              taskTodelete,
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
                            final newTodo = Task(id: newid, title: value, completed: false);
                            //عشان يحط الجديدة فوق اول واحدة completed
                            int firstCompletedIndex = todos.indexWhere(
                              (task) => task.completed == true,
                            );
                            setState(() {
                              //لو في completed حطها قبلها ولو مفيش حطها اخر واحدة
                              if (firstCompletedIndex == -1) {
                                todos.add(newTodo);
                              } else {
                                todos.insert(firstCompletedIndex, newTodo);
                              }
                            });

                            final success = await TodoService.setNewTodo(newTodo);

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