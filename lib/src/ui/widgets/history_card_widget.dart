import 'package:flutter/material.dart';

class HistoryCardWidget extends StatelessWidget {
  final String title;
  final String bpmValue;
  final String sleepValue;
  final String oxValue;
  final String stepsValue;
  final String stressValue;
  final String pressureValue;

  const HistoryCardWidget({
    Key? key,
    required this.title,
    required this.bpmValue,
    required this.sleepValue,
    required this.oxValue,
    required this.stepsValue,
    required this.stressValue,
    required this.pressureValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildValueColumn(Icons.monitor_heart_outlined, bpmValue, '',
                    Colors.green.shade700),
                const SizedBox(
                  width: 16,
                ),
                _buildValueColumn(Icons.brightness_3_outlined, sleepValue, 'H',
                    Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallValueColumn(Icons.bloodtype_outlined, oxValue, '%',
                    Colors.blue.shade300),
                _buildSmallValueColumn(Icons.directions_walk, stepsValue, '',
                    Colors.green.shade300),
                _buildSmallValueColumn(Icons.face_retouching_natural_sharp,
                    stressValue, '%', Colors.orange.shade300),
                _buildSmallValueColumn(Icons.favorite_border, pressureValue, '',
                    Colors.pink.shade100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(
      IconData iconData, String value, String unit, Color iconColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              iconData,
              size: 48,
              color: iconColor,
            ),
            const SizedBox(
              height: 8,
              width: 8,
            ),
            Text(
              value + unit,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSmallValueColumn(
      IconData iconData, String value, String unit, Color iconColor) {
    return Column(
      children: [
        Icon(iconData, size: 24, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value + unit,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
