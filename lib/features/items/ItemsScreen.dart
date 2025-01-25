import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsBloc.dart';

import 'ItemsEvent.dart';
import 'ItemsUIState.dart';

class ItemsScreen extends StatelessWidget {
  static const String routeName = '/items';

  const ItemsScreen({super.key});

  static Uri uri() {
    return Uri(path: routeName);
  }

  static Widget goRouterBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => ItemsBloc()..add(Init()),
      child: ItemsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Add Items",
        ),
        actions: [
        IconButton(
             icon: const Icon(Icons.check),
             tooltip: 'Confirm',
             onPressed: () {
               // handle the press
             },
           ),
        ],
      ),
      body: BlocBuilder<ItemsBloc, ItemsUIState>(
        builder: (context, state) {
          if (state.isLoading) {
            return buildLoading();
          } else {
            if (state.items.isEmpty) {
              return buildEmpty();
            } else {
              return buildLoaded(context, state);
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ItemsBloc>().add(AddItemPressed());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Text("Click on the \"+\" button to add an item."),
    );
  }

  Widget buildLoaded(BuildContext context, ItemsUIState state) {
    return Center(
        child: Form(
          child: ListView(reverse: false, children: [
            for (var index = 0; index < state.items.length; index++)
              buildItemTile(context, state.items[index], index,
                  index == state.focusedItem)
          ]),
        ));
  }

  Widget buildItemTile(
      BuildContext context, Item item, int index, bool focused) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<ItemsBloc>().add(DismissedItem(pos: index));
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
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: BaseTextField(
                initialText: item.text,
                focused: focused,
                onChanged: (text) {
                  context
                      .read<ItemsBloc>()
                      .add(ItemTextChanged(pos: index, text: text));
                }),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}

class BaseTextField extends StatefulWidget {
  const BaseTextField(
      {super.key,
      required this.initialText,
      required this.focused,
      required this.onChanged});

  final String initialText;
  final bool focused;
  final void Function(String) onChanged;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {

  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.focused) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        focusNode: focusNode,
        initialValue: widget.initialText,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: widget.onChanged
    );
  }
}