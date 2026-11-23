import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  void _confirmClear(BuildContext context, FavoriteProvider favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Favorit'),
        content: const Text('Apakah Anda yakin ingin menghapus semua daftar resep favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              favorite.clear();
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorite = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          IconButton(
            tooltip: 'Hapus semua',
            icon: const Icon(Icons.delete_sweep),
            // Tombol nonaktif (null) jika daftar kosong
            onPressed: favorite.count == 0 ? null : () => _confirmClear(context, favorite),
          ),
        ],
      ),
      body: favorite.count == 0
          ? const Center(
              child: Text(
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              children: [
                for (final recipe in favorite.items)
                  ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.cuisine),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => favorite.toggle(recipe),
                    ),
                  ),
              ],
            ),
    );
  }
}