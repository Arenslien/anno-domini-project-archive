import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

late TooltipBehavior _tooltipBehavior;
Widget genChart(
    List<GraphDataLocal> _chartData,
    GlobalKey<SfCartesianChartState> _cartesianKey,
    String _charTitleName,
    bool _isDate) {
  _tooltipBehavior = TooltipBehavior(enable: true);
  return SfCartesianChart(
    // enableAxisAnimation: true,
    key: _cartesianKey,
    title: ChartTitle(
        text: _charTitleName,
        textStyle: TextStyle(fontFamily: 'KoreanGothic')), // testdata의 회차
    legend: Legend(isVisible: true, position: LegendPosition.bottom),
    tooltipBehavior: _tooltipBehavior,
    series: _isDate
        ? <ChartSeries>[
            // 날짜별 그래프일 때
            ScatterSeries<GraphData, String>(
                name: "하루 평균 성공률",
                dataSource: _chartData,
                xValueMapper: (GraphData exp, _) => exp.subItem,
                yValueMapper: (GraphData exp, _) => exp.itemSuccessRate,
                markerSettings: MarkerSettings(
                  isVisible: true,
                  width: 12.0,
                  height: 12.0,
                  shape: DataMarkerType.rectangle,
                )),
          ]
        : <ChartSeries>[
            // 아이템 그래프일 때
            LineSeries<GraphData, String>(
              name: '하루 평균 성공률',
              dataSource: _chartData,
              xValueMapper: (GraphData exp, _) => exp.dateString,
              yValueMapper: (GraphData exp, _) => exp.daySuccessRate,
              markerSettings: MarkerSettings(isVisible: true),
            ),
            LineSeries<GraphData, String>(
              name: '전체 평균 성공률',
              dashArray: <double>[5, 5],
              dataSource: _chartData,
              xValueMapper: (GraphData exp, _) => exp.dateString,
              yValueMapper: (GraphData exp, _) => exp.allSuccessRate,
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
    primaryXAxis: CategoryAxis(
        rangePadding: ChartRangePadding.auto,
        labelIntersectAction: AxisLabelIntersectAction.rotate90,
        labelStyle: TextStyle(fontFamily: 'KoreanGothic')),
    primaryYAxis: NumericAxis(
      labelStyle: TextStyle(fontFamily: 'KoreanGothic'),
      labelFormat: '{value}%',
      maximum: 100,
      minimum: 0,
      visibleMaximum: 100,
      visibleMinimum: 0,
      interval: 10,
    ),
  );
}

class GraphDataLocal {
  final String testDate; // 선택한 하위목록을 테스트한 날짜 또는 테스트한 회차
  final String subItem; // Date Graph에서 하위목록 이름
  final String result; // Date Graph에서의 날짜 또는 회차에따른 +, -, P
  late num itemSuccessRate; // Date Graph에서 해당 하위목록의 평균성공률

  final String dateString; // Item Graph에서의 날짜 (x축)
  final num daySuccessRate; // Item Graph에서 그날의 평균 성공률(Y축1)
  final num allSuccessRate; // Item Graph에서의 전체 성공률(Y축2)
  GraphDataLocal({
    this.testDate = "",
    this.subItem = "",
    this.result = "",
    this.allSuccessRate = -1,
    this.daySuccessRate = -1,
    this.dateString = "",
    this.itemSuccessRate = -1,
  }) {}
  // {
  //   if (this.result == '+') {
  //     this.itemSuccessRate = 100;
  //   } else if (this.result == '-' || this.result == 'P') {
  //     this.itemSuccessRate = 0;
  //   }
  // }
}

class GraphData {
  final String testDate; // 선택한 하위목록을 테스트한 날짜 또는 테스트한 회차
  final String subItem; // Date Graph에서 하위목록 이름
  final String result; // Date Graph에서의 날짜 또는 회차에따른 +, -, P
  late num itemSuccessRate; // Date Graph에서 해당 하위목록의 평균성공률

  final String dateString; // Item Graph에서의 날짜 (x축)
  final num daySuccessRate; // Item Graph에서 그날의 평균 성공률(Y축1)
  final num allSuccessRate; // Item Graph에서의 전체 성공률(Y축2)
  // 통일된거
  GraphData({
    this.testDate = "",
    this.subItem = "",
    this.result = "",
    this.allSuccessRate = -1,
    this.daySuccessRate = -1,
    this.dateString = "",
    this.itemSuccessRate = -1,
  }) {}
  // {
  //   if (this.result == '+') {
  //     this.itemSuccessRate = 100;
  //   } else if (this.result == '-' || this.result == 'P') {
  //     this.itemSuccessRate = 0;
  //   }
  // }
}

class ItemGraphData {
  final String testDate; // 선택한 하위목록을 테스트한 날짜 또는 테스트한 회차
  final String subItem; // 하위목록 이름
  final num averageRate; // 평균 성공률

  // 통일된거
  ItemGraphData(this.testDate, this.subItem, this.averageRate);
}
