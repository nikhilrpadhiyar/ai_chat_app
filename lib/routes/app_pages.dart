import 'package:ai_chat_app/features/chat/presentation/controllers/chat_binding.dart';
import 'package:ai_chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:ai_chat_app/features/conversation/presentation/controllers/conversation_binding.dart';
import 'package:ai_chat_app/features/conversation/presentation/pages/conversations_page.dart';
import 'package:ai_chat_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ai_chat_app/features/prompt_templates/presentation/controllers/prompt_template_binding.dart';
import 'package:ai_chat_app/features/prompt_templates/presentation/pages/prompt_templates_page.dart';
import 'package:ai_chat_app/features/settings/presentation/controllers/settings_binding.dart';
import 'package:ai_chat_app/features/settings/presentation/pages/settings_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const String initial = AppRoutes.conversations;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.conversations,
      page: () => const ConversationsPage(),
      binding: ConversationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.promptTemplates,
      page: () => const PromptTemplatesPage(),
      binding: PromptTemplateBinding(),
      transition: Transition.downToUp,
    ),
    GetPage<dynamic>(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
