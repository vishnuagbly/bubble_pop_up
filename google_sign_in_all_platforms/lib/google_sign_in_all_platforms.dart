
import 'google_sign_in_all_platforms_platform_interface.dart';

class GoogleSignInAllPlatforms {
  Future<String?> getPlatformVersion() {
    return GoogleSignInAllPlatformsPlatform.instance.getPlatformVersion();
  }
}
