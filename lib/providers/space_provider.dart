import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_app/models/space_model.dart';

final spaceProvider = StateProvider<List<SpaceModel>>((ref) {
  return [
    SpaceModel(
      id: '1',
      name: 'Sala de Reuniões',
      imageUri: 'assets/sala_reuniao.png',
      active: true,
      available: true,
    ),

    SpaceModel(
      id: '2',
      name: 'Espaço de Eventos',
      imageUri: 'assets/espaço_eventos.jpg',
      active: true,
      available: false,
    ),
  ];
});

final searchTermProvider = StateProvider<String>((ref) => ''); // Provider para a barra de pesquisas

final filteredSpacesProvider = Provider<List<SpaceModel>>((ref) {
  final searchTerm = ref.watch(searchTermProvider);
  final spaces = ref.watch(spaceProvider);

  if (searchTerm.isEmpty) {
    return spaces;
  }

  return spaces.where((space) {
    return space.name.toLowerCase().contains(searchTerm);
  }).toList();
});