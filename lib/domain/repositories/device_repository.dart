import '../models/smart_device.dart';

abstract class DeviceRepository {
  Future<List<SmartDevice>> getDevices();

  Future<void> addDevice(SmartDevice device);

  Future<void> updateDevice(SmartDevice device);

  Future<void> deleteDevice(String id);
}
