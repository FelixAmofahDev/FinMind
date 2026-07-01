import '../entities/signup_payload.dart';
import '../repositories/auth_repository.dart';

class Signup {
  const Signup(this._repository);

  final AuthRepository _repository;

  Future<String> call({required SignupPayload payload}) {
    return _repository.signup(payload: payload);
  }
}