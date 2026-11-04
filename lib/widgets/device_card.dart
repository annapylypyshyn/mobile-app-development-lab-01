import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DeviceCard extends StatelessWidget {
  final String name;
  final String room;
  final String status;
  final IconData icon;
  final bool isActive;

  const DeviceCard({
    super.key,
    required this.name,
    required this.room,
    required this.status,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room,
                    style: const TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: isActive
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
