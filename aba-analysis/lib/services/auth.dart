import 'package:aba_analysis/models/aba_user.dart';
import 'package:aba_analysis/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FireStoreService store = FireStoreService();

  // 2. 회원가입
  Future register(String email, String? password) async {
    try {
      // password == null 이라면 구글용 아이디인 것
      if (password != null) {
        // Firebase 제공 계정 만들기 -> Authentication에 등록
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('비밀번호의 보안이 너무 약합니다');
      } else if (e.code == 'email-already-in-use') {
        print('이미 존재하는 이메일입니다.');
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // 3. 로그인
  Future<String> signIn(String email, String password) async {
    try {
      // 이메일 & 패스워드 정보를 기반으로 Auth 계정 로그인
      await auth.signInWithEmailAndPassword(email: email, password: password);

      return '로그인 성공';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '존재하지 않는 이메일입니다.';
      } else if (e.code == 'wrong-password') {
        return '비밀번호가 틀립니다.';
      }
      return '비밀번호가 틀립니다.';
    }
  }

  Future<String> testsignIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
    return "아무일도 없었다.";
  }

  // 4. 로그아웃
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // 5. 비밀번호 변경 이메일 전송
  // Future resetPassword(String email) async {
  //   await FireStoreService().read
  //   await auth.sendPasswordResetEmail(email: email);
  // }

  // 6. 사용자 삭제
  Future deleteAuthUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  // User 객체를 ABAUser로 Convert -> 해당 User의 정보가 DB에 담겨있음을 가정
  Future<ABAUser?> convertUserToABAUser(User? user) async {
    // null check
    if (user == null) return null;

    // 유저 정보에 대한 uid를 통해 DB의 User 정보를 가져옴
    ABAUser? abaUser = await store.readUser(user.email!);

    return abaUser;
  }

  // Getter 함수 현재 유저 정보 반환
  User? get user => auth.currentUser;

  // Getter 함수 현재 유저의 ABAUser 객체 정보 반환
  Future<ABAUser?> get abaUser async {
    return await convertUserToABAUser(user);
  }

  Stream<User?> getChange() {
    return auth.authStateChanges();
  }
}
