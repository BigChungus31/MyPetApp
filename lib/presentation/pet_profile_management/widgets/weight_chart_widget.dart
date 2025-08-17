import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class WeightChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weightHistory;
  final double targetWeight;

  const WeightChartWidget({
    Key? key,
    required this.weightHistory,
    required this.targetWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Tracking',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Target: ${targetWeight.toStringAsFixed(1)} kg',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: weightHistory.isNotEmpty
                ? LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.dividerColor,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < weightHistory.length) {
                                final date = DateTime.parse(
                                    weightHistory[value.toInt()]['date']);
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    '${date.day}/${date.month}',
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  '${value.toInt()}kg',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppTheme.lightTheme.dividerColor,
                          width: 1,
                        ),
                      ),
                      minX: 0,
                      maxX: (weightHistory.length - 1).toDouble(),
                      minY: _getMinWeight() - 1,
                      maxY: _getMaxWeight() + 1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getWeightSpots(),
                          isCurved: true,
                          color: AppTheme.lightTheme.primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.primaryColor,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                          ),
                        ),
                        // Target weight line
                        LineChartBarData(
                          spots: [
                            FlSpot(0, targetWeight),
                            FlSpot((weightHistory.length - 1).toDouble(),
                                targetWeight),
                          ],
                          isCurved: false,
                          color: AppTheme.successLight,
                          barWidth: 2,
                          dashArray: [5, 5],
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'timeline',
                          color:
                              AppTheme.lightTheme.textTheme.bodySmall?.color ??
                                  Colors.grey,
                          size: 8.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No weight data available',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWeightSpots() {
    return weightHistory.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value['weight'] as num).toDouble(),
      );
    }).toList();
  }

  double _getMinWeight() {
    if (weightHistory.isEmpty) return 0;
    return weightHistory
        .map((e) => (e['weight'] as num).toDouble())
        .reduce((a, b) => a < b ? a : b);
  }

  double _getMaxWeight() {
    if (weightHistory.isEmpty) return targetWeight;
    final maxHistoryWeight = weightHistory
        .map((e) => (e['weight'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    return maxHistoryWeight > targetWeight ? maxHistoryWeight : targetWeight;
  }
}
