import 'package:flutter/material.dart';

import '../core/dependencies.dart';
import '../domain/models/smart_device.dart';
import '../theme/app_theme.dart';
import '../widgets/home_status_card.dart';
import '../widgets/sensor_card.dart';
import '../widgets/device_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<SmartDevice> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      final devices = await Dependencies.deviceRepository.getDevices();

      if (!mounted) return;

      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Could not load devices: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  IconData _getIcon(String iconKey) {
    switch (iconKey) {
      case 'thermostat':
        return Icons.device_thermostat;
      case 'security':
        return Icons.security;
      case 'power':
        return Icons.power;
      default:
        return Icons.lightbulb_outline;
    }
  }

  String _getStatus(SmartDevice device, bool isActive) {
    if (!isActive) return 'OFF';

    switch (device.iconKey) {
      case 'thermostat':
        return '22°C';
      case 'security':
        return 'Active';
      default:
        return 'ON';
    }
  }

  Future<void> _toggleDevice(SmartDevice device, bool isActive) async {
    final updatedDevice = device.copyWith(
      isActive: isActive,
      status: _getStatus(device, isActive),
    );

    try {
      await Dependencies.deviceRepository.updateDevice(updatedDevice);

      if (!mounted) return;

      setState(() {
        final index = _devices.indexWhere((item) => item.id == device.id);
        if (index != -1) {
          _devices[index] = updatedDevice;
        }
      });
    } catch (e) {
      _showMessage('Could not update device: $e');
    }
  }

  Future<void> _openDeviceDialog({SmartDevice? device}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: device?.name ?? '');
    final roomController = TextEditingController(text: device?.room ?? '');

    String selectedIcon = device?.iconKey ?? 'lightbulb';

    try {
      final result = await showDialog<SmartDevice>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(device == null ? 'Add Device' : 'Edit Device'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Device name',
                            prefixIcon: Icon(Icons.devices),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter device name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: roomController,
                          decoration: const InputDecoration(
                            labelText: 'Room',
                            prefixIcon: Icon(Icons.meeting_room_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter room name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: selectedIcon,
                          decoration: const InputDecoration(
                            labelText: 'Device type',
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'lightbulb',
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(
                              value: 'thermostat',
                              child: Text('Thermostat'),
                            ),
                            DropdownMenuItem(
                              value: 'security',
                              child: Text('Security sensor'),
                            ),
                            DropdownMenuItem(
                              value: 'power',
                              child: Text('Other device'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                selectedIcon = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      final newDevice = device == null
                          ? SmartDevice(
                              id: DateTime.now().microsecondsSinceEpoch
                                  .toString(),
                              name: nameController.text.trim(),
                              room: roomController.text.trim(),
                              status: 'OFF',
                              iconKey: selectedIcon,
                              isActive: false,
                            )
                          : device.copyWith(
                              name: nameController.text.trim(),
                              room: roomController.text.trim(),
                              iconKey: selectedIcon,
                            );

                      Navigator.pop(dialogContext, newDevice);
                    },
                    child: Text(device == null ? 'Add' : 'Save'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result == null || !mounted) return;

      if (device == null) {
        await Dependencies.deviceRepository.addDevice(result);
      } else {
        await Dependencies.deviceRepository.updateDevice(result);
      }

      if (!mounted) return;

      setState(() {
        if (device == null) {
          _devices.add(result);
        } else {
          final index = _devices.indexWhere((item) => item.id == result.id);
          if (index != -1) {
            _devices[index] = result;
          }
        }
      });

      _showMessage(
        device == null
            ? 'Device added successfully'
            : 'Device updated successfully',
      );
    } catch (e) {
      if (mounted) {
        _showMessage('Operation failed: $e');
      }
    } finally {
      nameController.dispose();
      roomController.dispose();
    }
  }

  Future<void> _deleteDevice(SmartDevice device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete device?'),
        content: Text('Do you want to delete "${device.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await Dependencies.deviceRepository.deleteDevice(device.id);

      if (!mounted) return;

      setState(() {
        _devices.removeWhere((item) => item.id == device.id);
      });

      _showMessage('Device deleted successfully');
    } catch (e) {
      _showMessage('Could not delete device: $e');
    }
  }

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

    final activeDevices = _devices.where((device) => device.isActive).length;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDeviceDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add device'),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
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
                      HomeStatusCard(connectedDevices: activeDevices),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Connected Devices',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${_devices.length} devices',
                            style: const TextStyle(
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_devices.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No devices yet. Add your first device!',
                            ),
                          ),
                        )
                      else
                        ..._devices.map(
                          (device) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: DeviceCard(
                              name: device.name,
                              room: device.room,
                              status: device.status,
                              icon: _getIcon(device.iconKey),
                              isActive: device.isActive,
                              onToggle: (value) {
                                _toggleDevice(device, value);
                              },
                              onEdit: () {
                                _openDeviceDialog(device: device);
                              },
                              onDelete: () {
                                _deleteDevice(device);
                              },
                            ),
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
