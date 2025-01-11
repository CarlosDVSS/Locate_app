import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/providers/reservation_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final SpaceModel selectedSpace;

  const BookingScreen({super.key, required this.selectedSpace});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _timeSlots = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
    '20:00 - 22:00',
  ];

  String? _selectedTimeSlot;

  void _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final spaceId = widget.selectedSpace.id;
      final timeSlot = _selectedTimeSlot;

      if (timeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione um horário.')),
        );
        return;
      }

      // Adicionar reserva usando o provider
      await ref.read(reservationProvider.notifier).addReservation(userId, spaceId, timeSlot);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva feita para ${widget.selectedSpace.name} às $timeSlot')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazer Reserva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Espaço: ${widget.selectedSpace.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                ),
                items: _timeSlots.map((slot) {
                  return DropdownMenuItem(
                    value: slot,
                    child: Text(slot),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimeSlot = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um horário.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReservation,
                  child: const Text(
                    'Reservar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
