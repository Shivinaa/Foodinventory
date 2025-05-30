import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/recipe/model/reciperesponse.dart';

class RecipeCard extends StatelessWidget {
  final Response recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade500, Colors.yellow.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.recipeName ?? 'Unknown Recipe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.food_bank,
                          color: Colors.white,
                          size: 20,
                        ), // cuisine icon
                        SizedBox(width: 8),
                        Text(
                          recipe.cuisine ?? 'Unknown Cuisine',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.people, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '${recipe.servings ?? 0} Servings',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Time Information
              Padding(
                padding: EdgeInsets.all(16),
                child: Wrap(
                  children: [
                    _buildTimeInfoCard(
                      icon: Icons.timer,
                      label: 'Prep Time',
                      time: recipe.prepTime ?? 'N/A',
                    ),
                    SizedBox(width: 16),
                    _buildTimeInfoCard(
                      icon: Icons.food_bank, // cooking
                      label: 'Cook Time',
                      time: recipe.cookTime ?? 'N/A',
                    ),
                  ],
                ),
              ),

              // Ingredients Section
              _buildSectionTitle('Ingredients'),
              if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.ingredients!.map((ingredient) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '• ${ingredient.quantity ?? ''} ${ingredient.item ?? ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Instructions Section
              _buildSectionTitle('Instructions'),
              if (recipe.instructions != null &&
                  recipe.instructions!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recipe.instructions!.map((instruction) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${instruction.stepNumber}. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                instruction.stepDescription ?? '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Tips Section
              if (recipe.tips != null && recipe.tips!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Tips'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.tips!.map((tip) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '• $tip',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

              // Notes Section
              if (recipe.notes != null && recipe.notes!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Notes'),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        recipe.notes!,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfoCard({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade700,
        ),
      ),
    );
  }
}
