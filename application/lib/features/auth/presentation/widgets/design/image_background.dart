import 'package:flutter/widgets.dart';

class ImageBackground extends StatelessWidget {
  const ImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/wallpaper.jpg',
      fit: BoxFit.cover,
      alignment: AlignmentGeometry.centerRight,
    );
  }
}
