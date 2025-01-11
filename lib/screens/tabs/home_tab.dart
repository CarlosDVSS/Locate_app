import 'package:flutter/material.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/screens/space_description_screen.dart';

class HomeTab extends StatelessWidget {
  final List<SpaceModel> spaces;

  const HomeTab({super.key, required this.spaces});

  @override
  Widget build(BuildContext context) {
    return spaces.isEmpty
        ? const Center(
            child: Text(
              'Nenhum Espaço encontrado...',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        : ListView.builder(
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final space = spaces[index];

              return GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpaceDescription(
                                name: space.name,
                                description: space. description,
                                imageUri: space.imageUri,
                                capacity: space.capacity,
                                active: space.active,
                              )))
                },
                child: Card(
                  color: Colors.grey[900],
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                          'Capacidade: ${space.capacity} (${space.availableSlots} horários disponíveis.)',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[400]),
                        ),
                        Text(
                          space.active
                              ? space.available
                                  ? 'Disponível'
                                  : 'Ocupado'
                              : 'Indisponível',
                          style: TextStyle(
                            color: space.available ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          space.active ? 'Ativo' : 'Inativo',
                          style: TextStyle(
                            color: space.active ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
