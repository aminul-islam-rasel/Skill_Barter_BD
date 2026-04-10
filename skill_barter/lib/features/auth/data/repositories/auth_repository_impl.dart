import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    return await _remoteDataSource.signUpWithEmail(name, email, password);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return await _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges;
  }
}
