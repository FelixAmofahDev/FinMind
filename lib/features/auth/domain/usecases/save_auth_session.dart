import 'package:dartz/dartz.dart';
import 'package:finmind/core/errors/failures.dart';

import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SaveAuthSession {
  const SaveAuthSession(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(AuthSession session) {
    return _repository.saveAuthSession(session);
  }
}