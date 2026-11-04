import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/home_status_card.dart';
import '../widgets/sensor_card.dart';
import '../widgets/device_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sensors = [
      const SensorCard(
        title: 'Temperature',
        value: '22',
        unit: '°C',
        icon: Icons.thermostat,
      ),
      const SensorCard(
        title: 'Humidity',
        value: '45',
        unit: '%',
        icon: Icons.water_drop_outlined,
      ),
      const SensorCard(
        title: 'Air Quality',
        value: 'Good',
        unit: '',
        icon: Icons.air,
      ),
    ];

    final devices = [
      const DeviceCard(
        name: 'Living Room Light',
        room: 'Living Room',
        status: 'ON',
        icon: Icons.lightbulb_outline,
        isActive: true,
      ),
      const DeviceCard(
        name: 'Bedroom Light',
        room: 'Bedroom',
        status: 'OFF',
        icon: Icons.lightbulb_outline,
        isActive: false,
      ),
      const DeviceCard(
        name: 'Smart Thermostat',
        room: 'Living Room',
        status: '22°C',
        icon: Icons.device_thermostat,
        isActive: true,
      ),
      const DeviceCard(
        name: 'Security Sensor',
        room: 'Entrance',
        status: 'Active',
        icon: Icons.security,
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HomeFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final columns = isTablet ? 3 : 2;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Here is your home overview.',
                        style: TextStyle(color: AppTheme.secondaryTextColor),
                      ),
                      const SizedBox(height: 24),

                      const HomeStatusCard(connectedDevices: 4),

                      const SizedBox(height: 28),

                      Text(
                        'Environment',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isTablet ? 1.3 : 1.0,
                        children: sensors,
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'Connected Devices',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      ...devices.map(
                        (device) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: device,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
