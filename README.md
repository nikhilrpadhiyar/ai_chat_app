<div align="center">

# AI Chat App

**A production-grade Flutter AI chat app powered by the Anthropic Claude API.**

[![CI](https://github.com/nikhilrpadhiyar/ai_chat_app/actions/workflows/ci.yml/badge.svg)](https://github.com/nikhilrpadhiyar/ai_chat_app/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.11.5+-02569B?logo=flutter)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/GetX-4.6.6-blueviolet)](https://pub.dev/packages/get)
[![Claude](https://img.shields.io/badge/Powered%20by-Claude%20API-orange)](https://docs.anthropic.com)

Real-time streaming responses from Claude, rendered as rich Markdown. Persistent conversation history, voice input, prompt templates, and a polished dark-mode UI.

</div>

---

## Features

| Category | Details |
|---|---|
| Streaming | Live token-by-token streaming from the Anthropic Messages API (SSE) |
| Markdown | AI responses rendered with full Markdown: code blocks, tables, lists, bold, italic |
| Conversation History | All chats stored locally in Hive; browse, resume, or delete any conversation |
| Voice Input | Dictate messages using the device microphone via `speech_to_text` |
| Prompt Templates | 6 built-in templates + create/save your own |
| Secure API Key | API key stored in device keychain/keystore via `flutter_secure_storage` |
| Model Selection | Switch between Claude Sonnet, Haiku, and Opus in settings |
| System Prompt | Set a global system prompt for all new conversations |
| Dark Mode | Material 3, full light/dark theme, persisted preference |
| Onboarding | First-run flow guides user to enter their Anthropic API key |
| Copy to Clipboard | Long-press any message bubble to copy its content |
| Error Handling | Typed failure hierarchy: rate limits, auth errors, network issues |

---

## Architecture

Feature-first Clean Architecture with GetX:

```
UI (Page)
   |
Controller       (GetX — reactive state, user actions)
   |
Use Case         (domain — single-responsibility business rules)
   |
Repository       (domain interface / data layer implementation)
   |
LocalDataSource  (Hive — offline-first persistence)
RemoteDataSource (Anthropic API via Dio — streaming SSE)
```

### Folder Structure

```
lib/
|-- core/
|   |-- constants/       AppConstants, AppSpacing
|   |-- error/           Exceptions and Failures (typed per layer)
|   |-- network/         ApiClient (Dio), Auth/Error/Logging interceptors
|   |-- storage/         StorageService (GetStorage), SecureStorageService, HiveStorage
|   |-- theme/           AppTheme, AppColors, AppTextStyles
|   +-- utils/           Validators, Extensions, ConnectivityService
|
|-- features/
|   |-- onboarding/      First-run API key setup
|   |-- chat/
|   |   |-- data/        MessageModel (Hive), ChatLocalDS, ChatRemoteDS (streaming), RepoImpl
|   |   |-- domain/      MessageEntity, ChatRepository, SendMessage/GetMessages UseCases
|   |   +-- presentation/ ChatController, ChatBinding, ChatPage, MessageBubble, ChatInputBar
|   |-- conversation/
|   |   |-- data/        ConversationModel (Hive), ConversationLocalDS, RepoImpl
|   |   |-- domain/      ConversationEntity, Repository, 3 UseCases
|   |   +-- presentation/ ConversationController, ConversationsPage
|   |-- prompt_templates/
|   |   |-- data/        PromptTemplateModel (Hive), LocalDS, RepoImpl
|   |   |-- domain/      PromptTemplateEntity, BuiltInTemplates, Repository
|   |   +-- presentation/ PromptTemplateController, PromptTemplatesPage
|   +-- settings/        SettingsController, SettingsPage
|
|-- routes/              AppRoutes, AppPages
|-- firebase_options.dart (placeholder — replace with flutterfire configure)
+-- main.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.5
- An [Anthropic API key](https://console.anthropic.com)

### 1. Clone and install

```bash
git clone https://github.com/nikhilrpadhiyar/ai_chat_app.git
cd ai_chat_app
flutter pub get
```

### 2. Run

```bash
flutter run
```

On first launch the onboarding screen prompts for your Anthropic API key. The key is written to the device keychain (iOS) or EncryptedSharedPreferences (Android) and never stored in plaintext.

### 3. Firebase (optional)

The app runs fully without Firebase. If you want analytics or Crashlytics:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

---

## Streaming Implementation

The `ChatRemoteDataSource` opens a streaming Dio request (`ResponseType.stream`) to the Anthropic `/v1/messages` endpoint with `"stream": true`. It parses the `text/event-stream` lines, extracts `content_block_delta` events, and yields each token through a Dart `Stream<String>`.

`ChatController` listens to this stream and updates the assistant `MessageEntity` in place on every token, triggering a reactive `Obx` rebuild in `MessageBubble`. The typing indicator disappears when the stream closes.

```
Anthropic API (SSE)
    |
ChatRemoteDataSource.sendMessageStream()  — Stream<String> (raw tokens)
    |
ChatRepositoryImpl                        — Stream<Either<Failure, String>>
    |
SendMessageUseCase
    |
ChatController (GetX)                     — messages[i].content updated per token
    |
MessageBubble (Obx)                       — rebuilt per token via flutter_markdown
```

---

## Data Models

### MessageModel (Hive typeId: 0)

| Field | Type | Description |
|---|---|---|
| `id` | String | UUID v4 |
| `conversationId` | String | Parent conversation |
| `roleIndex` | int | 0 = user, 1 = assistant, 2 = system |
| `content` | String | Message text |
| `statusIndex` | int | 0 = sending, 1 = sent, 2 = error, 3 = streaming |
| `createdAt` | DateTime | Timestamp |
| `tokenCount` | int? | Optional usage info |

### ConversationModel (Hive typeId: 1)

| Field | Type | Description |
|---|---|---|
| `id` | String | UUID v4 |
| `title` | String | Auto-generated from first message |
| `lastMessage` | String? | Preview text |
| `model` | String | Claude model used |
| `systemPrompt` | String? | Per-conversation override |
| `messageCount` | int | Total messages |

### PromptTemplateModel (Hive typeId: 2)

| Field | Type | Description |
|---|---|---|
| `id` | String | UUID v4 (or built-in ID) |
| `name` | String | Template display name |
| `prompt` | String | Prompt body |
| `emoji` | String? | Display emoji |
| `isBuiltIn` | bool | Built-in templates are read-only |

---

## Built-in Prompt Templates

| Template | Emoji | Purpose |
|---|---|---|
| Code Review | 🔍 | Review code for bugs and best practices |
| Explain Like I'm 5 | 🧒 | Simplify any concept |
| Debug Helper | 🐛 | Identify and fix bugs |
| Writing Assistant | ✍️ | Write or improve content |
| Brainstorm Ideas | 💡 | Generate creative suggestions |
| Summarize | 📋 | Condense text to key points |

---

## Running Tests

```bash
flutter test
flutter test --coverage
```

Tests in `test/unit/`:
- `validators_test.dart` — email, password, API key validation
- `message_entity_test.dart` — entity logic, copyWith, Equatable equality
- `conversation_entity_test.dart` — conversation entity tests

---

## Tech Stack

| Package | Purpose |
|---|---|
| `get` | State management, DI, routing |
| `hive_flutter` | Offline-first conversation and message storage |
| `flutter_secure_storage` | Keychain/keystore API key storage |
| `dio` | HTTP client for Anthropic API (streaming via ResponseType.stream) |
| `flutter_markdown` | Render AI responses as rich Markdown |
| `speech_to_text` | Voice input |
| `firebase_core` + `firebase_auth` | Optional auth and analytics |
| `dartz` | Functional `Either` error handling |
| `equatable` | Value equality on entities |
| `uuid` | UUID v4 generation |
| `logger` | Dev-mode pretty logging |
| `connectivity_plus` | Network status |

---

## Security

- API key is entered through a dedicated UI, stored in the device secure enclave, and injected into requests at runtime via `AuthInterceptor`
- No secrets are committed to version control
- All sensitive storage uses `flutter_secure_storage` with `encryptedSharedPreferences: true` on Android and `KeychainAccessibility.first_unlock` on iOS
- The app only communicates with `api.anthropic.com`

---

## License

MIT License. See [LICENSE](LICENSE).
