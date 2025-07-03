import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/Inventory/provider/inventory_provider.dart';
import 'package:food_inventory_tracking_app/pages/recipe/recipe_detail.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: const Color(0xFF55AB55),
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: const Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Digi Pantry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Track your food inventory and discover quick recipes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Dashboard Section
                _buildSection(
                  title: 'Dashboard',
                  child: const Text(
                    'Welcome to your food inventory tracking system!',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Recent Expiry Items Section
                Consumer<InventoryProvider>(
                  builder: (context, provider, _) {
                    var expiry = provider.expiryItems;
                    if (expiry.isEmpty) {
                      return const SizedBox();
                    }
                    return _buildSection(
                        title: 'Recent Expiry Items from Inventory',
                        child: Column(
                          children: expiry
                              .map(
                                (food) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildExpiryItem(
                                    food.name,
                                    "${food.expiryDate.toDate().difference(DateTime.now()).inDays} days left",
                                    Colors.green.shade400,
                                  ),
                                ),
                              )
                              .toList(),
                        ));
                  },
                ),

                const SizedBox(height: 16.0),

                // Quick Recipe Generator Section
                _buildSection(
                  title: 'Quick Recipe Generator',
                  child: _buildMealButtons(context, 1),
                ),

                const SizedBox(height: 16.0),

                // Recipe Generator from Inventory Section
                _buildSection(
                  title: 'Recipe Generator from Inventory',
                  child: _buildMealButtons(context, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
        border: const Border(
          left: BorderSide(
            color: Color(0xFF55AB55),
            width: 5.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF55AB55),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 2.0,
            margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            color: const Color(0xFF55AB55),
            width: 80.0,
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildExpiryItem(
      String itemName, String timeLeft, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: backgroundColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            timeLeft,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealButtons(BuildContext context, int id) {
    return Row(
      children: [
        Expanded(
          child: _buildMealButton(id, 'Breakfast', Icons.wb_sunny, context),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: _buildMealButton(id, 'Lunch', Icons.restaurant, context),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child:
              _buildMealButton(id, 'Dinner', Icons.nightlight_round, context),
        ),
      ],
    );
  }

  Widget _buildMealButton(
      int id, String mealType, IconData icon, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // final Response testResponse = Response(
        //   type: 'Dessert',
        //   recipeName: 'Chocolate Chip Cookies',
        //   cuisine: 'American',
        //   servings: 24,
        //   prepTime: '15 minutes',
        //   cookTime: '10 minutes',
        //   ingredients: [
        //     Ingredient(item: 'All-purpose flour', quantity: '2 1/4 cups'),
        //     Ingredient(item: 'Baking soda', quantity: '1 teaspoon'),
        //     Ingredient(item: 'Salt', quantity: '1/2 teaspoon'),
        //     Ingredient(item: 'Butter', quantity: '1 cup, softened'),
        //     Ingredient(item: 'Granulated sugar', quantity: '3/4 cup'),
        //     Ingredient(item: 'Brown sugar', quantity: '3/4 cup, packed'),
        //     Ingredient(item: 'Vanilla extract', quantity: '1 teaspoon'),
        //     Ingredient(item: 'Eggs', quantity: '2'),
        //     Ingredient(item: 'Chocolate chips', quantity: '2 cups'),
        //   ],
        //   instructions: [
        //     Instruction(
        //         stepNumber: 1,
        //         stepDescription: 'Preheat oven to 375°F (190°C).'),
        //     Instruction(
        //         stepNumber: 2,
        //         stepDescription:
        //             'Combine flour, baking soda, and salt in a small bowl.'),
        //     Instruction(
        //         stepNumber: 3,
        //         stepDescription:
        //             'Beat butter, granulated sugar, brown sugar, and vanilla extract until creamy.'),
        //     Instruction(
        //         stepNumber: 4,
        //         stepDescription:
        //             'Add eggs one at a time, beating well after each addition.'),
        //     Instruction(
        //         stepNumber: 5,
        //         stepDescription: 'Gradually beat in flour mixture.'),
        //     Instruction(
        //         stepNumber: 6, stepDescription: 'Stir in chocolate chips.'),
        //     Instruction(
        //         stepNumber: 7,
        //         stepDescription:
        //             'Drop by rounded tablespoon onto ungreased baking sheets.'),
        //     Instruction(
        //         stepNumber: 8,
        //         stepDescription:
        //             'Bake for 9-11 minutes or until golden brown.'),
        //     Instruction(
        //         stepNumber: 9,
        //         stepDescription:
        //             'Cool on baking sheets for 2 minutes; remove to wire racks to cool completely.'),
        //   ],
        //   tips: [
        //     'Use room temperature butter for better mixing.',
        //     'Don’t overmix the dough after adding flour.',
        //     'Chill dough for thicker cookies.',
        //   ],
        //   notes:
        //       'These cookies stay soft and chewy for days. Perfect with a glass of milk!',
        // );
        String prompt;
        if (id == 1) {
          prompt = "Generate a quick light recipe for $mealType";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeCard(
                        prompt: prompt,
                      )));
        } else {
          var inventories = context.read<InventoryProvider>().inventoryItems;
          if (inventories.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No Items in your inventory')));
          } else {
            List<String> itemNames = inventories.map((e) => e.name).toList();
            log(itemNames.toString());
            prompt =
                "Generate a recipe based on my inventory. these are the items are currently in my inventory ${itemNames.toString()} for $mealType";
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeCard(
                          prompt: prompt,
                        )));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF55AB55),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.0),
          const SizedBox(height: 4.0),
          Text(
            mealType,
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
