import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the data type
class DataListState {
  DataListState(this.dataList);
  final List<String> dataList;
}

// Define a StateNotifier
class DataListNotifier extends StateNotifier<DataListState> {
  DataListNotifier() : super(DataListState([])) {
    loadData();
  }

  Future<List<String>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDataList = prefs.getStringList('data_list') ?? [];
    state = DataListState(savedDataList);
    return savedDataList;
  }

  void addItem(String newItem) async {
    final updatedList = [newItem, ...state.dataList];
    state = DataListState(updatedList);
    await saveData(updatedList);
  }

  void removeItem(String item) async {
    final updatedList = List<String>.from(state.dataList)
      ..where((element) => element == item);
    state = DataListState(updatedList);
    await saveData(updatedList);
  }

  Future<void> saveData(List<String> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('data_list', dataList);
  }

  void removeAllItems() async {
    state = DataListState([]);
    await saveData([]);
  }
}

// Define a provider
final dataListProvider = StateNotifierProvider<DataListNotifier, DataListState>(
  (ref) => DataListNotifier(),
);
