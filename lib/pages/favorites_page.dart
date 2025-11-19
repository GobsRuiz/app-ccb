import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.star,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text('Favoritos', style: theme.textTheme.h2),
          const SizedBox(height: 8),
          Text('Seus itens favoritos', style: theme.textTheme.muted),
        ],
      ),
    );
  }
}
