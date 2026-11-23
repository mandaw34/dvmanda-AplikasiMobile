import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/providers/favorite_provider.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFav = favoriteProvider.isFavorite(recipe);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar dengan Gambar Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(fontSize: 16, shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
              ),
              background: Image.network(
                recipe.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : null,
                onPressed: () {
                  favoriteProvider.toggle(recipe);
                },
              ),
            ],
          ),

          // 2. Konten Detail (Informasi, Bahan, & Langkah)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${recipe.cuisine} • Kesulitan: ${recipe.difficulty}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Info Waktu & Kalori
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(Icons.timer, 'Prep', '${recipe.prepTimeMinutes} m'),
                      _buildInfoItem(Icons.local_fire_department, 'Cook', '${recipe.cookTimeMinutes} m'),
                      _buildInfoItem(Icons.restaurant, 'Servings', '${recipe.servings} porsi'),
                      _buildInfoItem(Icons.bolt, 'Kalori', '${recipe.caloriesPerServing} kkal'),
                    ],
                  ),
                  const Divider(height: 32),

                  // Judul Bahan
                  Text('Bahan-bahan', style: textTheme.titleLarge),
                ],
              ),
            ),
          ),

          // 3. Daftar Bahan (SliverList)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ing = recipe.ingredients[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(ing)),
                    ],
                  ),
                );
              },
              childCount: recipe.ingredients.length,
            ),
          ),

          // 4. Judul "Langkah" (Sesuai Modul B.5 Sliver)
          if (recipe.instructions.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Text('Langkah', style: textTheme.titleLarge),
              ),
            ),
            
            // 5. Daftar Langkah (SliverList.builder)
            SliverList.builder(
              itemCount: recipe.instructions.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(radius: 12, child: Text('${index + 1}')),
                  title: Text(recipe.instructions[index]),
                ),
              ),
            ),

            // 6. Ruang kosong di bawah
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.deepOrange),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}