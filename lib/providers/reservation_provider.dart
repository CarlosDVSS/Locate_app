import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_app/models/reservation_model.dart';
import 'package:http/http.dart' as http;

const apiUrl = "https://rest-locator-34bab-default-rtdb.firebaseio.com/";

class ReservationNotifier extends StateNotifier<List<ReservationModel>> {
  ReservationNotifier() : super([]);

  bool isLoading = false;

  // Carregar todas as reservas de um usuário específico, incluindo o nome do espaço
  Future<void> loadUserReservations(String userId) async {
    final url = '$apiUrl/reservations.json?orderBy="userId"&equalTo="$userId"';

    isLoading = true;
    state = [];  // Limpar o estado antes de carregar as reservas

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (data != null) {
        final List<ReservationModel> loadedReservations = [];
        // Buscar o nome do espaço para cada reserva
        for (var key in data.keys) {
          var reservationData = data[key];
          final spaceId = reservationData['spaceId'];
          
          // Buscar o nome do espaço (supondo que você tem um endpoint para pegar o nome do espaço)
          final spaceUrl = '$apiUrl/spaces/$spaceId.json';
          final spaceResponse = await http.get(Uri.parse(spaceUrl));
          final spaceData = jsonDecode(spaceResponse.body);
          final spaceName = spaceData['name']; // Pegando o nome do espaço

          // Adiciona o nome do espaço na reserva
          reservationData['spaceName'] = spaceName;
          reservationData['id'] = key;
          loadedReservations.add(ReservationModel.fromJson(reservationData));
        }

        state = loadedReservations;
      }
    } catch (e) {
      print('Erro ao carregar reservas: $e');
    } finally {
      isLoading = false;
    }
  }

  // Carregar todas as reservas (para verificar disponibilidade no booking screen)
  Future<void> loadAllReservations() async {
    final url = '$apiUrl/reservations.json';
    isLoading = true;
    state = [];  // Limpar o estado antes de carregar as reservas

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body) as Map<String, dynamic>?;

      if (data != null) {
        final List<ReservationModel> loadedReservations = [];
        for (var key in data.keys) {
          var reservationData = data[key];
          final spaceId = reservationData['spaceId'];

          final spaceUrl = '$apiUrl/spaces/$spaceId.json';
          final spaceResponse = await http.get(Uri.parse(spaceUrl));
          final spaceData = jsonDecode(spaceResponse.body);
          final spaceName = spaceData['name'];

          reservationData['spaceName'] = spaceName;
          reservationData['id'] = key;
          loadedReservations.add(ReservationModel.fromJson(reservationData));
        }
        state = loadedReservations;
      }
    } catch (e) {
      print('Erro ao carregar todas as reservas: $e');
    } finally {
      isLoading = false;
    }
  }

  // Criar nova reserva
  Future<void> addReservation(String userId, String spaceId, String timeSlot) async {
    final url = '$apiUrl/reservations.json';
    final newReservation = ReservationModel(
      id: DateTime.now().toString(),
      userId: userId,
      spaceId: spaceId,
      timeSlot: timeSlot,
      spaceName: '', // Inicialize como vazio, pois o nome será preenchido no futuro
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(newReservation.toJson()),
      );
      if (response.statusCode == 200) {
        state = [...state, newReservation]; // Atualiza o estado com a nova reserva
      }
    } catch (e) {
      print('Erro ao criar reserva: $e');
    }
  }

  // Cancelar reserva
  Future<void> cancelReservation(String reservationId) async {
    final url = '$apiUrl/reservations/$reservationId.json';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        state = state.where((reservation) => reservation.id != reservationId).toList();
      }
    } catch (e) {
      print('Erro ao cancelar reserva: $e');
    }
  }
}

final reservationProvider = StateNotifierProvider<ReservationNotifier, List<ReservationModel>>((ref) {
  return ReservationNotifier();
});
