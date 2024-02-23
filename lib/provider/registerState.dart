import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a state
class BooleanState {
  BooleanState(this.value);
  final bool value;
}

// Define a StateNotifier
class BooleanNotifier extends StateNotifier<BooleanState> {
  BooleanNotifier() : super(BooleanState(false));

  void update(bool value) {
    state = BooleanState(value);
  }
}

// Define a provider
final booleanProvider = StateNotifierProvider<BooleanNotifier, BooleanState>(
    (ref) => BooleanNotifier());
