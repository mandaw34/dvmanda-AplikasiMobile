import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resepku/models/recipe.dart';

/// Semua komunikasi ResepKu dengan REST API dummyjson.com ada di class ini.
/// Widget tidak memanggil http secara langsung.
class RecipeService {
  RecipeService({http.Client? client}) : client = client ?? http.Client();
  final http.Client client;

  static const _baseUrl = 'https://dummyjson.com';
  static const _timeout = Duration(seconds: 10);

  /// GET /recipes?limit=50 mengambil daftar resep.
  Future<List<Recipe>> fetchRecipes({int limit = 50}) async {
    final uri = Uri.parse('$_baseUrl/recipes?limit=$limit');
    final response = await client.get(uri).timeout(_timeout);
    _checkStatus(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['recipes'] as List<dynamic>;
    return list
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /recipes/search?q=query mencari resep berdasarkan kata kunci.
  Future<List<Recipe>> searchRecipes(String query) async {
    final uri = Uri.parse('$_baseUrl/recipes/search').replace(
      queryParameters: {'q': query},
    );
    final response = await client.get(uri).timeout(_timeout);
    _checkStatus(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['recipes'] as List<dynamic>;
    return list
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /recipes/add mengirim resep baru.
  Future<Recipe> addRecipe({
    required String name,
    required String cuisine,
    required int cookTimeMinutes,
  }) async {
    final uri = Uri.parse('$_baseUrl/recipes/add');
    final response = await client
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'cuisine': cuisine,
            'cookTimeMinutes': cookTimeMinutes,
          }),
        )
        .timeout(_timeout);
    _checkStatus(response);
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// PUT /recipes/{id} mengubah nama resep.
  Future<Recipe> updateRecipe({
    required int id,
    required String name,
  }) async {
    final uri = Uri.parse('$_baseUrl/recipes/$id');
    final response = await client
        .put(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name}),
        )
        .timeout(_timeout);
    _checkStatus(response);
    return Recipe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// DELETE /recipes/{id} menghapus resep.
  Future<bool> deleteRecipe(int id) async {
    final uri = Uri.parse('$_baseUrl/recipes/$id');
    final response = await client.delete(uri).timeout(_timeout);
    _checkStatus(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['isDeleted'] as bool? ?? false;
  }

  /// Status 2xx berarti berhasil. Selain itu, lempar exception
  /// agar FutureBuilder masuk ke error state.
  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RecipeServiceException(
        'Server menjawab dengan status ${response.statusCode}',
      );
    }
  }

  void close() => client.close();
}

class RecipeServiceException implements Exception {
  RecipeServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}