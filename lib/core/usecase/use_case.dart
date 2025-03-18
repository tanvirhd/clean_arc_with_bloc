import 'package:clean_arc_bloc/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<output, input> {
  Future<Either<Failure, output>> execute(input inputParams);
}
