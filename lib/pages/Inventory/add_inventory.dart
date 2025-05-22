import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();

  String selectedCategory = 'Grain';
  String selectedUnit = 'kg';

  final List<String> categories = [
    'Grain',
    'Vegetable',
    'Fruit',
    'Meat',
    'Dairy',
    'Spice',
    'Frozen',
    'Other'
  ];

  final List<String> units = ['kg', 'liters', 'packets', 'pieces'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitchen Inventory'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(color: Color(0xFF4CAF50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter item name' : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Color(0xFF4CAF50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Color(0xFF4CAF50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter quantity' : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    labelStyle: TextStyle(color: Color(0xFF4CAF50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4CAF50)),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  items: units
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value!;
                    });
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance
                          .collection('inventory')
                          .add({
                        // "uid" : FirebaseAuth.instance.currentUser!.uid,
                        "itemName": itemNameController.text.trim(),
                        "quantity": int.parse(quantityController.text.trim()),
                        "category": selectedCategory,
                        "unit": selectedUnit,
                        'expirydate': Timestamp.fromDate(DateTime(2030)),
                        "createdAt": Timestamp.now(),
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Inventory Item Added'),
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Item', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
