class SpaceModel {
  String id;
  String name;
  String imageUri;
  List<String> timeSlots; // Lista de horários possíveis
  int availableSlots; // Slots disponíveis para reserva
  bool active; // Verifica se o espaço está ativo
  bool available; // Verifica se o espaço está disponível para reserva
  int capacity; // Capacidade do espaço
  String description; // Descrição do espaço
  List<String> reservedTimeSlots; // Lista de horários já reservados

  SpaceModel({
    required this.id,
    required this.name,
    required this.imageUri,
    required this.timeSlots,
    required this.availableSlots,
    required this.active,
    required this.available,
    required this.capacity,
    required this.description,
    required this.reservedTimeSlots, // Inicializando com a lista de horários reservados
  });

  // Método para converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUri': imageUri,
      'timeSlots': timeSlots,
      'availableSlots': availableSlots,
      'active': active,
      'available': available,
      'capacity': capacity,
      'description': description,
      'reservedTimeSlots': reservedTimeSlots, // Adicionando reservedTimeSlots ao JSON
    };
  }

  // Método para criar um SpaceModel a partir de um Map (JSON)
  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json['id'],
      name: json['name'],
      imageUri: json['imageUri'],
      timeSlots: List<String>.from(json['timeSlots']),
      availableSlots: json['availableSlots'],
      active: json['active'],
      available: json['available'],
      capacity: json['capacity'],
      description: json['description'],
      reservedTimeSlots: List<String>.from(json['reservedTimeSlots'] ?? []), // Se não houver reservas, atribui uma lista vazia
    );
  }

  // Método para verificar se um horário está disponível
  bool isTimeSlotAvailable(String timeSlot) {
    return !reservedTimeSlots.contains(timeSlot); // Verifica se o horário não está reservado
  }
}
