import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a state
class BooleanState {
  BooleanState(this.value);
  final bool value;
}

// Define a StateNotifier
class BooleanNotifier extends StateNotifier<BooleanState> {
  BooleanNotifier() : super(BooleanState(false)) {
    loadValue();
  }

  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('boolean_state') ?? false;
    state = BooleanState(value);
  }

  void update(bool value) async {
    state = BooleanState(value);
    await saveValue(value);
  }

  Future<void> saveValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolean_state', value);
  }
}

// Define a provider
final booleanProvider = StateNotifierProvider<BooleanNotifier, BooleanState>(
    (ref) => BooleanNotifier());
