import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ImageWidgetBasic()));
}

class ImageWidgetBasic extends StatelessWidget {
  const ImageWidgetBasic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Widget Basic")),
      body: Column(
        children: [
          Image.asset('assets/images/mice.jpeg'),
          Image.network('https://picsum.photos/id/237/300/200', width: 520),
          Image.network(
            'https://picsum.photos/400/300?grayscale&blur=2',
            width: 1220,
            //If error link:
            errorBuilder: (context, error, stackTrace) {
              return Text("Error");
            },
            //Loading Check:
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
