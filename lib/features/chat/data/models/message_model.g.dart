// GENERATED CODE - Hand-written Hive adapter (avoids build_runner requirement)
// ignore_for_file: type=lint

part of 'message_model.dart';

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as String,
      conversationId: fields[1] as String,
      roleIndex: fields[2] as int,
      content: fields[3] as String,
      statusIndex: fields[4] as int,
      createdAt: fields[5] as DateTime,
      tokenCount: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.conversationId)
      ..writeByte(2)
      ..write(obj.roleIndex)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.statusIndex)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.tokenCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
