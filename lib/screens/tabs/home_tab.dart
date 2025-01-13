import 'package:flutter/material.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/screens/space_description_screen.dart';

class HomeTab extends StatelessWidget {
  final List<SpaceModel> spaces;

  const HomeTab({super.key, required this.spaces});

  @override
  Widget build(BuildContext context) {
    // Organiza os espaços na ordem desejada: disponível primeiro, depois ocupado e por último inativo.
    final sortedSpaces = [
      ...spaces.where((space) => space.active && space.available),
      ...spaces.where((space) => space.active && !space.available),
      ...spaces.where((space) => !space.active),
    ];

    // Retorna uma mensagem centralizada se não houver espaços.
    if (sortedSpaces.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum espaço encontrado...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: sortedSpaces.length,
      itemBuilder: (context, index) {
        final space = sortedSpaces[index];

        return GestureDetector(
          onTap: space.active
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpaceDescription(space: space),
                    ),
                  );
                }
              : null,
          child: Card(
            color: space.active ? Colors.grey[900] : Colors.grey[800],
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  space.imageUri,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  color: space.active ? null : Colors.grey,
                  colorBlendMode: space.active ? null : BlendMode.saturation,
                ),
              ),
              title: Text(
                space.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: space.active ? Colors.white : Colors.grey[400],
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.active
                          ? (space.available ? 'Disponível' : 'Ocupado')
                          : 'Indisponível',
                      style: TextStyle(
                        color: space.active
                            ? (space.available ? Colors.green : Colors.red)
                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      space.active ? 'Ativo' : 'Inativo',
                      style: TextStyle(
                        fontSize: 12,
                        color: space.active ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Exibindo a capacidade do espaço
                    Text(
                      'Capacidade: ${space.capacity}',
                      style: TextStyle(
                        fontSize: 14,
                        color: space.active ? Colors.white70 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                space.active ? Icons.chevron_right : Icons.block,
                color: space.active ? Colors.orange : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
