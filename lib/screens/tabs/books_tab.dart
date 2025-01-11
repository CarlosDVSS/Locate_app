import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_app/providers/reservation_provider.dart';

class BooksTab extends ConsumerStatefulWidget {
  const BooksTab({super.key});

  @override
  _BooksTabState createState() => _BooksTabState();
}

class _BooksTabState extends ConsumerState<BooksTab> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Usar Future.delayed para carregar as reservas após a construção do widget
    _loadReservations();
  }

  void _loadReservations() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      await Future.delayed(Duration.zero, () {
        ref.read(reservationProvider.notifier).loadUserReservations(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ref.watch(reservationProvider);
    final isLoading = ref.watch(reservationProvider.notifier).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas Reservas'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? const Center(child: Text('Nenhuma reserva encontrada'))
              : ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    return Card(
                      color: Colors.grey[900],
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.white),
                        // Exibe o nome do espaço
                        title: Text(reservation.spaceName),
                        subtitle: Text(
                          'Horário: ${reservation.timeSlot}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Chama o método de cancelamento
                            await ref.read(reservationProvider.notifier).cancelReservation(reservation.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reserva cancelada')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
