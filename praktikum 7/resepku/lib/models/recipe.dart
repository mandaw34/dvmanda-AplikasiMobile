class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.caloriesPerServing,
    required this.rating,
    required this.image,
    required this.ingredients,
    this.instructions = const [
      'Siapkan bahan-bahan yang diperlukan.',
      'Campurkan semua bahan sesuai takaran.',
      'Masak hingga matang dan sajikan selagi hangat.'
    ], // Nilai bawaan agar data dummy lama tidak error
  });

  final int id;
  final String name;
  final String cuisine;
  final String difficulty;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final int caloriesPerServing;
  final double rating;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;

  // Helper untuk menghitung total waktu masak secara otomatis
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      caloriesPerServing: json['caloriesPerServing'] as int? ?? 0,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : const [
              'Siapkan bahan-bahan yang diperlukan.',
              'Campurkan semua bahan sesuai takaran.',
              'Masak hingga matang dan sajikan selagi hangat.'
            ],
    );
  }
}