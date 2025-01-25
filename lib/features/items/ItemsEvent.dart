sealed class ItemsEvent {}

final class Init extends ItemsEvent {}

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
