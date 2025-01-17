import 'package:uuid/uuid.dart';

class ItemsUIState {
  final List<Item> items;
  final bool isLoading;
  final int? focusedItem;

  ItemsUIState({
    required this.items,
    this.isLoading = true,
    this.focusedItem,
  });

  ItemsUIState copyWith({
    List<Item>? items,
    bool? isLoading,
    int? focusedItem,
  }) {
    return ItemsUIState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      focusedItem: focusedItem ?? this.focusedItem
    );
  }
}

class Item {
  final String text;
  final String id;

  Item({
    required this.id,
    required this.text,
  });

  copyWith({
    String? text,
    String? id,
  }) {
    return Item(
      text: text ?? this.text,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.text == text &&
        other.id == id;
  }

  @override
  int get hashCode => text.hashCode ^ id.hashCode;
}