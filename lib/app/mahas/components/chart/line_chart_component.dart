import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../mahas_colors.dart';
import '../mahas_themes.dart';
import '../others/empty_component.dart';

class LineChartItem {
  double x;
  double value;

  LineChartItem({
    required this.x,
    required this.value,
  });
}

class LineChartComponent extends StatefulWidget {
  final List<LineChartItem> data;
  final String? title;
  final double marginBottom;
  final double? minY;

  const LineChartComponent({
    super.key,
    required this.data,
    this.title,
    this.marginBottom = 10,
    this.minY = 0,
  });

  @override
  State<LineChartComponent> createState() => _LineChartComponentState();
}

class _LineChartComponentState extends State<LineChartComponent> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        margin: EdgeInsets.only(bottom: widget.marginBottom),
        child: Card(
          color: MahasColors.light,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: widget.title != null,
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(widget.title ?? "")),
                ),
                Visibility(
                  visible: widget.data.isEmpty,
                  child: const Expanded(child: EmptyComponent()),
                ),
                Visibility(
                  visible: widget.data.isNotEmpty,
                  child: Expanded(
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: false,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 42,
                              getTitlesWidget: (value, meta) => Text(
                                meta.formattedValue,
                                style: MahasThemes.mutedNormal,
                              ),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: MahasColors.dark.withOpacity(.2)),
                        ),
                        minY: widget.minY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: widget.data
                                .map(
                                  (e) => FlSpot(e.x, e.value),
                                )
                                .toList(),
                            barWidth: 1,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: MahasColors.primary.withOpacity(.2),
                            ),
                          ),
                        ],
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 150),
                      swapAnimationCurve: Curves.linear,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
