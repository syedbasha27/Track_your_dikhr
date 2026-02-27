import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Yes/No toggle card for a character deed
class CharacterToggle extends StatelessWidget {
  final String label;
  final String rewardText;
  final bool isDone;
  final VoidCallback onTap;

  const CharacterToggle({
    super.key,
    required this.label,
    required this.rewardText,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Status icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppTheme.primaryDarkGreen
                      : Colors.grey.shade200,
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.circle_outlined,
                  color: isDone ? Colors.white : Colors.grey.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDone
                            ? AppTheme.primaryDarkGreen
                            : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      rewardText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
