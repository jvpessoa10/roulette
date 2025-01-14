import 'package:flutter/cupertino.dart';
import 'package:flutter_command/flutter_command.dart';

import 'ItemsUIState.dart';

class ItemsViewModel extends ChangeNotifier {
  ItemsUIState _state;
  ItemsUIState get state => _state;

  ItemsViewModel() {
    _state = ItemsUIState(items: [], isLoading: true);
    _load();
  }

  Future<void> _load() {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    return Future.delayed(const Duration(seconds: 2), () {
        _state = _state.copyWith(
          items: [
            for (var i = 0; i < 20; i++) 'Item $i',
          ]
        );
        notifyListeners();
    } );
  }
}