import 'dart:ui';

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: StackSample()));
}

class StackSample extends StatelessWidget {
  const StackSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stack Widget Demo"),
        backgroundColor: const Color(0xFF1A237E), // Matching the gradient
      ),
      // Using a light grey background to make the card stand out.
      backgroundColor: Colors.grey[200],
      body: Center(
        // Padding around the card for better visual separation.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildStackCard(),
        ),
      ),
    );
  }

  /// Builds the card-like UI using a Stack.
  /// The SizedBox constrains the height of the Stack.
  Widget _buildStackCard() {
    return SizedBox(
      height: 250, // Increased height for better spacing
      child: Card(
        // Using a Card for elevation and rounded corners by default.
        elevation: 8.0,
        clipBehavior: Clip
            .antiAlias, // Ensures children respect the Card's rounded corners with smooth edges.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          // Stack allows layering widgets on top of each other.
          // The default clipBehavior for Stack is Clip.hardEdge.
          // We rely on the Card's clipBehavior here.
          children: [
            // --- 1. Background Layer ---
            // This widget fills the entire space of the Stack.
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3F51B5), Color(0xFF1A237E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Image.network(
                  "https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  fit: BoxFit.cover,
                  // Add an error builder for robustness
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, color: Colors.white),
                    );
                  },
                ),
              ),
            ),

            // --- 2. Overflowing Badge (Top Right) ---
            // This badge is positioned to hang outside the card's top-right corner.
            // Because the parent Card has `clipBehavior: Clip.antiAlias`,
            // the overflowing part is smoothly clipped.
            Positioned(
              right: -18,
              top: -12,
              child: Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF7043),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(-2, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '★',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),

            // --- 3. Decorative Circle (Bottom Left) ---
            // This circle also overflows its container to create a nice visual effect.
            // The clipping results in a smooth curve along the card's rounded corner.
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            // --- 4. Blurred "Glassmorphism" Chip (Bottom Left) ---
            // This demonstrates a popular UI effect.
            Positioned(
              left: 16,
              bottom: 16,
              // ClipRRect is necessary to apply rounded corners to the BackdropFilter.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // BackdropFilter applies a filter (in this case, blur) to the area BEHIND this widget.
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Glass Effect',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- 5. Main Content Label (Top Left) ---
            // A simple text label with a semi-transparent background.
            Positioned(
              left: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Featured Card",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
