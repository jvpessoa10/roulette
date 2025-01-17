import 'package:flutter_bloc/flutter_bloc.dart';
import 'ItemsUIState.dart';

sealed class ItemsEvent {}
final class AddItemPressed extends ItemsEvent {}
final class DismissedItem extends ItemsEvent {
  final int pos;
  DismissedItem({required this.pos});
}
final class ItemTextChanged extends ItemsEvent {
  final int pos;
  final String text;
  ItemTextChanged({required this.pos, required this.text});
}

class ItemsBloc extends Bloc<ItemsEvent, ItemsUIState> {
  ItemsBloc() : super(ItemsUIState(items: [
    for (var i = 0; i < 3; i++) Item(text: "Item $i")
  ])) {
    on<AddItemPressed>(_onAddItemPressed);
    on<DismissedItem>(_onDismissedItem);
    on<ItemTextChanged>(_onItemTextChange);
  }

  void _onAddItemPressed(event, emit) {
    emit(
        state.copyWith(
            items: [...state.items, Item(text: "")],
            focusedItem: state.items.length - 1
        )
    );
  }

  void _onDismissedItem(DismissedItem event, emit) {
    emit(
        state.copyWith(
            items: [...state.items]..removeAt(event.pos),
        )
    );
  }

  void _onItemTextChange(ItemTextChanged event, emit) {
    Item newItem = state.items[event.pos].copyWith(text: event.text);
    List<Item> newList = [...state.items];
    newList[event.pos] = newItem;

    emit(
        state.copyWith(
            items: newList
        )
    );
  }
}