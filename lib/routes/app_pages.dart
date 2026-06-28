import 'package:get/get.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/conversation/presentation/controllers/conversation_binding.dart';
import '../features/conversation/presentation/pages/conversations_page.dart';
import '../features/prompt_templates/presentation/controllers/prompt_template_binding.dart';
import '../features/prompt_templates/presentation/pages/prompt_templates_page.dart';
import '../features/settings/presentation/controllers/settings_binding.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/chat/presentation/controllers/chat_binding.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.conversations;

  static final routes = [
    GetPage(
      name: AppRoutes.conversations,
      page: () => const ConversationsPage(),
      binding: ConversationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.promptTemplates,
      page: () => const PromptTemplatesPage(),
      binding: PromptTemplateBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
