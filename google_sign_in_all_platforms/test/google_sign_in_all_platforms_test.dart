import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms_platform_interface.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGoogleSignInAllPlatformsPlatform
    with MockPlatformInterfaceMixin
    implements GoogleSignInAllPlatformsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GoogleSignInAllPlatformsPlatform initialPlatform = GoogleSignInAllPlatformsPlatform.instance;

  test('$MethodChannelGoogleSignInAllPlatforms is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGoogleSignInAllPlatforms>());
  });

  test('getPlatformVersion', () async {
    GoogleSignInAllPlatforms googleSignInAllPlatformsPlugin = GoogleSignInAllPlatforms();
    MockGoogleSignInAllPlatformsPlatform fakePlatform = MockGoogleSignInAllPlatformsPlatform();
    GoogleSignInAllPlatformsPlatform.instance = fakePlatform;

    expect(await googleSignInAllPlatformsPlugin.getPlatformVersion(), '42');
  });
}
