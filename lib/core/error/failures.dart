import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];

  get message => null;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}