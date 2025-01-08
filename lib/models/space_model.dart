class SpaceModel {
  final String id;
  final String name;
  final String imageUri;
  final bool active;
  final bool available;
  final String description;
  final int capacity;

  SpaceModel({
    required this.id,
    required this.name,
    required this.imageUri,
    required this.active,
    required this.available,
    required this.description,
    required this.capacity,
  });
}