import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/connectivity_service.dart';
import 'features/chat/data/models/message_model.dart';
import 'features/conversation/data/models/conversation_model.dart';
import 'features/prompt_templates/data/models/prompt_template_model.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(ConversationModelAdapter());
  Hive.registerAdapter(PromptTemplateModelAdapter());
  await Future.wait([
    Hive.openBox<MessageModel>(AppConstants.messagesBox),
    Hive.openBox<ConversationModel>(AppConstants.conversationsBox),
    Hive.openBox<PromptTemplateModel>(AppConstants.promptTemplatesBox),
  ]);

  // GetStorage
  await GetStorage.init();
  final storageService = StorageService();
  await storageService.init();

  // SecureStorage
  final secureStorage = SecureStorageService();

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
  final isDark = storageService.read<bool>(AppConstants.themeKey) ?? false;

  // Determine initial route
  final onboardingDone = storageService.read<bool>('onboarding_done') ?? false;
  final hasApiKey = await secureStorage.containsKey(AppConstants.apiKeyKey);

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
  final bool isDark;
  final String initialRoute;

  const AiChatApp({super.key, required this.isDark, required this.initialRoute});

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
