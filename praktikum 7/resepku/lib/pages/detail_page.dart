import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<FavoriteProvider>().isFavorite(recipe);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () => context.read<FavoriteProvider>().toggle(recipe),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bagian D.1: Foto besar di halaman detail
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: RecipeImage(url: recipe.image),
            ),
          ),
          const SizedBox(height: 16),

          // Judul Resep & Keterangan
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kategori: ${recipe.cuisine} • Waktu: ${recipe.totalTimeMinutes} menit • Rating: ★${recipe.rating}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(height: 24),

          // Bagian Bahan-bahan
          Text(
            'Bahan-bahan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (final ingredient in recipe.ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(child: Text(ingredient)),
                ],
              ),
            ),
          const Divider(height: 24),

          // Bagian Instruksi / Langkah-langkah
          Text(
            'Langkah Pembuatan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < recipe.instructions.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}. '),
                  Expanded(child: Text(recipe.instructions[i])),
                ],
              ),
            ),
        ],
      ),
    );
  }
}