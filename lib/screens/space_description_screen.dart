import 'package:flutter/material.dart';
import 'package:locate_app/screens/booking_screen.dart';

class SpaceDescription extends StatelessWidget {
  final String name;
  final String description;
  final String imageUri;
  final int capacity;
  final bool active;

  const SpaceDescription({
    super.key,
    required this.name,
    required this.description,
    required this.imageUri,
    required this.capacity,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Divider(height: 10, color: Colors.grey[800]),
              const SizedBox(height: 8),
              
              Image.asset(
                imageUri,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              
              const SizedBox(height: 8),
              Divider(height: 10, color: Colors.grey[800],),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      'Status: ', 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active ? Colors.green : Colors.red
                      ),
                      child: Center(
                        child: Text(
                          active ? 'Ativo' : 'Inativo'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Capacidade: $capacity',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ),
              const Text(
                'Descrição',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const BookingScreen()
                    )
                );
                  }, 
                  child: const Center(
                    child: Text(
                      'Fazer Reserva', 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}