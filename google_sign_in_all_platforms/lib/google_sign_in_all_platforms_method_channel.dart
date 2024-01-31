import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'google_sign_in_all_platforms_platform_interface.dart';

/// An implementation of [GoogleSignInAllPlatformsPlatform] that uses method channels.
class MethodChannelGoogleSignInAllPlatforms extends GoogleSignInAllPlatformsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
