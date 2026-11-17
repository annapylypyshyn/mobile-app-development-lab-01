import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorage _storage;

  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  AuthRepositoryImpl(this._storage);

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<List<AppUser>> _getUsers() async {
    final data = await _storage.readJson(_usersKey);

    if (data == null) return [];

    return (data as List)
        .map((item) => AppUser.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> _saveUsers(List<AppUser> users) async {
    await _storage.saveJson(
      _usersKey,
      users.map((user) => user.toJson()).toList(),
    );
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final normalizedEmail = email.trim().toLowerCase();

    if (users.any((user) => user.email == normalizedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    final user = AppUser(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: normalizedEmail,
      passwordHash: _hashPassword(password),
    );

    users.add(user);

    await _saveUsers(users);
    await _storage.saveJson(_currentUserKey, user.toJson());

    return user;
  }

  @override
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final normalizedEmail = email.trim().toLowerCase();
    final passwordHash = _hashPassword(password);

    final matchingUsers = users.where(
      (user) =>
          user.email == normalizedEmail && user.passwordHash == passwordHash,
    );

    if (matchingUsers.isEmpty) {
      return null;
    }

    final user = matchingUsers.first;

    await _storage.saveJson(_currentUserKey, user.toJson());

    return user;
  }

  @override
  Future<void> signOut() async {
    await _storage.remove(_currentUserKey);
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final data = await _storage.readJson(_currentUserKey);

    if (data == null) return null;

    return AppUser.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
