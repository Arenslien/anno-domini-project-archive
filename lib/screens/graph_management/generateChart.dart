import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

late TooltipBehavior _tooltipBehavior;
Widget genChart(
    List<GraphData> _chartData,
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
    series: <ChartSeries>[
      LineSeries<GraphData, String>(
        name: '성공률',
        dataSource: _chartData,
        xValueMapper: (GraphData exp, _) {
          if (_isDate) {
            return exp.subItem;
          } else {
            return exp.testDate;
          }
        },
        yValueMapper: (GraphData exp, _) => exp.successRate,
        markerSettings: MarkerSettings(isVisible: true),
      ),
      LineSeries<GraphData, String>(
          name: '평균 성공률',
          dashArray: <double>[5, 5],
          dataSource: _chartData,
          xValueMapper: (GraphData exp, _) {
            if (_isDate) {
              return exp.subItem;
            } else {
              return exp.testDate;
            }
          },
          yValueMapper: (GraphData exp, _) => exp.averageRate)
    ],
    primaryXAxis: CategoryAxis(
        rangePadding: ChartRangePadding.auto,
        labelIntersectAction: AxisLabelIntersectAction.rotate90,
        labelStyle: TextStyle(fontFamily: 'KoreanGothic')),
    primaryYAxis: NumericAxis(
      labelStyle: TextStyle(fontFamily: 'KoreanGothic'),
      labelFormat: '{value}%',
      visibleMaximum: 100,
      visibleMinimum: 0,
      interval: 10,
    ),
  );
}

class GraphData {
  final String testDate; // 선택한 하위목록을 테스트한 날짜 또는 테스트한 회차
  final String subItem; // 하위목록 이름
  final String result; // 날짜 또는 회차에따른 +, -, P
  late num successRate; // +, -, P에 따른 성공률
  final num averageRate; // 평균 성공률

  // 통일된거
  GraphData(this.testDate, this.subItem, this.result, this.averageRate) {
    if (this.result == '+') {
      this.successRate = 100;
    } else if (this.result == '-' || this.result == 'P') {
      this.successRate = 0;
    }
  }
}
