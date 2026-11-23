import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/services/recipe_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _servings = 1;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
  }

  void _incrementServing() => setState(() => _servings++);
  void _decrementServing() => setState(() => _servings--);

  // Fungsi untuk menampilkan dialog Ubah Nama (PUT)
  Future<void> _showUpdateDialog(BuildContext context) async {
    final controller = TextEditingController(text: widget.recipe.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama Resep'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nama baru'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final service = context.read<RecipeService>();
      final updated = await service.updateRecipe(
        id: widget.recipe.id,
        name: controller.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil diubah: ${updated.name} (simulasi)')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah: $e')),
      );
    }
  }

  // Fungsi untuk menampilkan dialog Konfirmasi Hapus (DELETE)
  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Resep'),
        content: Text('Yakin ingin menghapus "${widget.recipe.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final service = context.read<RecipeService>();
      final isDeleted = await service.deleteRecipe(widget.recipe.id);
      if (!mounted) return;
      if (isDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil dihapus (simulasi)')),
        );
        Navigator.pop(context); // Tutup halaman detail kembali ke Home
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final textTheme = Theme.of(context).textTheme;
    final favoriteProvider = context.watch<FavoriteProvider>();
    final isFavorite = favoriteProvider.isFavorite(recipe);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
              background: Image.network(
                recipe.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey),
              ),
            ),
            actions: [
              // Tombol Favorit
              IconButton(
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => favoriteProvider.toggle(recipe),
              ),
              // Tombol Menu Ubah & Hapus (PopupMenuButton untuk Latihan 2)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showUpdateDialog(context);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Ubah nama'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus resep'),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.cuisine, style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Waktu memasak: ${recipe.cookTimeMinutes} menit'),
                  const SizedBox(height: 16),
                  Text('Bahan-bahan', style: textTheme.titleLarge),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: recipe.ingredients.length,
            itemBuilder: (context, index) => ListTile(
              dense: true,
              leading: const Icon(Icons.fiber_manual_record, size: 8),
              title: Text(recipe.ingredients[index]),
            ),
          ),
          if (recipe.instructions.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Text('Langkah', style: textTheme.titleLarge),
              ),
            ),
            SliverList.builder(
              itemCount: recipe.instructions.length,
              itemBuilder: (context, index) => ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 12,
                  child: Text('${index + 1}'),
                ),
                title: Text(recipe.instructions[index]),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}