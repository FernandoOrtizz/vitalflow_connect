import 'package:flutter/material.dart';

class HistoryCardWidget extends StatelessWidget {
  final String title;
  final String bpmValue;
  final String sleepValue;
  final String oxValue;
  final String stepsValue;
  final String restBpmValue;
  final String calories;

  const HistoryCardWidget({
    Key? key,
    required this.title,
    required this.bpmValue,
    required this.sleepValue,
    required this.oxValue,
    required this.stepsValue,
    required this.restBpmValue,
    required this.calories,
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
                _buildValueColumn(
                    Icons.favorite, bpmValue, '', Colors.pink.shade100),
                const SizedBox(
                  width: 16,
                ),
                _buildValueColumn(Icons.battery_charging_full_rounded,
                    calories ?? '', '', Colors.orange.shade300),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallValueColumn(Icons.bloodtype_outlined, oxValue, '%',
                    Colors.blue.shade300),
                _buildSmallValueColumn(Icons.directions_walk_rounded,
                    stepsValue, '', Colors.green.shade300),
                _buildSmallValueColumn(Icons.favorite_border_rounded,
                    restBpmValue ?? '', '', Colors.pink.shade100),
                _buildSmallValueColumn(Icons.brightness_3_outlined, sleepValue,
                    'H', Colors.blueGrey),
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
