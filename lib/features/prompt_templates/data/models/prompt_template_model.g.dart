// GENERATED CODE - Hand-written Hive adapter (avoids build_runner requirement)
// ignore_for_file: type=lint

part of 'prompt_template_model.dart';

class PromptTemplateModelAdapter extends TypeAdapter<PromptTemplateModel> {
  @override
  final int typeId = 2;

  @override
  PromptTemplateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromptTemplateModel(
      id: fields[0] as String,
      name: fields[1] as String,
      prompt: fields[2] as String,
      description: fields[3] as String?,
      emoji: fields[4] as String?,
      isBuiltIn: fields[5] as bool,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PromptTemplateModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.prompt)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.emoji)
      ..writeByte(5)
      ..write(obj.isBuiltIn)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptTemplateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
