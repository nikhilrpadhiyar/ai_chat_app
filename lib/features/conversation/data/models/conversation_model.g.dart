// GENERATED CODE - Hand-written Hive adapter (avoids build_runner requirement)
// ignore_for_file: type=lint

part of 'conversation_model.dart';

class ConversationModelAdapter extends TypeAdapter<ConversationModel> {
  @override
  final int typeId = 1;

  @override
  ConversationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      lastMessage: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      model: fields[5] as String,
      systemPrompt: fields[6] as String?,
      messageCount: fields[7] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lastMessage)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.model)
      ..writeByte(6)
      ..write(obj.systemPrompt)
      ..writeByte(7)
      ..write(obj.messageCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
