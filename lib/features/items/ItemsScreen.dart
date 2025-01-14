import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsViewModel.dart';
import 'package:uuid/uuid.dart';

class ItemsScreen extends StatefulWidget {

  static const String routeName = '/items';

  static Uri uri() {
    return Uri(path: routeName);
  }

  static ItemsScreen goRouterBuilder(
      BuildContext context,
      GoRouterState state
  ) {
    return ItemsScreen(
      viewModel: ItemsViewModel(),
    );
  }

  const ItemsScreen({
    super.key,
    required this.viewModel
  })

  final ItemsViewModel viewModel;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<String> items = [];
  List<FocusNode> focusNodes = [];

  final scrollController = ScrollController();
  final keys = GlobalKey<AnimatedListState>();
  var lastFocusNode = FocusNode();

  void _addItem() {
    items.add(Uuid().v4());
    focusNodes.add(FocusNode());
    keys.currentState?.insertItem(items.length - 1, duration: Duration(milliseconds: 700));
  }

  void _removeItem(int pos) {
    items.removeAt(pos);
    focusNodes.removeAt(pos);
    keys.currentState?.removeItem(pos, (_, a) => Column());
  }

  void _updateItem(int pos, String text) {
    items[pos] = text;
  }

  @override
  Widget build(BuildContext context) {
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
          "Add Items",
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

                return Dismissible(
                  key: ValueKey(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _removeItem(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  child: FadeTransition(
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
                              focusNode: focusNodes[index],
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
                  ),
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
                focusNodes[items.length - 1].requestFocus();
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
