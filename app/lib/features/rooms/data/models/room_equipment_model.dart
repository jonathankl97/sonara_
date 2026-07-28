import 'package:flutter/material.dart';
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

const categoryLabels = {
  RoomEquipmentCategory.daw: 'DAW',
  RoomEquipmentCategory.microphone: 'Mikrofon',
  RoomEquipmentCategory.mixer: 'Mischpult',
  RoomEquipmentCategory.audioInterface: 'Audio-Interface',
  RoomEquipmentCategory.monitor: 'Monitor',
  RoomEquipmentCategory.headphones: 'Kopfhörer',
  RoomEquipmentCategory.instrument: 'Instrument',
  RoomEquipmentCategory.djGear: 'DJ-Equipment',
  RoomEquipmentCategory.outboard: 'Outboard',
  RoomEquipmentCategory.other: 'Sonstiges',
};

class EquipmentEntry {
  RoomEquipmentCategory category;
  final TextEditingController nameController;

  EquipmentEntry({
    this.category = RoomEquipmentCategory.daw,
    TextEditingController? nameController,
  }) : nameController = nameController ?? TextEditingController();

  void dispose() {
    nameController.dispose();
  }
}