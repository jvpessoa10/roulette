import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'ItemsEvent.dart';
import 'ItemsUIState.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsUIState> {
  ItemsBloc() : super(ItemsUIState.initial()) {
    on<Init>(_init);
    on<AddItemPressed>(_onAddItemPressed);
    on<DismissedItem>(_onDismissedItem);
    on<ItemTextChanged>(_onItemTextChange);
  }

  Future<void> _init(event, emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 2));
    emit(
        state.copyWith(
            items: [for (var i = 0; i < 0; i++) Item(text: "Item $i", id: Uuid().v4())],
            isLoading: false,
        )
    );
  }

  Future<void> _onAddItemPressed(event, emit) async {
    emit(state.copyWith(
        items: [...state.items, Item(text: "", id: Uuid().v4())],
        focusedItem: state.items.length));
  }

  void _onDismissedItem(DismissedItem event, emit) {
    emit(state.copyWith(
      items: [...state.items]..removeAt(event.pos),
    ));
  }

  void _onItemTextChange(ItemTextChanged event, emit) {
    Item newItem = state.items[event.pos].copyWith(text: event.text);
    List<Item> newList = [...state.items];
    newList[event.pos] = newItem;

    emit(state.copyWith(items: newList));
  }
}
