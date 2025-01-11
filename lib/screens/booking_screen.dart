import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/models/reservation_model.dart';
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
  bool isLoading = false;

  // Função para verificar se o horário está disponível
  bool isTimeSlotAvailable(String timeSlot, List<ReservationModel> reservations) {
    // Verifica se já existe uma reserva para o mesmo horário e espaço
    for (var reservation in reservations) {
      if (reservation.timeSlot == timeSlot && reservation.spaceId == widget.selectedSpace.id) {
        return false; // Horário já está ocupado para este espaço
      }
    }
    return true; // Horário disponível
  }

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

      // Carregar todas as reservas do sistema
      setState(() {
        isLoading = true;
      });
      await ref.read(reservationProvider.notifier).loadAllReservations(); // Carregar todas as reservas
      final reservations = ref.read(reservationProvider);

      // Verifica a disponibilidade do horário
      bool available = isTimeSlotAvailable(timeSlot, reservations);

      setState(() {
        isLoading = false;
      });

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este horário já está reservado.')),
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
              // Verifica se o espaço está ativo e disponível para permitir a seleção de horário
              if (!widget.selectedSpace.active)
                Text(
                  'Este espaço não está disponível para reservas.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                ),
                items: _timeSlots.map((slot) {
                  final isAvailable = isTimeSlotAvailable(slot, ref.read(reservationProvider));
                  return DropdownMenuItem(
                    value: slot,
                    child: Text(
                      slot + (isAvailable ? '' : ' (Ocupado)'),
                      style: TextStyle(
                        color: isAvailable ? null : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: widget.selectedSpace.active
                    ? (value) {
                        setState(() {
                          _selectedTimeSlot = value;
                        });
                      }
                    : null,
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
                  onPressed: widget.selectedSpace.active && _selectedTimeSlot != null
                      ? _submitReservation
                      : null,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
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
