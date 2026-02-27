import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Card displaying a single Fard prayer with a toggle to mark complete
class PrayerCard extends StatelessWidget {
  final String prayerName;
  final bool isCompleted;
  final VoidCallback onTap;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppTheme.primaryDarkGreen : Colors.grey.shade400,
          size: 28,
        ),
        title: Text(
          prayerName,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isCompleted ? AppTheme.primaryDarkGreen : AppTheme.textDark,
          ),
        ),
        trailing: isCompleted
            ? const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.primaryDarkGreen,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const Text(
                'Tap to mark',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
        onTap: onTap,
      ),
    );
  }
}
