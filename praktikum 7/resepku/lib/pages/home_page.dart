import 'package:flutter/material.dart';
import 'package:resepku/data/dummy_recipes.dart';
import 'package:resepku/pages/settings_page.dart';
import 'package:resepku/widgets/favorite_badge_button.dart';
import 'package:resepku/widgets/recipe_grid_card.dart';
import 'package:resepku/widgets/recipe_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isGrid = false; // Ephemeral state untuk list/grid
  String? _cuisine;     // Ephemeral state untuk filter cuisine (null = Semua)

  @override
  Widget build(BuildContext context) {
    // Ambil daftar cuisine unik dari data resep
    final cuisines = ['Semua', ...dummyRecipes.map((r) => r.cuisine).toSet()];

    // Filter resep berdasarkan pilihan _cuisine
    final filteredRecipes = _cuisine == null || _cuisine == 'Semua'
        ? dummyRecipes
        : dummyRecipes.where((r) => r.cuisine == _cuisine).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('ResepKu'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Tampilan list' : 'Tampilan grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          const FavoriteBadgeButton(),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Baris ChoiceChip Horizontal untuk Filter Cuisine (Latihan 1)
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: cuisines.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = cuisines[index];
                final isSelected = (_cuisine == null && item == 'Semua') || _cuisine == item;
                
                return ChoiceChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _cuisine = (item == 'Semua') ? null : item;
                    });
                  },
                );
              },
            ),
          ),
          // Area konten resep (List atau Grid) yang sudah difilter
          Expanded(
            child: _isGrid ? buildGrid(filteredRecipes) : buildList(filteredRecipes),
          ),
        ],
      ),
    );
  }

  Widget buildList(List recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeTile(recipe: recipes[index]);
      },
    );
  }

  Widget buildGrid(List recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3 / 4,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeGridCard(recipe: recipes[index]);
      },
    );
  }
}