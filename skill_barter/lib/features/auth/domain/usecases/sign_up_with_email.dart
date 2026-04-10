import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<UserEntity> call(String name, String email, String password) async {
    return await repository.signUpWithEmail(name, email, password);
  }
}
