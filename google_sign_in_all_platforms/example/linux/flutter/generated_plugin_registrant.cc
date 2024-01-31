//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <google_sign_in_all_platforms/google_sign_in_all_platforms_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) google_sign_in_all_platforms_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GoogleSignInAllPlatformsPlugin");
  google_sign_in_all_platforms_plugin_register_with_registrar(google_sign_in_all_platforms_registrar);
}
