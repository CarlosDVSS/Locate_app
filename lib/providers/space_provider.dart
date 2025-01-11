import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:locate_app/models/space_model.dart';

const apiUrl = "https://rest-locator-34bab-default-rtdb.firebaseio.com/";

class SpaceNotifier extends StateNotifier<List<SpaceModel>> {
  bool isLoading = false; // Controla o estado de carregamento

  SpaceNotifier() : super([]) {
    // Carregar espaços ao inicializar o Notifier
    loadSpaces();
  }

  // Carregar todos os espaços
  Future<void> loadSpaces() async {
    isLoading = true; // Inicia o carregamento
    state = []; // Limpa o estado anterior para evitar dados duplicados
    final url = '$apiUrl/spaces.json';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (data != null) {
        final List<SpaceModel> loadedSpaces = [];
        data.forEach((key, value) {
          value['id'] = key; // Define o ID gerado pelo Firebase
          loadedSpaces.add(SpaceModel.fromJson(value));
        });

        state = loadedSpaces; // Atualiza o estado com os espaços carregados
      }
    } catch (e) {
      print('Erro ao carregar espaços: $e');
    } finally {
      isLoading = false; // Finaliza o carregamento
    }
  }
}

final spaceProvider =
    StateNotifierProvider<SpaceNotifier, List<SpaceModel>>((ref) {
  return SpaceNotifier();
});

final searchTermProvider = StateProvider<String>((ref) => '');

// Provider para espaços filtrados
final filteredSpacesProvider = Provider<List<SpaceModel>>((ref) {
  final searchTerm = ref.watch(searchTermProvider);
  final spaces = ref.watch(spaceProvider);

  if (searchTerm.isEmpty) {
    return spaces;
  }

  return spaces.where((space) {
    return space.name.toLowerCase().contains(searchTerm.toLowerCase());
  }).toList();
});
