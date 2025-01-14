import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(
            200, 33, 104, 123)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];
  final scrollController = ScrollController();
  final keys = GlobalKey<AnimatedListState>();

  void _addItem() {
    items.add("");
    keys.currentState?.insertItem(items.length - 1, duration: Duration(milliseconds: 700));
  }

  void _removeItem(int pos) {
    setState(() {
      items.removeAt(pos);
    });
  }

  void _updateItem(int pos, String text) {
    items[pos] = text;
  }

  @override
  Widget build(BuildContext context) {
    var lastFocusNode = FocusNode();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
            widget.title,
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent
        child: AnimatedList(
            key: keys,
            initialItemCount: items.length,
            controller: scrollController,
            reverse: false,
            itemBuilder: (context, index, animation) {
              String item = items[index];
              var controller = TextEditingController(
                  text: item
              );

              FocusNode focusNode;

              if (index == items.length - 1) {
                focusNode = lastFocusNode;
              } else {
                focusNode = FocusNode();
              }

              return FadeTransition(
                opacity: animation.drive(
                    Tween<double>(begin: 0, end: 1)
                        .chain(CurveTween(curve: Curves.ease))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: 8
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: index == items.length - 1,
                        textInputAction: TextInputAction.next,
                        onChanged: (String value) {
                          _updateItem(index, value);
                        },
                      ) ,
                    ),
                    Divider(
                      height: 1,

                    )
                  ],
                )
              );
            }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
              ).then((_) {
                lastFocusNode.requestFocus();
              });
            }
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
