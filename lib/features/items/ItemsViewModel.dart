import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'ItemsUIState.dart';

class ItemsViewModel extends ValueNotifier<ItemsUIState> {
  ItemsViewModel() : super(ItemsUIState(items: []));

  void addItem() {
    value = value.copyWith(
      items: value.items..add(Item(text: "")),
      focusedItem: value.items.length - 1
    );
  }

  void removeItem(pos) {
    value = value.copyWith(
        items: value.items..removeAt(pos),
    );
  }

  void updateItem(int pos, String text) {
    var updatedItem = value.items[pos].copyWith(text: text);
    value = value.copyWith(
        items: value.items..[pos] = updatedItem,
    );
  }

  void onItemFocus() {
    value = value.copyWith(
        focusedItem: null
    );
  }
}