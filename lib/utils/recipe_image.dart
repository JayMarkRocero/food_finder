import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// Renders a recipe's real image if the asset exists, otherwise falls back
// to the green gradient + icon placeholder so the app never shows a broken
// image icon.
class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;

  const RecipeImage({super.key, required this.imageUrl, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.zero;
    final isAsset = imageUrl.startsWith('assets/');

    if (isAsset) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          imageUrl,
          key: ValueKey(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // gaplessPlayback prevents the image from flashing blank when
          // this widget rebuilds — e.g. navigating back from the detail
          // screen after a Hero transition.
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _placeholder(radius),
        ),
      );
    }
    return _placeholder(radius);
  }

  Widget _placeholder(BorderRadius radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.85),
            AppColors.lightGreen.withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant_menu, color: Colors.white, size: 40),
      ),
    );
  }
}