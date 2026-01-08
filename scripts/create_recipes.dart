import 'dart:io';
import 'package:rupp_final_mad/data/api/api_client.dart';
import 'package:rupp_final_mad/data/api/api_config.dart';
import 'package:rupp_final_mad/data/services/token_storage_service.dart';

void main() async {
  // Token to use
  const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIzMGI5MzMxOS1iNmViLTQ1YjEtYWZhYy1hOGM1ZmI3MGE0ODAiLCJlbWFpbCI6InZlcmlmeV9yZWNpcGllc0BnbWFpbC5jb20iLCJleHAiOjE3OTkzODkzMjB9.EJVoj9yFsEIct55zu5fVKND097T7XRJj1glOKah-GdQ';
  
  // Save token
  final tokenStorage = TokenStorageService();
  await tokenStorage.saveToken(token, 'Bearer');
  print('Token saved successfully');

  // Create API client
  final apiClient = ApiClient();

  // All recipes to create
  final recipes = [
    // Asean category
    {
      "title": "Chicken Fried Rice",
      "cookingTime": 30,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://www.allrecipes.com/thmb/GxHYGQD4Vh9BBu-EDlSv5XGBJNc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/ALR-23298-egg-fried-rice-VAT-4x3-2closeup-ab653366830b41cc8d62627939ccc6c7.jpg",
      "description": "A simple Asian-style fried rice with chicken and vegetables.",
      "ingredients": [
        "Cooked rice",
        "Chicken breast",
        "Egg",
        "Garlic",
        "Soy sauce",
        "Vegetable oil"
      ],
      "instructions": [
        "Step 1: Heat oil in a pan and sauté garlic until fragrant.",
        "Step 2: Add chicken and cook until fully cooked.",
        "Step 3: Push chicken aside and scramble the egg.",
        "Step 4: Add rice and soy sauce, then stir well.",
        "Step 5: Cook for 5 minutes and serve hot."
      ],
      "cuisine": "Asean",
      "tags": []
    },
    {
      "title": "Beef Noodle Soup",
      "cookingTime": 60,
      "servings": 3,
      "difficulty": "medium",
      "imageUrl": "https://www.marionskitchen.com/wp-content/uploads/2022/09/Slow-cooker-Thai-Beef-Noodle-Soup-01-1200x1500.jpg",
      "description": "Warm Asian beef soup with noodles and rich broth.",
      "ingredients": [
        "Beef slices",
        "Rice noodles",
        "Onion",
        "Garlic",
        "Beef broth",
        "Soy sauce"
      ],
      "instructions": [
        "Step 1: Boil beef broth in a pot.",
        "Step 2: Add garlic and onion, simmer for 10 minutes.",
        "Step 3: Add beef slices and cook until tender.",
        "Step 4: Cook noodles separately.",
        "Step 5: Combine noodles and soup, then serve."
      ],
      "cuisine": "Asean",
      "tags": []
    },
    {
      "title": "Vegetable Stir Fry",
      "cookingTime": 20,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://cdn.loveandlemons.com/wp-content/uploads/2025/02/stir-fry-recipe.jpg",
      "description": "Healthy Asian vegetable stir fry.",
      "ingredients": [
        "Broccoli",
        "Carrot",
        "Bell pepper",
        "Garlic",
        "Soy sauce",
        "Oil"
      ],
      "instructions": [
        "Step 1: Heat oil in a pan.",
        "Step 2: Add garlic and cook until fragrant.",
        "Step 3: Add vegetables and stir fry.",
        "Step 4: Add soy sauce and mix well.",
        "Step 5: Cook for 5 minutes and serve."
      ],
      "cuisine": "Asean",
      "tags": []
    },
    // Fast Food category
    {
      "title": "Cheeseburger",
      "cookingTime": 25,
      "servings": 1,
      "difficulty": "easy",
      "imageUrl": "https://www.shutterstock.com/image-photo/juicy-double-cheeseburger-studio-shot-600nw-2572134091.jpg",
      "description": "Classic fast food cheeseburger.",
      "ingredients": [
        "Burger bun",
        "Beef patty",
        "Cheese slice",
        "Lettuce",
        "Tomato",
        "Mayonnaise"
      ],
      "instructions": [
        "Step 1: Grill the beef patty until cooked.",
        "Step 2: Place cheese on patty and let it melt.",
        "Step 3: Toast the burger bun.",
        "Step 4: Assemble bun, patty, and vegetables.",
        "Step 5: Serve immediately."
      ],
      "cuisine": "Fast food",
      "tags": []
    },
    {
      "title": "French Fries",
      "cookingTime": 30,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg?cs=srgb&dl=pexels-dzeninalukac-1583884.jpg&fm=jpg",
      "description": "Crispy homemade french fries.",
      "ingredients": [
        "Potatoes",
        "Oil",
        "Salt"
      ],
      "instructions": [
        "Step 1: Peel and cut potatoes.",
        "Step 2: Heat oil in a pan.",
        "Step 3: Fry potatoes until golden.",
        "Step 4: Remove and drain oil.",
        "Step 5: Sprinkle salt and serve."
      ],
      "cuisine": "Fast food",
      "tags": []
    },
    {
      "title": "Hot Dog",
      "cookingTime": 15,
      "servings": 1,
      "difficulty": "easy",
      "imageUrl": "https://thumbs.dreamstime.com/b/hot-dog-falling-onto-wooden-board-ketchup-mustard-splash-vivid-hyper-realistic-shot-juicy-thick-creating-dynamic-423330701.jpg",
      "description": "Simple fast food hot dog.",
      "ingredients": [
        "Hot dog sausage",
        "Hot dog bun",
        "Ketchup",
        "Mustard"
      ],
      "instructions": [
        "Step 1: Boil or grill the sausage.",
        "Step 2: Warm the bun.",
        "Step 3: Place sausage inside bun.",
        "Step 4: Add ketchup and mustard.",
        "Step 5: Serve hot."
      ],
      "cuisine": "Fast food",
      "tags": []
    },
    // Dessert category
    {
      "title": "Chocolate Cake",
      "cookingTime": 60,
      "servings": 6,
      "difficulty": "medium",
      "imageUrl": "https://sugarfreelondoner.com/wp-content/uploads/2020/12/sugar-free-birthday-cake-chocolate-1200.jpg",
      "description": "Soft and rich chocolate cake.",
      "ingredients": [
        "Flour",
        "Cocoa powder",
        "Sugar",
        "Eggs",
        "Butter"
      ],
      "instructions": [
        "Step 1: Preheat oven to 180°C.",
        "Step 2: Mix dry ingredients.",
        "Step 3: Add eggs and butter.",
        "Step 4: Pour into baking pan.",
        "Step 5: Bake for 40 minutes."
      ],
      "cuisine": "desert",
      "tags": []
    },
    {
      "title": "Pancakes",
      "cookingTime": 20,
      "servings": 3,
      "difficulty": "easy",
      "imageUrl": "https://media.istockphoto.com/id/161170090/photo/pancakes-with-berries-and-maple-syrup.webp?b=1&s=612x612&w=0&k=20&c=coMq3l7x8X-H4MyDCw8dK3jaXVmVmLSBr4p8X9UkC5E=",
      "description": "Fluffy breakfast pancakes.",
      "ingredients": [
        "Flour",
        "Milk",
        "Egg",
        "Sugar",
        "Butter"
      ],
      "instructions": [
        "Step 1: Mix all ingredients in a bowl.",
        "Step 2: Heat pan with butter.",
        "Step 3: Pour batter into pan.",
        "Step 4: Cook both sides until golden.",
        "Step 5: Serve with syrup."
      ],
      "cuisine": "desert",
      "tags": []
    },
    {
      "title": "Fruit Salad",
      "cookingTime": 10,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://media.istockphoto.com/id/1225981808/photo/healthy-homemade-fruit-salad-bowl-shot-from-above.jpg?s=612x612&w=0&k=20&c=f9hWan8nPo4C0UKxG7bF65cAmyUhbb-Qa0TYrc0BwWc=",
      "description": "Fresh and healthy fruit dessert.",
      "ingredients": [
        "Apple",
        "Banana",
        "Orange",
        "Grapes",
        "Honey"
      ],
      "instructions": [
        "Step 1: Wash all fruits.",
        "Step 2: Cut fruits into pieces.",
        "Step 3: Place in a bowl.",
        "Step 4: Drizzle honey on top.",
        "Step 5: Mix and serve."
      ],
      "cuisine": "desert",
      "tags": []
    },
    // Drink category
    {
      "title": "Lemon Tea",
      "cookingTime": 10,
      "servings": 1,
      "difficulty": "easy",
      "imageUrl": "https://img.freepik.com/free-photo/high-angle-ice-tea-glass_23-2148555390.jpg?semt=ais_hybrid&w=740&q=80",
      "description": "Refreshing lemon tea drink.",
      "ingredients": [
        "Tea bag",
        "Hot water",
        "Lemon",
        "Sugar"
      ],
      "instructions": [
        "Step 1: Boil water.",
        "Step 2: Add tea bag to cup.",
        "Step 3: Pour hot water.",
        "Step 4: Add lemon and sugar.",
        "Step 5: Stir and serve."
      ],
      "cuisine": "drink",
      "tags": []
    },
    {
      "title": "Iced Coffee",
      "cookingTime": 10,
      "servings": 1,
      "difficulty": "easy",
      "imageUrl": "https://www.shutterstock.com/image-photo/ice-coffee-tall-glass-cream-260nw-2333005681.jpg",
      "description": "Cold coffee drink.",
      "ingredients": [
        "Coffee",
        "Ice cubes",
        "Milk",
        "Sugar"
      ],
      "instructions": [
        "Step 1: Brew coffee.",
        "Step 2: Add sugar and milk.",
        "Step 3: Add ice cubes.",
        "Step 4: Stir well.",
        "Step 5: Serve cold."
      ],
      "cuisine": "drink",
      "tags": []
    },
    {
      "title": "Banana Smoothie",
      "cookingTime": 5,
      "servings": 1,
      "difficulty": "easy",
      "imageUrl": "https://media.istockphoto.com/id/1194152250/photo/vegan-banana-and-oatmeal-smoothie-in-glass-jar-on-the-light-background.jpg?s=612x612&w=0&k=20&c=np9DgHLFcUJwY5hzLd3aSLzebaYDzPzerkEGbuGy0tY=",
      "description": "Healthy banana smoothie.",
      "ingredients": [
        "Banana",
        "Milk",
        "Honey"
      ],
      "instructions": [
        "Step 1: Peel the banana.",
        "Step 2: Add banana to blender.",
        "Step 3: Add milk and honey.",
        "Step 4: Blend until smooth.",
        "Step 5: Serve immediately."
      ],
      "cuisine": "drink",
      "tags": []
    },
    // Soup category
    {
      "title": "Chicken Soup",
      "cookingTime": 45,
      "servings": 3,
      "difficulty": "easy",
      "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjmakWKESgA5D7EC0AHRaizP_n0HKDwmot7A&s",
      "description": "Warm and comforting chicken soup perfect for any day.",
      "ingredients": [
        "Chicken pieces",
        "Carrot",
        "Onion",
        "Garlic",
        "Water",
        "Salt"
      ],
      "instructions": [
        "Step 1: Wash and cut all vegetables.",
        "Step 2: Boil water in a pot.",
        "Step 3: Add chicken pieces and cook for 15 minutes.",
        "Step 4: Add vegetables and salt.",
        "Step 5: Simmer until everything is soft and serve hot."
      ],
      "cuisine": "soup",
      "tags": []
    },
    {
      "title": "Beef Soup",
      "cookingTime": 60,
      "servings": 4,
      "difficulty": "medium",
      "imageUrl": "https://media.istockphoto.com/id/647265710/photo/bowl-of-vegetable-beef-soup-with-bread-and-hot-chilli-peppers-in-background.jpg?s=612x612&w=0&k=20&c=VHR_ASDD51GBp-IygwAUjujZGg5uZ0hvFRrzGxCl4Bo=",
      "description": "Rich beef soup with vegetables.",
      "ingredients": [
        "Beef chunks",
        "Potato",
        "Carrot",
        "Onion",
        "Garlic",
        "Water",
        "Salt"
      ],
      "instructions": [
        "Step 1: Cut beef and vegetables into pieces.",
        "Step 2: Boil water in a large pot.",
        "Step 3: Add beef and cook until tender.",
        "Step 4: Add vegetables and salt.",
        "Step 5: Simmer for 20 minutes and serve."
      ],
      "cuisine": "soup",
      "tags": []
    },
    {
      "title": "Fish Soup",
      "cookingTime": 35,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://media.istockphoto.com/id/469545721/photo/fish-soup.jpg?s=612x612&w=0&k=20&c=SSEVmq5UIe-4AA5zuDRlOdQqQDtczdPE3wbl2m0NnVI=",
      "description": "Light and healthy fish soup.",
      "ingredients": [
        "Fish slices",
        "Tomato",
        "Onion",
        "Garlic",
        "Water",
        "Salt"
      ],
      "instructions": [
        "Step 1: Clean and cut the fish.",
        "Step 2: Boil water in a pot.",
        "Step 3: Add garlic and onion.",
        "Step 4: Add fish and tomatoes.",
        "Step 5: Cook gently and serve warm."
      ],
      "cuisine": "soup",
      "tags": []
    },
    // Meatless category
    {
      "title": "Mushroom Soup",
      "cookingTime": 30,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://media.istockphoto.com/id/1667686691/photo/mushroom-soup-in-craft-bowl-on-light-stone-table.jpg?s=612x612&w=0&k=20&c=mmynj_xXPp5cZ27sIqEt9DSmIxG4Sy6o8becSiXcDC0=",
      "description": "Creamy and delicious meatless mushroom soup.",
      "ingredients": [
        "Mushrooms",
        "Onion",
        "Garlic",
        "Milk",
        "Butter",
        "Salt"
      ],
      "instructions": [
        "Step 1: Slice mushrooms and onion.",
        "Step 2: Melt butter in a pot.",
        "Step 3: Add onion and garlic, cook until fragrant.",
        "Step 4: Add mushrooms and milk.",
        "Step 5: Simmer and serve warm."
      ],
      "cuisine": "meatless",
      "tags": []
    },
    {
      "title": "Vegetable Fried Rice",
      "cookingTime": 25,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://images.getrecipekit.com/20220904015448-veg-20fried-20rice.png?aspect_ratio=4:3&quality=90&",
      "description": "Simple and healthy meatless fried rice with vegetables.",
      "ingredients": [
        "Cooked rice",
        "Carrot",
        "Peas",
        "Onion",
        "Garlic",
        "Soy sauce",
        "Vegetable oil"
      ],
      "instructions": [
        "Step 1: Heat oil in a pan.",
        "Step 2: Add garlic and onion, cook until fragrant.",
        "Step 3: Add vegetables and stir fry.",
        "Step 4: Add rice and soy sauce.",
        "Step 5: Mix well and serve hot."
      ],
      "cuisine": "meatless",
      "tags": []
    },
    {
      "title": "Fresh Garden Salad",
      "cookingTime": 10,
      "servings": 2,
      "difficulty": "easy",
      "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdNPfrlOFEzUDiuLxvhU0NKzEJ5N371ICY-Q&s",
      "description": "A light and refreshing meatless salad made with fresh vegetables.",
      "ingredients": [
        "Lettuce",
        "Tomato",
        "Cucumber",
        "Carrot",
        "Olive oil",
        "Salt",
        "Lemon juice"
      ],
      "instructions": [
        "Step 1: Wash all vegetables thoroughly.",
        "Step 2: Cut lettuce, tomato, cucumber, and carrot.",
        "Step 3: Place all vegetables in a bowl.",
        "Step 4: Add olive oil, lemon juice, and salt.",
        "Step 5: Toss gently and serve fresh."
      ],
      "cuisine": "meatless",
      "tags": []
    },
  ];

  // Create recipes
  print('\nCreating ${recipes.length} recipes...\n');
  int successCount = 0;
  int failCount = 0;

  for (int i = 0; i < recipes.length; i++) {
    final recipe = recipes[i];
    try {
      print('Creating recipe ${i + 1}/${recipes.length}: ${recipe['title']}');
      
      // API expects an array for bulk endpoint
      final response = await apiClient.post(
        ApiConfig.recipeCreateEndpoint,
        data: [recipe],
      );

      print('✓ Successfully created: ${recipe['title']}');
      successCount++;
    } catch (e) {
      print('✗ Failed to create ${recipe['title']}: $e');
      failCount++;
    }
    
    // Small delay to avoid overwhelming the API
    await Future.delayed(Duration(milliseconds: 500));
  }

  print('\n=== Summary ===');
  print('Successfully created: $successCount recipes');
  print('Failed: $failCount recipes');
  print('Total: ${recipes.length} recipes');
}

