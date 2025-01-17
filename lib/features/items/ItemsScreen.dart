import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roulette/features/items/ItemsViewModel.dart';

import 'ItemsUIState.dart';

class ItemsScreen extends StatelessWidget {
  static const String routeName = '/items';

  static Uri uri() {
    return Uri(path: routeName);
  }

  static Widget goRouterBuilder(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (_) => ItemsBloc(),
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
      ),
      body: BlocBuilder<ItemsBloc, ItemsUIState>(
        buildWhen: (previous, current) {
          return previous.items != current.items;
        },
        builder: (context, state) {
          return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent
              child: Form(
                child: ListView(
                    reverse: false,
                    children: [
                      for (var index = 0; index < state.items.length; index++)
                        buildItemTile(context, state.items[index], index)
                    ]),
              ));
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

  Widget buildItemTile(BuildContext context, Item item, int index) {
    return Dismissible(
      key: Key(item.id),
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
            padding: EdgeInsets.only(
                left: 16, right: 16, top: 8, bottom: 8),
            child: TextFormField(
                initialValue: item.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
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