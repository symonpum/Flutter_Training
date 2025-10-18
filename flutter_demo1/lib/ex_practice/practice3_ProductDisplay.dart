import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ProductDisplayDesign()));
}

class ProductDisplayDesign extends StatelessWidget {
  const ProductDisplayDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Practice#3: Product Display Design'),
        centerTitle: false,
      ),
      body: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: 400,
            height: 250, // Increased height to fit price row
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                "https://stormwatches.com/cdn/shop/files/S-HERO_SMART_WATCH_BLACK_5fb5a97c-c460-4b28-9a4c-44752df77273.jpg?v=1702317863&width=1946",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: Icon(Icons.broken_image,
                                        size: 48, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 10,
                              child: Card(
                                color: Color(0xFFe74c3c),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Text(
                                    "SALE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vintage Leather Watch",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Accessories",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Text("⭐", style: TextStyle(fontSize: 20)),
                                Text("⭐", style: TextStyle(fontSize: 20)),
                                Text("⭐", style: TextStyle(fontSize: 20)),
                                Text("⭐", style: TextStyle(fontSize: 20)),
                                Text("⭐",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "\$120.00  ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        "\$79.99",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFFc0392b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
