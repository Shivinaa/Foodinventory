import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/recipe/provider/recipe_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  final String prompt;

  const RecipeCard({super.key, this.prompt = ""});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  void initState() {
    Future.microtask(() async {
      await context.read<RecipeProvider>().generateRecipe(widget.prompt);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Consumer<RecipeProvider>(builder: (context, provider, _) {
          if (!provider.loading && provider.recipeResponse != null) {
            var recipe = provider.recipeResponse!.response!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade500,
                          Colors.yellow.shade700
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.recipeName ?? 'Unknown Recipe',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.food_bank,
                              color: Colors.white,
                              size: 20,
                            ), // cuisine icon
                            const SizedBox(width: 8),
                            Text(
                              recipe.cuisine ?? 'Unknown Cuisine',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.people,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${recipe.servings ?? 0} Servings',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Time Information
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      children: [
                        _buildTimeInfoCard(
                          icon: Icons.timer,
                          label: 'Prep Time',
                          time: recipe.prepTime ?? 'N/A',
                        ),
                        const SizedBox(width: 16),
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
                  if (recipe.ingredients != null &&
                      recipe.ingredients!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.ingredients!.map((ingredient) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '• ${ingredient.quantity ?? ''} ${ingredient.item ?? ''}',
                              style: const TextStyle(fontSize: 16),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.instructions!.map((instruction) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${instruction.stepNumber}. ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    instruction.stepDescription ?? '',
                                    style: const TextStyle(fontSize: 16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recipe.tips!.map((tip) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            recipe.notes!,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          return Center(child: Lottie.asset("assets/recipe_loading.json"));
        }),
      ),
    );
  }

  Widget _buildTimeInfoCard({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Text(
                time,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
