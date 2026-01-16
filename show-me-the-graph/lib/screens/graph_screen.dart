import 'package:flutter/material.dart';
import 'package:show_me_the_graph/source/data_source.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatefulWidget {
  final GraphData data;

  GraphScreen({Key? key, required this.data}) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late List<ExpenseData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData(widget.data.getCheckList());
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.getTitle()),
      ),
      body: Center(
        child: SfCartesianChart(
          title: ChartTitle(text: widget.data.getTitle()),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries>[
            LineSeries<ExpenseData, num>(
                name: 'check',
                dataSource: _chartData,
                xValueMapper: (ExpenseData exp, _) => exp.count,
                yValueMapper: (ExpenseData exp, _) => exp.ischeck)
          ],
          primaryXAxis: CategoryAxis(),
        ),
      ),
    );
  }

  List<ExpenseData> getChartData(List<bool> checkList) {
    List<ExpenseData> chartData = [];
    for(int i=0; i<10; i++) {
      if (checkList[i]) chartData.add(ExpenseData(i+1, 1));
      else chartData.add(ExpenseData(i+1, 0));
    }
    return chartData;
  }
}

class ExpenseData {
  ExpenseData(this.count, this.ischeck);
  final num count;
  final num ischeck;
}
