import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String src;
  final BoxFit? fit;
  final double? width;
  final double? hiegth;
  const AppImage({
    super.key,
    this.src = "https://cdn.mos.cms.futurecdn.net/FUi2wwNdyFSwShZZ7LaqWf.jpg",
    this.fit,
    this.width,
    this.hiegth,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      fit: fit,
      width: width,
      height: hiegth,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.running_with_errors));
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
