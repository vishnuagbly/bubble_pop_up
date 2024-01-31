#ifndef FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_PLUGIN_H_
#define FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _GoogleSignInAllPlatformsPlugin GoogleSignInAllPlatformsPlugin;
typedef struct {
  GObjectClass parent_class;
} GoogleSignInAllPlatformsPluginClass;

FLUTTER_PLUGIN_EXPORT GType google_sign_in_all_platforms_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void google_sign_in_all_platforms_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_GOOGLE_SIGN_IN_ALL_PLATFORMS_PLUGIN_H_
