import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/core/network/api_client.dart';
import 'package:ai_chat_app/features/chat/data/models/message_model.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:dio/dio.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this._apiClient);
  final ApiClient _apiClient;

  /// Streams SSE tokens from the Anthropic Messages API.
  Stream<String> sendMessageStream({
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
    int maxTokens = 8192,
  }) async* {
    final List<Map<String, dynamic>> messages = <Map<String, dynamic>>[
      ...history
          .where((MessageEntity m) => m.role != MessageRole.system)
          .map((MessageEntity m) => MessageModel.fromEntity(m).toApiMap()),
      <String, String>{'role': 'user', 'content': userMessage},
    ];

    final Map<String, dynamic> body = <String, dynamic>{
      'model': model,
      'max_tokens': maxTokens,
      'stream': true,
      'messages': messages,
    };

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      body['system'] = systemPrompt;
    }

    final StreamController<String> streamController =
        StreamController<String>();

    try {
      final Response<ResponseBody> response = await _apiClient
          .post<ResponseBody>(
            '/messages',
            data: body,
            options: Options(
              responseType: ResponseType.stream,
              headers: <String, dynamic>{'Accept': 'text/event-stream'},
            ),
          );

      final ResponseBody? responseBody = response.data;
      if (responseBody == null) {
        throw const StreamException('Empty response from API');
      }

      final StringBuffer buffer = StringBuffer();

      responseBody.stream.listen(
        (Uint8List chunk) {
          buffer.write(utf8.decode(chunk));
          final String raw = buffer.toString();
          final List<String> lines = raw.split('\n');

          for (int i = 0; i < lines.length - 1; i++) {
            final String line = lines[i].trim();
            if (line.startsWith('data: ')) {
              final String data = line.substring(6).trim();
              if (data == '[DONE]') continue;
              try {
                final Map<String, dynamic> json =
                    jsonDecode(data) as Map<String, dynamic>;
                final String? type = json['type'] as String?;
                if (type == 'content_block_delta') {
                  final Map<String, dynamic>? delta =
                      json['delta'] as Map<String, dynamic>?;
                  final String? text = delta?['text'] as String?;
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
            final Object? mapped = error.error;
            if (mapped is AppException) {
              streamController.addError(mapped);
            } else {
              streamController.addError(
                StreamException(error.message ?? 'Stream error'),
              );
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
      final Object? mapped = e.error;
      if (mapped is AppException) throw mapped;
      throw StreamException(e.message ?? 'Streaming failed');
    }
  }
}
