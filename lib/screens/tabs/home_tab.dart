import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/screens/space_description_screen.dart';

class ExpansionStateNotifier extends StateNotifier<Map<String, bool>> {
  ExpansionStateNotifier()
    : super({
      'active': true,
      'inactive': false
    });

  void toggle(String key){
    state = {
      ...state,
      key: !state[key]!,
    };
  }
}

final expansionStateProvider =
  StateNotifierProvider<ExpansionStateNotifier, Map<String, bool>>(
    (ref) => ExpansionStateNotifier()
  );

class HomeTab extends ConsumerWidget {
  final List<SpaceModel> spaces;

  const HomeTab({super.key, required this.spaces});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expansionState = ref.watch(expansionStateProvider);

    final activeSpaces = spaces.where((space) => space.active).toList();
    final inactiveSpaces = spaces.where((space) => !space.active).toList();

    return spaces.isEmpty
        ? const Center(
            child: Text(
              'Nenhum Espaço encontrado...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        : ListView(
          children: [
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                ref.read(expansionStateProvider.notifier).toggle('active');
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(
                        'Ativos (${activeSpaces.length})',
                        style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                        ),
                      )
                    );
                  }, 
                  body: _buildSpaceList(context, activeSpaces),
                  isExpanded: expansionState['active']!,
                )
              ],
            )
          ],
      );
  }
  Widget _buildSpaceList(BuildContext context, List<SpaceModel> spaces) {
    return Column(
      children: spaces.map((space) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpaceDescription(space: space),
              ),
            );
          },
          child: Card(
            color:  Colors.grey[900],
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: ListTile(
              leading: Image.asset(
                space.imageUri,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(space.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capacidade: ${space.capacity}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  Text(
                    space.active
                      ? space.available
                        ? 'Disponível'
                        : 'Ocupado'
                      : 'Indisponível',
                      style: TextStyle(color: space.available ? Colors.green : Colors.red),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}