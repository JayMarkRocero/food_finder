import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../constants/app_colors.dart';

// A tappable heart icon that toggles favorite status with a little scale
// animation. Used on RecipeCard, RecipeTile, and the Detail screen.
class FavoriteButton extends StatefulWidget {
  final String recipeId;
  final double size;

  const FavoriteButton({super.key, required this.recipeId, this.size = 22});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorite(widget.recipeId);

    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        await _controller.forward();
        if (!mounted) return;
        // Use the previously obtained provider instance instead of accessing
        // the BuildContext after an async gap to satisfy lint rules.
        favoriteProvider.toggleFavorite(widget.recipeId);
      },
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? AppColors.secondaryOrange : Colors.white,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}