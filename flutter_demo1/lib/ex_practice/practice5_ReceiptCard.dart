import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class RecipeCardDesign extends StatelessWidget {
  const RecipeCardDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfbe9e7),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text('Practice#5: Recipe Card Design'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: const Color(0xFFffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                // Image section
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    'https://www.simplyrecipes.com/thmb/K54cPz_L-7C6csildu5TVbexEGY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/simply-recipes-creole-spaghetti-lead-3-3dea2465b8ee46458f5bcfa6e936af72.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classic Spaghetti Recipe',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: const Color(0xFFd32f2f),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A timeless Italian dish perfect for any night of the week. Quick, easy, and delicious!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: const Color(0xFF616161),
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prep Time: 10 mins',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF9e9e9e),
                                ),
                          ),
                          Text(
                            'Cook Time: 20 mins',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF9e9e9e),
                                ),
                          ),
                        ],
                      ),
                          Text(
                            'Servings: 4',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF9e9e9e),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}