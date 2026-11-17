import '../data/datasources/local_storage.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/device_repository_impl.dart';

class Dependencies {
  Dependencies._();

  static final LocalStorage storage = LocalStorage();

  static final AuthRepositoryImpl authRepository = AuthRepositoryImpl(storage);

  static final DeviceRepositoryImpl deviceRepository = DeviceRepositoryImpl(
    storage,
    authRepository,
  );
}
