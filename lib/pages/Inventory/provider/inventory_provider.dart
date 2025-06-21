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
    } catch (e) {
      log(e.toString());
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
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
