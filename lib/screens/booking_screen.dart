import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_app/models/space_model.dart';
import 'package:locate_app/models/reservation_model.dart';
import 'package:locate_app/providers/reservation_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadReservations());
  }

  Future<void> _loadReservations() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(reservationProvider.notifier).loadAllReservations();
    setState(() {
      isLoading = false;
    });
  }

  bool isTimeSlotAvailable(String timeSlot, List<ReservationModel> reservations) {
    for (var reservation in reservations) {
      if (reservation.timeSlot == timeSlot && reservation.spaceId == widget.selectedSpace.id) {
        return false;
      }
    }
    return true;
  }

  Future<void> _updateSpaceAvailability() async {
    final reservations = ref.read(reservationProvider);
    final spaceId = widget.selectedSpace.id;

    final spaceUrl = '$apiUrl/spaces/$spaceId.json';
    final spaceResponse = await http.get(Uri.parse(spaceUrl));
    final spaceData = jsonDecode(spaceResponse.body);
    final SpaceModel space = SpaceModel.fromJson(spaceData);

    // Contar o número de horários reservados para o espaço
    final reservedTimeSlots = reservations
        .where((reservation) => reservation.spaceId == spaceId)
        .map((reservation) => reservation.timeSlot)
        .toSet();

    // Se todos os 7 horários estiverem ocupados, atualizar o estado para 'ocupado'
    if (reservedTimeSlots.length == _timeSlots.length && space.available) {
      space.available = false; // Marcar como ocupado
      await http.put(
        Uri.parse(spaceUrl),
        body: jsonEncode(space.toJson()),
      );
    } else if (reservedTimeSlots.length < _timeSlots.length && !space.available) {
      space.available = true; // Marcar como disponível
      await http.put(
        Uri.parse(spaceUrl),
        body: jsonEncode(space.toJson()),
      );
    }
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

      final reservations = ref.read(reservationProvider);

      bool available = isTimeSlotAvailable(timeSlot, reservations);

      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este horário já está reservado.')),
        );
        return;
      }

      await ref.read(reservationProvider.notifier).addReservation(userId, spaceId, timeSlot);

      // Atualizar a disponibilidade do espaço após fazer a reserva
      await _updateSpaceAvailability();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva feita para ${widget.selectedSpace.name} às $timeSlot')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ref.watch(reservationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazer Reserva'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    if (!widget.selectedSpace.available)
                      const Text(
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
                        final isAvailable = isTimeSlotAvailable(slot, reservations);
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
                      onChanged: widget.selectedSpace.available
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
                        onPressed: widget.selectedSpace.available && _selectedTimeSlot != null
                            ? _submitReservation
                            : null,
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
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
