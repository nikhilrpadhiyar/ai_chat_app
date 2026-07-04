import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/network/api_client.dart';
import 'package:ai_chat_app/core/storage/secure_storage_service.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/core/theme/app_theme.dart';
import 'package:ai_chat_app/core/utils/connectivity_service.dart';
import 'package:ai_chat_app/features/chat/data/models/message_model.dart';
import 'package:ai_chat_app/features/conversation/data/models/conversation_model.dart';
import 'package:ai_chat_app/features/prompt_templates/data/models/prompt_template_model.dart';
import 'package:ai_chat_app/firebase_options.dart';
import 'package:ai_chat_app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(ConversationModelAdapter());
  Hive.registerAdapter(PromptTemplateModelAdapter());
  await Future.wait(<Future<Box<HiveObject>>>[
    Hive.openBox<MessageModel>(AppConstants.messagesBox),
    Hive.openBox<ConversationModel>(AppConstants.conversationsBox),
    Hive.openBox<PromptTemplateModel>(AppConstants.promptTemplatesBox),
  ]);

  // GetStorage
  await GetStorage.init();
  final StorageService storageService = StorageService();
  await storageService.init();

  // SecureStorage
  final SecureStorageService secureStorage = SecureStorageService();

  // API client
  ApiClient().init(secureStorage);

  // Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase optional; app works without it
  }

  // Register global singletons
  Get.put(storageService, permanent: true);
  Get.put(secureStorage, permanent: true);
  Get.put(ApiClient(), permanent: true);
  Get.put(ConnectivityService(), permanent: true);

  // Restore theme
  final bool isDark = storageService.read<bool>(AppConstants.themeKey) ?? false;

  // Determine initial route
  final bool onboardingDone =
      storageService.read<bool>('onboarding_done') ?? false;
  final bool hasApiKey = await secureStorage.containsKey(
    AppConstants.apiKeyKey,
  );

  runApp(
    AiChatApp(
      isDark: isDark,
      initialRoute: (onboardingDone && hasApiKey)
          ? AppRoutes.conversations
          : AppRoutes.onboarding,
    ),
  );
}

class AiChatApp extends StatelessWidget {
  const AiChatApp({
    super.key,
    required this.isDark,
    required this.initialRoute,
  });
  final bool isDark;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Chat App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
