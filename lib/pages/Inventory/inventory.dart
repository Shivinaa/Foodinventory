import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/add_inventory.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/data/inventory_data.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/provider/inventory_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  // Sample data - in a real app, this would come from a database
  // final List<FoodItem> _foodItems = [
  //   FoodItem(
  //     name: 'Rice',
  //     category: 'Grain',
  //     quantity: 2,
  //     expiryDate: '2025-12-31',
  //     notes: 'Basmati rice',
  //   ),
  //   FoodItem(
  //     name: 'Tomatoes',
  //     category: 'Vegetable',
  //     quantity: 5,
  //     expiryDate: '2025-04-18',
  //   ),
  //   FoodItem(
  //     name: 'Chicken Breast',
  //     category: 'Meat',
  //     quantity: 3,
  //     expiryDate: '2025-04-15',
  //     notes: 'Frozen',
  //   ),
  //   FoodItem(
  //     name: 'Milk',
  //     category: 'Dairy',
  //     quantity: 1,
  //     expiryDate: '2025-04-20',
  //   ),
  // ];

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Grain',
    'Vegetable',
    'Fruit',
    'Meat',
    'Dairy',
    'Spice',
    'Frozen',
    'Other'
  ];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Food Inventory',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // _showSortOptions();
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          _buildInventoryList(),
          // Expanded(
          //   child:
          // _filteredItems.isEmpty
          //     ? const Center(
          //         child: Text(
          //           'No items found.',
          //           style: TextStyle(fontSize: 18, color: Colors.grey),
          //         ),
          //       )
          //     :

          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add item form page
          // You mentioned you already have this form
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddInventoryPage()));
        },
        backgroundColor: Colors.lightBlue[300],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.green[50],
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green[400]!),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              context.read<InventoryProvider>().getFilteredItems(value);
            },
          ),
          const SizedBox(height: 10),
          // Category filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      context
                          .read<InventoryProvider>()
                          .getFilteredItems(category);
                    },
                    selectedColor: Colors.lightBlue[100],
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue[800] : Colors.black87,
                    ),
                    checkmarkColor: Colors.blue[800],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Consumer<InventoryProvider>(builder: (context, provider, _) {
      if (provider.loading) {
        return const CircularProgressIndicator();
      }
      if (provider.filteredItems.isNotEmpty) {
        final itemList = provider.filteredItems;
        log(itemList.length.toString());
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              // Check expiry date for color coding
              final expiryDate = item.expiryDate.toDate();
              final daysRemaining =
                  expiryDate.difference(DateTime.now()).inDays;

              Color borderColor = Colors.green;
              if (daysRemaining < 0) {
                borderColor = Colors.red;
              } else if (daysRemaining < 3) {
                borderColor = Colors.orange;
              } else if (daysRemaining < 7) {
                borderColor = Colors.yellow;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: borderColor, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: _getCategoryIcon(item.category),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Item details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Category: ${item.category}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expiry: ${DateFormat("dd MMM yyyy").format(item.expiryDate.toDate())}',
                              style: TextStyle(
                                color: borderColor,
                                fontWeight: daysRemaining < 7
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quantity indicator
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ),
                      // Actions
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.blue),
                            onPressed: () {
                              // Edit item functionality
                            },
                            iconSize: 22,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () {
                              _confirmDelete(item);
                            },
                            iconSize: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
      return Expanded(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No items available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ));
    });
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    switch (category.toLowerCase()) {
      case 'grain':
        iconData = Icons.grain;
        break;
      case 'vegetable':
        iconData = Icons.eco;
        break;
      case 'fruit':
        iconData = Icons.apple;
        break;
      case 'meat':
        iconData = Icons.restaurant;
        break;
      case 'dairy':
        iconData = Icons.breakfast_dining;
        break;
      case 'spice':
        iconData = Icons.local_dining;
        break;
      default:
        iconData = Icons.food_bank;
    }
    return Icon(iconData, color: Colors.green[700]);
  }

  void _confirmDelete(FoodItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text(
            'Are you sure you want to remove ${item.name} from your inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context
                  .read<InventoryProvider>()
                  .deleteItemToInventory(item.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} removed from inventory'),
                    backgroundColor: Colors.red[400],
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // void _showSortOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 20),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Sort By',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             ListTile(
  //               leading: const Icon(Icons.sort_by_alpha),
  //               title: const Text('Name (A-Z)'),
  //               onTap: () {
  //                 setState(() {
  //                   _foodItems.sort((a, b) => a.name.compareTo(b.name));
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.calendar_today),
  //               title: const Text('Expiry Date (Soonest first)'),
  //               onTap: () {
  //                 setState(() {
  //                   _foodItems.sort((a, b) => DateTime.parse(a.expiryDate)
  //                       .compareTo(DateTime.parse(b.expiryDate)));
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.filter_list),
  //               title: const Text('Quantity (Lowest first)'),
  //               onTap: () {
  //                 setState(() {
  //                   _foodItems.sort((a, b) => a.quantity.compareTo(b.quantity));
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
