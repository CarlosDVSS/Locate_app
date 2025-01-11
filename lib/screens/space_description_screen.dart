import 'package:flutter/material.dart';
import 'package:locate_app/screens/booking_screen.dart';
import 'package:locate_app/models/space_model.dart';

class SpaceDescription extends StatelessWidget {
  final SpaceModel space;

  const SpaceDescription({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      space.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      space.imageUri,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(space.active),
                      _buildCapacityChip(space.capacity),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Descrição',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    space.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navegar para a tela de reserva e passar o espaço selecionado
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              selectedSpace: space,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text(
                        'Fazer Reserva',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool active) {
    return Chip(
      label: Text(
        active ? 'Ativo' : 'Inativo',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: active ? Colors.green : Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    );
  }

  Widget _buildCapacityChip(int capacity) {
    return Chip(
      label: Text(
        'Capacidade: $capacity',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueGrey,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    );
  }
}
