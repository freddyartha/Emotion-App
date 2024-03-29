import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../others/empty_component.dart';

class PieChartItem {
  Color color;
  String text;
  double value;

  PieChartItem({
    required this.color,
    required this.text,
    required this.value,
  });
}

class PieChartComponent extends StatefulWidget {
  final List<PieChartItem> data;
  final String? title;
  final double marginBottom;

  const PieChartComponent({
    super.key,
    required this.data,
    this.title,
    this.marginBottom = 10,
  });

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  @override
  Widget build(BuildContext context) {
    var total = widget.data.isEmpty
        ? 0
        : widget.data.map((e) => e.value).reduce((a, b) => a + b);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        margin: EdgeInsets.only(bottom: widget.marginBottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: widget.title != null,
              child: Text(widget.title ?? ""),
            ),
            Visibility(
              visible: widget.data.isEmpty,
              child: const Expanded(child: EmptyComponent()),
            ),
            Visibility(
              visible: widget.data.isNotEmpty,
              child: Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          sections: widget.data.map((e) {
                            var value = (e.value / total * 100).round();
                            return PieChartSectionData(
                                color: e.color,
                                value: value.toDouble(),
                                title: '${e.text}\n$value%',
                                titleStyle: MahasThemes.whiteNormal
                                    .copyWith(fontSize: 10));
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
