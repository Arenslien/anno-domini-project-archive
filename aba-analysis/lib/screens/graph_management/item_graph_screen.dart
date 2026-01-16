import 'dart:collection';

import 'package:aba_analysis/constants.dart';
import 'package:aba_analysis/models/child.dart';
import 'package:aba_analysis/models/test_item.dart';
import 'package:aba_analysis/provider/user_notifier.dart';
import 'package:aba_analysis/screens/graph_management/generateChart.dart';
import 'package:aba_analysis/screens/graph_management/generateExcel.dart';
import 'package:aba_analysis/screens/graph_management/generatePDF.dart';
import 'package:aba_analysis/components/select_appbar.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui' as dart_ui;
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xio;
import 'generateChart.dart';

class ItemGraphScreen extends StatefulWidget {
  final List<SubItemAndDate> subItemList;
  final Child child;
  const ItemGraphScreen(
      {Key? key, required this.subItemList, required this.child})
      : super(key: key);

  @override
  _ItemGraphScreenState createState() => _ItemGraphScreenState();
}

class _ItemGraphScreenState extends State<ItemGraphScreen> {
  final bool _isDate = false; // 날짜 그래프인지 아닌지

  late ExportData exportData; // Export할 데이터

  late List<GraphData> _chartData; // chart를 그릴 때 쓰이는 데이터
  late List<String> _tableColumn; // 내보내기할 때 테이블의 컬럼 이름들
  late String _graphType; // 날짜별 그래프인지 하위목록별 그래프인지
  late String _charTitleName; // 차트의 제목
  late num _allSuccessRate; // 평균 성공률
  final GlobalKey<SfCartesianChartState> _cartesianKey = GlobalKey();
  String _fileName = ""; // 저장할 파일의 이름
  String valueText = ""; // Dialog에서 사용
  bool _isCancle = true; // Dialog에서 취소버튼을 눌렀는지 아닌지(확인버튼인지)

  // Dialog에서 사용
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _graphType = '하위목록';
    _charTitleName = widget.subItemList[0].testItem.subItem;
    _tableColumn = ['하위목록', '날짜', '하루 평균 성공률'];

    _chartData = getItemGraphData(_charTitleName, widget.subItemList);

    _allSuccessRate = _chartData[0].allSuccessRate;
  }

  Widget noTestData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_graph,
            color: Colors.grey,
            size: 150,
          ),
          Text(
            'No Test Data',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                fontFamily: 'korean'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _graphType = '하위목록';
    // _charTitleName = widget.subItemList[0].testItem.subItem;
    // _tableColumn = ['하위목록', '날짜', '성공여부'];
    // _chartData = getItemGraphData(_charTitleName, widget.subItemList);

    exportData = ExportData(
        context.watch<UserNotifier>().abaUser!.nickname, widget.child.name,
        allSuccessRate: _allSuccessRate,
        programField: widget.subItemList[0].testItem.programField,
        subArea: widget.subItemList[0].testItem.subField);

    return Scaffold(
      appBar: selectAppBar(
        context,
        widget.child.name + "의 " + _graphType + "별 그래프",
      ),
      body: widget.subItemList.isEmpty
          ? noTestData()
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: 460,
                        width: 400,
                        child: genChart(_chartData, _cartesianKey,
                            _charTitleName, _isDate)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton.extended(
                          heroTag: 'export_excel', // 버튼 구별을 위한 태그
                          onPressed: () async {
                            if (await Permission.storage.isGranted) {
                              exportExcel(
                                  _tableColumn, genTableData(_chartData));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "내보내기를 위해 직접 파일 접근 권한을 허락해주세요.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              openAppSettings();
                            }
                          }, // 누르면 엑셀 내보내기
                          label: Text('엑셀 내보내기',
                              style: TextStyle(fontFamily: 'KoreanGothic')),
                          icon: Icon(LineIcons.excelFile),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FloatingActionButton.extended(
                          heroTag: 'export_pdf', // 버튼 구별을 위한 태그
                          onPressed: () async {
                            if (await Permission.storage.isGranted) {
                              exportPDF(_tableColumn, genTableData(_chartData));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "내보내기를 위해 직접 파일 접근 권한을 허락해주세요.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              openAppSettings();
                            }
                          }, // 누르면 PDF 내보내기
                          label: Text(
                            'PDF 내보내기',
                            style: TextStyle(fontFamily: 'KoreanGothic'),
                          ),
                          icon: Icon(LineIcons.pdfFile),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> exportExcel(
      List<String> excelTableColumns, List<List<String>> excelTableData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    // final excelImg = bytes!.buffer.asUint8List();
    final graphImage = bytes!.buffer.asUint8List();
    final xio.Workbook graphWorkbook = genExcel(excelTableColumns,
        excelTableData, graphImage, _graphType, _isDate, exportData);
    final List<int> excelBytes = graphWorkbook.saveAsStream();
    final dir = await DownloadsPathProvider.downloadsDirectory;
    String filePath = dir!.path + '/abaGraph/';
    if (!(await Directory(filePath).exists())) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
    }
    await _displayTextInputDialog(context, filePath, 'xlsx');
    if (!_isCancle) {
      // 확인을 눌렀을 때
      final File file = File(filePath + _fileName + ".xlsx");
      file.writeAsBytesSync(excelBytes);
      await OpenFile.open(file.path);
      graphWorkbook.dispose();
    }
  }

  List<List<String>> genTableData(List<GraphData> chartData) {
    List<List<String>> tableData = [];

    // 아이템그래프라면 하위목록, 날짜, 하루 평균 성공률 순으로
    for (GraphData d in chartData) {
      tableData.add(
          <String>[d.subItem, d.dateString, d.daySuccessRate.toString() + "%"]);
    }

    print(tableData);
    return tableData;
  }

  Future<void> exportPDF(
      List<String> pdfTableColumns, List<List<String>> pdfTableData) async {
    dart_ui.Image imgData =
        await _cartesianKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await imgData.toByteData(format: dart_ui.ImageByteFormat.png);
    final graphImage = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );
    final ttf = await rootBundle.load('asset/font/korean.ttf');

    pw.Document graphPDF = genPDF(pdfTableColumns, pdfTableData, graphImage,
        ttf, _graphType, _charTitleName, _isDate, exportData);

    final dir = await DownloadsPathProvider.downloadsDirectory;
    String filePath = dir!.path + '/abaGraph/';
    if (!(await Directory(filePath).exists())) {
      // 폴더가 없다
      new Directory(filePath).createSync(recursive: true);
    }
    await _displayTextInputDialog(context, filePath, "pdf");
    if (!_isCancle) {
      // 확인을 눌렀을 때
      final File file = File(filePath + _fileName + ".pdf");
      file.writeAsBytesSync(List.from(await graphPDF.save()));
      await OpenFile.open(file.path);
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String filePath, String exportType) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '저장할 파일이름 입력',
              style: TextStyle(fontFamily: 'KoreanGothic'),
            ),
            content: TextField(
              onChanged: (text) {
                setState(() {
                  valueText = text;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: "파일이름 입력",
                hintStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontFamily: 'KoreanGothic'),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "취소",
                  style: TextStyle(fontFamily: 'KoreanGothic'),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    _isCancle = true;
                    _textFieldController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "확인",
                  style: TextStyle(fontFamily: 'KoreanGothic'),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  if (valueText == '') {
                    Fluttertoast.showToast(
                        msg: "파일 이름을 입력해주세요.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (File(filePath + valueText + "." + exportType)
                          .existsSync() ==
                      true) {
                    Fluttertoast.showToast(
                        msg: "같은 이름의 파일이 이미 존재합니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      Fluttertoast.showToast(
                          msg: "파일이 저장되었습니다.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      _fileName = valueText;
                      _isCancle = false;
                      _textFieldController.clear();
                    });
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        });
  }

  // GraphData를 가져온다.
  // SubItemAndDate를 통해 가져온다.
  List<GraphData> getItemGraphData(
      String _noChange, List<SubItemAndDate> subItemList) {
    // 날짜, 하위목록 이름, 평균 성공률
    List<GraphData> itemChartData = [];

    // 날짜 리스트
    List<String> dateStringList = [];
    // 날짜에 따른 총 성공률 맵.
    Map<String, int> successRateMap = Map();
    // 날짜에 따른 테스트횟수 맵
    Map<String, int> testCountMap = Map();
    // 위의 두 맵을 사용하여 선택된 테스트 아이템의 각 날짜의 평균 성공률을 계산한다.

    for (SubItemAndDate subItemAndDate in subItemList) {
      // 날짜 리스트를 추가해준다.
      if (!dateStringList.contains(subItemAndDate.dateString)) {
        dateStringList.add(subItemAndDate.dateString);
      }
    }
    // 날짜 리스트를 정렬해준다.
    dateStringList.sort((a, b) => a.compareTo(b));
    // 전체 성공률 합
    num allSuccessRate = 0;
    // 전체 테스트횟수 합
    num allTestCount = 0;
    // 두개를 통해 전체 평균 성공률을 구한다.
    for (SubItemAndDate subItemAndDate in subItemList) {
      // 성공률
      int nowResult = subItemAndDate.testItem.plus * 100;
      int nowCount = subItemAndDate.testItem.plus +
          subItemAndDate.testItem.minus +
          subItemAndDate.testItem.p;
      // 현재 날짜(Datetime => String)
      String dateString = subItemAndDate.dateString;
      // 맵에 이미 추가되어있다면 기존 값 업데이트
      if (successRateMap.containsKey(dateString)) {
        // 총 성공률은 이전까지의 성공률 + 현재성공률
        successRateMap.update(dateString, (value) => value + nowResult);
        // 개수는 1개 추가
        testCountMap.update(dateString, (value) => value += nowCount);
        allSuccessRate += nowResult;
        allTestCount += nowCount;
      } else {
        // 성공률 맵에 키가 없다면 새로 추가
        // 총 성공률은 현재 성공률
        successRateMap.addAll({dateString: nowResult});
        // 개수는 1로 시작
        testCountMap.addAll({dateString: nowCount});
        allSuccessRate += nowResult;
        allTestCount += nowCount;
      }
    }
    // 전체 평균 성공률
    num allSuccess = allSuccessRate / allTestCount;

    for (String date in dateStringList) {
      if (successRateMap[date] == null || testCountMap[date] == null) {
        print("해당 날짜에 선택된 테스트 아이템이 없습니다.");
      } else {
        // 날짜에 따른 총 성공률 맵과 테스트 횟수 맵을 갖고 그날의 선택된 해당 테스트 아이템의 평균 성공률을 게산한다.
        int daySuccessRate =
            (successRateMap[date]! / testCountMap[date]!).toInt();
        itemChartData.add(GraphData(
          subItem: _noChange,
          dateString: date,
          allSuccessRate: allSuccess,
          daySuccessRate: daySuccessRate,
        ));
      }
    }
    return itemChartData;
  }
}

class SubItemAndDate {
  final TestItem testItem;
  DateTime date;
  final String dateString;
  SubItemAndDate(
      {required this.testItem, required this.date, required this.dateString});
}
