import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsViewModel.dart';

import 'ItemsUIState.dart';

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
  });

  final ItemsViewModel viewModel;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Add Items",
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) => Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent
            child: ListView.builder(
                itemCount: widget.viewModel.value.items.length,
                controller: scrollController,
                reverse: false,
                itemBuilder: (context, index) {
                  Item item = widget.viewModel.value.items[index];

                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      widget.viewModel.removeItem(index);
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
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                              bottom: 8
                          ),
                          child: BaseTextField(
                            key: Key(item.id),
                            initialValue: item.text,
                            onChanged: (value) => widget.viewModel.updateItem(index, value),
                            focused: index == widget.viewModel.value.focusedItem,
                            onFocused: () => widget.viewModel.onItemFocus(),
                          ),
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    ),
                  );
                }
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.viewModel.addItem();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BaseTextField extends StatefulWidget {
  const BaseTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.focused,
    required this.onFocused,
  });

  final bool focused;

  final String initialValue;

  final ValueChanged<String> onChanged;

  final void Function() onFocused;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  var hasFocused = false;

  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return TextFormField(
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      focusNode: focusNode,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
