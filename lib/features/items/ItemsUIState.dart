class ItemsUIState  {
  final List<String> items;
  final bool isLoading;

  const ItemsUIState({
    required this.items,
    required this.isLoading,
  });

  ItemsUIState copyWith({
    List<String>? items,
    bool? isLoading,
  }) {
    return ItemsUIState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
