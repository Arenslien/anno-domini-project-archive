import 'package:aba_analysis_local/screens/field_management/program_field_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aba_analysis_local/screens/graph_management/graph_main_screen.dart';
import 'package:aba_analysis_local/screens/child_management/child_main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  bool firebaseInitialized = false;
  late PageController pageController;
  bool storagePermissonGranted = false;
  @override
  void initState() {
    super.initState();
    //Firebase.initializeApp().then((_) {

    setState(() {
      firebaseInitialized = true;
    });
    //});

    pageController = PageController();

    // 처음에 권한을 확인하기 위해 initState에서 실행
    // initState에서는 Future클래스가 호출이 안되므로 권한 확인 함수를 아래 함수에 넣어줬다.
    setPermission();
  }

  void setPermission() async {
    // storage 접근 권한 확인
    var status = await Permission.storage.status;

    // 권한이 없을경우(status가 granted가 아닐 경우) request한다.
    if (!status.isGranted) {
      status = await Permission.storage.request();
      // 권한이 permantlyDenied일 경우, 앱 세팅에 들어가서 사용자가 직접 permission을 허락해줘야 한다.
      if (status.isPermanentlyDenied) {
        // 사용자에게 알리기 위해 토스트 메세지 출력
        Fluttertoast.showToast(msg: "직접 파일 접근 권한을 허락해주세요.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.white,
            child: GraphScreen(),
          ),
          Container(
            color: Colors.white,
            child: ChildMainScreen(),
          ),
          Container(
            color: Colors.white,
            child: ProgramFieldScreen(),
          ),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_graph_outlined,
              color: (_page == 0) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face_outlined,
              color: (_page == 1) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books_outlined,
              color: (_page == 2) ? Colors.black : Colors.grey,
            ),
            backgroundColor: Colors.white,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
