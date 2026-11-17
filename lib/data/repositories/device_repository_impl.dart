import '../../domain/models/smart_device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final LocalStorage _storage;
  final AuthRepository _authRepository;

  static const String _legacyDevicesKey = 'smart_devices';

  DeviceRepositoryImpl(this._storage, this._authRepository);

  Future<String> _getDevicesKey() async {
    final user = await _authRepository.getCurrentUser();

    if (user == null) {
      throw StateError('User is not authenticated.');
    }

    final userKey = 'smart_devices_${user.id}';

    // Migrate the old shared device list to the first user's account.
    final existingUserData = await _storage.readJson(userKey);
    final legacyData = await _storage.readJson(_legacyDevicesKey);

    if (existingUserData == null && legacyData != null) {
      await _storage.saveJson(userKey, legacyData);
      await _storage.remove(_legacyDevicesKey);
    }

    return userKey;
  }

  Future<List<SmartDevice>> _readDevices(String key) async {
    final data = await _storage.readJson(key);

    if (data == null) {
      final defaultDevices = _getDefaultDevices();
      await _saveDevices(key, defaultDevices);
      return defaultDevices;
    }

    return (data as List)
        .map(
          (item) =>
              SmartDevice.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<List<SmartDevice>> getDevices() async {
    final key = await _getDevicesKey();
    return _readDevices(key);
  }

  @override
  Future<void> addDevice(SmartDevice device) async {
    final key = await _getDevicesKey();
    final devices = await _readDevices(key);

    if (devices.any((item) => item.id == device.id)) {
      throw Exception('Device with this ID already exists.');
    }

    devices.add(device);
    await _saveDevices(key, devices);
  }

  @override
  Future<void> updateDevice(SmartDevice device) async {
    final key = await _getDevicesKey();
    final devices = await _readDevices(key);

    final index = devices.indexWhere((item) => item.id == device.id);

    if (index == -1) {
      throw Exception('Device not found.');
    }

    devices[index] = device;
    await _saveDevices(key, devices);
  }

  @override
  Future<void> deleteDevice(String id) async {
    final key = await _getDevicesKey();
    final devices = await _readDevices(key);

    devices.removeWhere((device) => device.id == id);

    await _saveDevices(key, devices);
  }

  Future<void> _saveDevices(String key, List<SmartDevice> devices) async {
    await _storage.saveJson(
      key,
      devices.map((device) => device.toJson()).toList(),
    );
  }

  List<SmartDevice> _getDefaultDevices() {
    return [
      const SmartDevice(
        id: '1',
        name: 'Living Room Light',
        room: 'Living Room',
        status: 'ON',
        iconKey: 'lightbulb',
        isActive: true,
      ),
      const SmartDevice(
        id: '2',
        name: 'Bedroom Light',
        room: 'Bedroom',
        status: 'OFF',
        iconKey: 'lightbulb',
        isActive: false,
      ),
      const SmartDevice(
        id: '3',
        name: 'Smart Thermostat',
        room: 'Living Room',
        status: '22°C',
        iconKey: 'thermostat',
        isActive: true,
      ),
      const SmartDevice(
        id: '4',
        name: 'Security Sensor',
        room: 'Entrance',
        status: 'Active',
        iconKey: 'security',
        isActive: true,
      ),
    ];
  }
}
