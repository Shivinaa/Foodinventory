import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/data/inventory_data.dart';

class InventoryProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String _error = "";
  String get error => _error;

  List<FoodItemModel> _inventoryItems = [];
  List<FoodItemModel> get inventoryItems => _inventoryItems;
  List<FoodItemModel> _filteredItems = [];
  List<FoodItemModel> get filteredItems => _filteredItems;

  List<FoodItemModel> _expiryItems = [];
  List<FoodItemModel> get expiryItems => _expiryItems;

  Future<void> getInventory() async {
    _loading = true;
    notifyListeners();
    try {
      final res = await FirebaseFirestore.instance
          .collection('inventory')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      var items = res.docs.map((e) {
        var food = e.data();
        food['id'] = e.id;
        return FoodItemModel.fromMap(food);
      }).toList();
      _inventoryItems = items;
      _filteredItems = items;
      getExpiredItems();
    } catch (e) {
      log(e.toString());
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  getFilteredItems(String query) {
    if (query.isEmpty || query == "All") {
      _filteredItems = _inventoryItems;
    } else {
      _filteredItems = _inventoryItems.where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase()) ||
            food.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  getExpiredItems() {
    _expiryItems = _inventoryItems;
    _expiryItems.removeWhere(
        (food) => food.expiryDate.toDate().isBefore(DateTime.now()));
    _expiryItems.sort((a, b) {
      return a.expiryDate.compareTo(b.expiryDate);
    });
    _expiryItems = _expiryItems.take(3).toList();
    notifyListeners();
  }

  Future addItemsToInventory(Map<String, dynamic> item) async {
    _loading = true;
    notifyListeners();
    try {
      final res =
          await FirebaseFirestore.instance.collection('inventory').add(item);
      await getInventory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future deleteItemToInventory(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final res = await FirebaseFirestore.instance
          .collection('inventory')
          .doc(id)
          .delete();
      await getInventory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
