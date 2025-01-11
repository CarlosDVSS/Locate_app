class SpaceModel {
  String id;
  String name;
  String imageUri;
  List<String> timeSlots;
  int availableSlots;
  bool active;
  bool available;
  int capacity;
  String description;

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
    );
  }
}
