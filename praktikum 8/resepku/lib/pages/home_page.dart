import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/pages/add_recipe_page.dart';
import 'package:resepku/pages/settings_page.dart';
import 'package:resepku/services/recipe_service.dart';
import 'package:resepku/widgets/error_view.dart';
import 'package:resepku/widgets/favorite_badge_button.dart';
import 'package:resepku/widgets/recipe_grid_card.dart';
import 'package:resepku/widgets/recipe_tile.dart';
import 'package:resepku/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isGrid = false;
  String? selectedCuisine;
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = context.read<RecipeService>().fetchRecipes();
  }

  void reload() {
    setState(() {
      recipesFuture = context.read<RecipeService>().fetchRecipes();
    });
  }

  Future<void> refresh() async {
    reload();
    try {
      await recipesFuture;
    } catch (_) {}
  }

  Future<void> openAddPage() async {
    final created = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipePage()),
    );
    if (created == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${created.name}" diterima server dengan id ${created.id}.\ndummyjson hanya menyimulasikan penyimpanan.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            tooltip: 'Cari resep',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            ),
          ),
          IconButton(
            tooltip: isGrid ? 'Tampilan list' : 'Tampilan grid',
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => isGrid = !isGrid),
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
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: 'Gagal memuat resep.\n${snapshot.error}',
              onRetry: reload,
            );
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(child: Text('Belum ada resep.'));
          }

          final cuisines = ['Semua', ...recipes.map((r) => r.cuisine).toSet()];
          final filteredRecipes = selectedCuisine == null || selectedCuisine == 'Semua'
              ? recipes
              : recipes.where((r) => r.cuisine == selectedCuisine).toList();

          return Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    for (final c in cuisines)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: (selectedCuisine == c) || (selectedCuisine == null && c == 'Semua'),
                          onSelected: (selected) {
                            setState(() {
                              selectedCuisine = c;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: isGrid ? buildGrid(filteredRecipes) : buildList(filteredRecipes),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah resep',
        onPressed: openAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildList(List<Recipe> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeTile(recipe: recipes[index]);
      },
    );
  }

  Widget buildGrid(List<Recipe> recipes) {
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