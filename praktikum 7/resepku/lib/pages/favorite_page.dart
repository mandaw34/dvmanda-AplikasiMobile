import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/pages/detail_page.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan watch untuk memantau perubahan daftar favorit
    final favoriteProvider = context.watch<FavoriteProvider>();
    final favorites = favoriteProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Favorit'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Belum ada resep favorit.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final recipe = favorites[index];

                return Dismissible(
                  // Wajib menggunakan key yang unik dan stabil (ValueKey berdasarkan ID)
                  key: ValueKey(recipe.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    // Hapus dari provider
                    context.read<FavoriteProvider>().toggle(recipe);

                    // Tampilkan SnackBar konfirmasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${recipe.name} dihapus dari favorit'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: RecipeImage(url: recipe.image, cacheWidth: 168),
                      ),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text('${recipe.cuisine} • ${recipe.totalTimeMinutes} menit'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(recipe: recipe),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}