import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/charge_item.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  Map<int, ChargeItem>? _chargeItems;
  bool _isLoaded = false;

  Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      print('Starting to load CSV data...');
      final String csvData = await rootBundle.loadString('assets/data/clean_price_list.csv');
      print('CSV data loaded, length: ${csvData.length}');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
      
      _chargeItems = <int, ChargeItem>{};
      
      // Skip header row (index 0)
      for (int i = 1; i < csvTable.length; i++) {
        try {
          final row = csvTable[i].map((e) => e.toString()).toList();
          if (row.length >= 17) {
            final chargeItem = ChargeItem.fromCsvRow(row);
            _chargeItems![chargeItem.chargeCode] = chargeItem;
          }
        } catch (e) {
          print('Error parsing row $i: $e');
          continue;
        }
      }
      
      _isLoaded = true;
      print('Data loaded successfully: ${_chargeItems!.length} items');
    } catch (e) {
      print('Error loading CSV data: $e');
      _chargeItems = <int, ChargeItem>{};
    }
  }

  ChargeItem? getChargeItem(int chargeCode) {
    return _chargeItems?[chargeCode];
  }

  List<ChargeItem> searchChargeItems(String query) {
    if (_chargeItems == null || query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _chargeItems!.values
        .where((item) =>
            item.chargeName.toLowerCase().contains(lowerQuery) ||
            item.chargeCode.toString().contains(query))
        .take(20)
        .toList();
  }

  bool get isDataLoaded => _isLoaded;
  int get totalItems => _chargeItems?.length ?? 0;
}