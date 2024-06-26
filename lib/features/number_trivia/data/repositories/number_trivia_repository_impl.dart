import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repositories.dart';
import '../resources/number_trivia_local_resource.dart';
import '../resources/number_trivia_remote_resource.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteResource remoteResource;
  final NumberTriviaLocalResource localResource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteResource, 
    required this.localResource, 
    required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteResource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteResource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteorRandom
  ) async {
    if( await networkInfo.isConnected) {
      try {
        final result = await getConcreteorRandom();
        return Right( result );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localResource.getLastNumberTrivia();
        return Right( result );
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}