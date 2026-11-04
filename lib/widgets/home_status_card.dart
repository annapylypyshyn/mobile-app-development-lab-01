import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeStatusCard extends StatelessWidget {
  final int connectedDevices;

  const HomeStatusCard({super.key, required this.connectedDevices});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'All systems normal',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your home is looking good!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            '$connectedDevices devices connected',
            style: const TextStyle(color: AppTheme.secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
