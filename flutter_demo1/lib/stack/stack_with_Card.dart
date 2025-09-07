import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: StackWidgetDemo()));
}

class StackWidgetDemo extends StatelessWidget {
  const StackWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stack Widget Demo"),
        backgroundColor: Colors.indigo[900],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 450,
            height: 280,
            child: Stack(
              children: [
                // 📷 Background image
                _buildBackground(),
                _buildLabelTitle(),
                _buildHalfCircleWidget(),
                _buildBlurWidget(),
                _buildStarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Image _buildBackground() {
    return Image.network(
      'https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      width: 450,
      height: 280,
      fit: BoxFit.cover,
    );
  }

  Positioned _buildStarWidget() {
    return Positioned(
      top: -12,
      right: -12,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Color(0xFFFF7043),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.star, color: Colors.white),
      ),
    );
  }

  Positioned _buildBlurWidget() {
    return Positioned(
      left: 12,
      bottom: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Text(
              "Glass Effect",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildHalfCircleWidget() {
    return Positioned(
      left: -30,
      bottom: -30,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x66ffffff).withOpacity(0.3),
        ),
      ),
    );
  }

  Positioned _buildLabelTitle() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "Featured Card",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
