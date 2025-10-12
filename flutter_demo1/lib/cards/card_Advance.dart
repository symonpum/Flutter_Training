import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CardAdvance()));
}

class CardAdvance extends StatelessWidget {
  const CardAdvance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Advance"), backgroundColor: Colors.teal),
      backgroundColor: Colors.grey.shade600,
      body: Center(
        child: Card(
          elevation: 10,
          shadowColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          clipBehavior: Clip.antiAlias,
          //color: Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1170',
                height: 200,
                width: 450,
                fit: BoxFit.cover,
                //When there is no image or Error Link > Return Error builder:
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.red,
                      size: 150,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Heading 1 ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                    decorationThickness: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Explore the depths of this magical forest, where sunlight filters through the canopy. A perfect getaway from the hustle and bustle of city life.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
