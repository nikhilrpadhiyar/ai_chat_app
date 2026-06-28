import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/message_entity.dart';
import '../models/message_model.dart';

class ChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDataSource(this._apiClient);

  /// Streams SSE tokens from the Anthropic Messages API.
  Stream<String> sendMessageStream({
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
    int maxTokens = 8192,
  }) async* {
    final messages = [
      ...history
          .where((m) => m.role != MessageRole.system)
          .map((m) => MessageModel.fromEntity(m).toApiMap()),
      {'role': 'user', 'content': userMessage},
    ];

    final body = <String, dynamic>{
      'model': model,
      'max_tokens': maxTokens,
      'stream': true,
      'messages': messages,
    };

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      body['system'] = systemPrompt;
    }

    final streamController = StreamController<String>();

    try {
      final response = await _apiClient.post<ResponseBody>(
        '/messages',
        data: body,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );

      final responseBody = response.data;
      if (responseBody == null) {
        throw const StreamException('Empty response from API');
      }

      final buffer = StringBuffer();

      responseBody.stream.listen(
        (chunk) {
          buffer.write(utf8.decode(chunk));
          final raw = buffer.toString();
          final lines = raw.split('\n');

          for (int i = 0; i < lines.length - 1; i++) {
            final line = lines[i].trim();
            if (line.startsWith('data: ')) {
              final data = line.substring(6).trim();
              if (data == '[DONE]') continue;
              try {
                final json = jsonDecode(data) as Map<String, dynamic>;
                final type = json['type'] as String?;
                if (type == 'content_block_delta') {
                  final delta = json['delta'] as Map<String, dynamic>?;
                  final text = delta?['text'] as String?;
                  if (text != null && text.isNotEmpty) {
                    streamController.add(text);
                  }
                }
              } catch (_) {}
            }
          }

          // keep any partial line in the buffer
          buffer.clear();
          buffer.write(lines.last);
        },
        onDone: () {
          streamController.close();
        },
        onError: (Object error) {
          if (error is DioException) {
            final mapped = error.error;
            if (mapped is AppException) {
              streamController.addError(mapped);
            } else {
              streamController.addError(StreamException(error.message ?? 'Stream error'));
            }
          } else {
            streamController.addError(StreamException(error.toString()));
          }
          streamController.close();
        },
        cancelOnError: true,
      );

      yield* streamController.stream;
    } on DioException catch (e) {
      final mapped = e.error;
      if (mapped is AppException) throw mapped;
      throw StreamException(e.message ?? 'Streaming failed');
    }
  }
}
