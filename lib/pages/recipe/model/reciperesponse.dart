import 'dart:convert';

ChatResponse responseModelFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String responseModelToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  final Response? response;

  ChatResponse({this.response});

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {"response": response?.toJson()};
}

class Response {
  final String? type;
  final String? recipeName;
  final String? cuisine;
  final int? servings;
  final String? prepTime;
  final String? cookTime;
  final List<Ingredient>? ingredients;
  final List<Instruction>? instructions;
  final List<String>? tips;
  final String? notes;

  Response({
    this.type,
    this.recipeName,
    this.cuisine,
    this.servings,
    this.prepTime,
    this.cookTime,
    this.ingredients,
    this.instructions,
    this.tips,
    this.notes,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        type: json["type"],
        recipeName: json["recipeName"],
        cuisine: json["cuisine"],
        servings: json["servings"],
        prepTime: json["prepTime"],
        cookTime: json["cookTime"],
        ingredients: json["ingredients"] == null
            ? []
            : List<Ingredient>.from(
                json["ingredients"]!.map((x) => Ingredient.fromJson(x)),
              ),
        instructions: json["instructions"] == null
            ? []
            : List<Instruction>.from(
                json["instructions"]!.map((x) => Instruction.fromJson(x)),
              ),
        tips: json["tips"] == null
            ? []
            : List<String>.from(json["tips"]!.map((x) => x)),
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "recipeName": recipeName,
        "cuisine": cuisine,
        "servings": servings,
        "prepTime": prepTime,
        "cookTime": cookTime,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "instructions": instructions == null
            ? []
            : List<dynamic>.from(instructions!.map((x) => x.toJson())),
        "tips": tips == null ? [] : List<dynamic>.from(tips!.map((x) => x)),
        "notes": notes,
      };
}

class Ingredient {
  final String? item;
  final String? quantity;

  Ingredient({this.item, this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      Ingredient(item: json["item"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {"item": item, "quantity": quantity};
}

class Instruction {
  final int? stepNumber;
  final String? stepDescription;

  Instruction({this.stepNumber, this.stepDescription});

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        stepNumber: json["stepNumber"],
        stepDescription: json["stepDescription"],
      );

  Map<String, dynamic> toJson() => {
        "stepNumber": stepNumber,
        "stepDescription": stepDescription,
      };
}
