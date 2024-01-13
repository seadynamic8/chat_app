import 'package:collection/collection.dart';

enum RoomType { all, unRead, requests }

class Room {
  Room({required this.id});

  final String id;

  static bool exists(List<Room> roomsList, Room room) {
    final existingRoom = roomsList.firstWhereOrNull((r) => r.id == room.id);
    return existingRoom != null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
    );
  }

  Room copyWith({String? id}) {
    return Room(
      id: id ?? this.id,
    );
  }

  @override
  String toString() => 'Room(id: $id)';
}
