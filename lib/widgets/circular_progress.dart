import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Circular progress indicator showing completed out of total (e.g. 3/5 prayers)
class CircularProgressWidget extends StatelessWidget {
  final int completed;
  final int total;
  final String label;
  final double size;

  const CircularProgressWidget({
    super.key,
    required this.completed,
    required this.total,
    required this.label,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade200,
                color: AppTheme.primaryDarkGreen,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$completed/$total',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDarkGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}
