import 'package:dartz/dartz.dart';
import 'package:finmind/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class CheckOnboardingStatus {
  const CheckOnboardingStatus(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, bool>> call() {
    return _repository.checkOnboardingStatus();
  }
}