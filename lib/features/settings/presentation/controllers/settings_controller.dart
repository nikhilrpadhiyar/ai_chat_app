import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/validators.dart';

class SettingsController extends GetxController {
  final StorageService _storage;
  final SecureStorageService _secureStorage;

  SettingsController(this._storage, this._secureStorage);

  final isDarkMode = false.obs;
  final selectedModel = AppConstants.defaultModel.obs;
  final systemPrompt = ''.obs;
  final hasApiKey = false.obs;
  final isLoadingApiKey = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    isDarkMode.value = _storage.read<bool>(AppConstants.themeKey) ?? false;
    selectedModel.value =
        _storage.read<String>(AppConstants.selectedModelKey) ?? AppConstants.defaultModel;
    systemPrompt.value = _storage.read<String>(AppConstants.systemPromptKey) ?? '';
    hasApiKey.value = await _secureStorage.containsKey(AppConstants.apiKeyKey);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(AppConstants.themeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void changeModel(String model) {
    selectedModel.value = model;
    _storage.write(AppConstants.selectedModelKey, model);
  }

  void updateSystemPrompt(String prompt) {
    systemPrompt.value = prompt;
    _storage.write(AppConstants.systemPromptKey, prompt);
  }

  Future<void> saveApiKey(String key) async {
    final error = Validators.apiKey(key);
    if (error != null) {
      Get.snackbar('Invalid API Key', error, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoadingApiKey.value = true;
    await _secureStorage.write(AppConstants.apiKeyKey, key.trim());
    hasApiKey.value = true;
    isLoadingApiKey.value = false;
    Get.snackbar('Success', 'API key saved securely', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteApiKey() async {
    await _secureStorage.delete(AppConstants.apiKeyKey);
    hasApiKey.value = false;
    Get.snackbar('Removed', 'API key deleted', snackPosition: SnackPosition.BOTTOM);
  }
}
