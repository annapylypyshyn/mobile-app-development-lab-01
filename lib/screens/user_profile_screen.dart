import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_menu_item.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.accentColor,
                    child: Icon(
                      Icons.person,
                      size: 56,
                      color: AppTheme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Alex Morgan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'alex.morgan@email.com',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Home Owner',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ProfileMenuItem(
                    icon: Icons.home_outlined,
                    title: 'Home Information',
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),

                  const SizedBox(height: 28),

                  CustomButton(
                    text: 'Log Out',
                    icon: Icons.logout,
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
