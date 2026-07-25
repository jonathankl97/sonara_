import 'package:sonara/features/rooms/data/enums/room_enums.dart';

class RoomEquipmentModel {
  final RoomEquipmentCategory category;
  final String name;

  const RoomEquipmentModel({
    required this.category,
    required this.name,
  });

  factory RoomEquipmentModel.fromJson(Map<String, dynamic> json) {
    return RoomEquipmentModel(
      category: RoomEquipmentCategory.fromValue(json['category'] as String),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'category': category.value, 'name': name};
  }
}