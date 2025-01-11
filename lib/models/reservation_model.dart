class ReservationModel {
  String id;
  String userId;
  String spaceId;
  String timeSlot;
  String spaceName; // Adicionando o campo para o nome do espaço

  ReservationModel({
    required this.id,
    required this.userId,
    required this.spaceId,
    required this.timeSlot,
    required this.spaceName, // Incluindo o nome do espaço no construtor
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'spaceId': spaceId,
      'timeSlot': timeSlot,
      'spaceName': spaceName, // Incluindo o nome do espaço ao converter para JSON
    };
  }

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      userId: json['userId'],
      spaceId: json['spaceId'],
      timeSlot: json['timeSlot'],
      spaceName: json['spaceName'] ?? '', // Se não houver o nome do espaço, define como uma string vazia
    );
  }
}
