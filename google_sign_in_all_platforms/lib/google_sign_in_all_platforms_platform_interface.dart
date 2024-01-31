import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'google_sign_in_all_platforms_method_channel.dart';

abstract class GoogleSignInAllPlatformsPlatform extends PlatformInterface {
  /// Constructs a GoogleSignInAllPlatformsPlatform.
  GoogleSignInAllPlatformsPlatform() : super(token: _token);

  static final Object _token = Object();

  static GoogleSignInAllPlatformsPlatform _instance = MethodChannelGoogleSignInAllPlatforms();

  /// The default instance of [GoogleSignInAllPlatformsPlatform] to use.
  ///
  /// Defaults to [MethodChannelGoogleSignInAllPlatforms].
  static GoogleSignInAllPlatformsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GoogleSignInAllPlatformsPlatform] when
  /// they register themselves.
  static set instance(GoogleSignInAllPlatformsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
