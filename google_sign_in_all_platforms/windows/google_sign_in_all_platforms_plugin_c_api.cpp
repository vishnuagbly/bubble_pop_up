#include "include/google_sign_in_all_platforms/google_sign_in_all_platforms_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "google_sign_in_all_platforms_plugin.h"

void GoogleSignInAllPlatformsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  google_sign_in_all_platforms::GoogleSignInAllPlatformsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
