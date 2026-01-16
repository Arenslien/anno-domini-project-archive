import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class Kakao {
  bool isLoggedIn = false;

  Future login() async {
    isLoggedIn = await loginLogic();
  }

  Future logout() async {
    await logoutLogic();
    isLoggedIn = false;
  }

  Future<bool> loginLogic() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> logoutLogic() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (e) {
      return false;
    }
  }
}
