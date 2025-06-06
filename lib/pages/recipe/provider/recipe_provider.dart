import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/recipe/model/reciperesponse.dart';
import 'package:http/http.dart' as http;

class RecipeProvider with ChangeNotifier {
  static const geminiKey = "AIzaSyAVzg2G3WPSLViQUglnzaQ7IBzHQ1CkSfk";
  RecipeResponse? _recipeResponse;
  RecipeResponse? get recipeResponse => _recipeResponse;

  Future<String> generateRecipe(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text":
                  '''You are great cook, helpful and knowledgeable recipe assistant chatbot.
                  When a user asks for a recipe, always respond in well-structured JSON format.
                  here is the example - 
                  "response": {
                    "type": "RECIPE",
                    "recipeName": "Creamy Mushroom Pasta",
                    "cuisine": "Italian",
                    "servings": 2,
                    "prepTime": "10 minutes",
                    "cookTime": "15 minutes",
                    "ingredients": [
                      {
                        "item": "Pasta",
                        "quantity": "200 g"
                      },
                      {
                        "item": "Mushrooms",
                        "quantity": "150 g"
                      },
                      {
                        "item": "Garlic",
                        "quantity": "2 cloves"
                      },
                      {
                        "item": "Olive Oil",
                        "quantity": "2 tbsp"
                      },
                      {
                        "item": "Cream",
                        "quantity": "1/2 cup"
                      },
                      {
                        "item": "Salt",
                        "quantity": "to taste"
                      },
                      {
                        "item": "Pepper",
                        "quantity": "to taste"
                      }
                    ],
                    "instructions": [
                      {
                        "stepNumber": 1,
                        "stepDescription": "Boil a pot of salted water and cook pasta according to package instructions."
                      },
                      {
                        "stepNumber": 2,
                        "stepDescription": "Meanwhile, slice mushrooms and mince the garlic."
                      },
                      {
                        "stepNumber": 3,
                        "stepDescription": "In a pan, heat olive oil over medium heat. Sauté garlic until fragrant, then add mushrooms. Cook for 5–7 minutes."
                      },
                      {
                        "stepNumber": 4,
                        "stepDescription": "Reduce heat, stir in cream, salt, and pepper. Simmer gently."
                      },
                      {
                        "stepNumber": 5,
                        "stepDescription": "Drain pasta and toss it into the sauce. Coat thoroughly and serve hot."
                      }
                    ],
                    "tips": [
                      "Add chopped parsley or grated cheese on top for extra flavor.",
                      "Use a splash of pasta water in the sauce for a silkier consistency."
                    ],
                    "notes": "Feel free to use whole-grain pasta for a healthier twist."
                  },

                  Respond only with valid JSON. Do not include explanations or extra text outside the JSON.
                  Keep responses friendly, clear, and easy to understand for home cooks.
                  If a user requests a specific dish or ingredient, tailor the recipe accordingly.
                  ''',
            },
          },
          "contents": [
            {
              "role": "model",
              "parts": [
                {"text": prompt},
              ]
            }
          ],
        }),
      );

      if (res.statusCode == 200) {
        String val = jsonDecode(res.body)['candidates'][0]['content']['parts']
            [0]['text'];

        final formatted = responseModelFromJson(
          val.substring(7, val.length - 3),
        );

        _recipeResponse = formatted;

        notifyListeners();
        return val;
      }
      // print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}
