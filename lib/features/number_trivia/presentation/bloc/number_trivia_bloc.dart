import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  static const invalidInputErrorMessage = 'Invalid input - the number must be a positive integer or zero';
  static const serverFailureMessage = 'Server Failure';
  static const cacheFailureMessage = 'Cache Failure';

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumber);
  }

  FutureOr<void> _getTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
    await inputEither.fold(
      (failure) async {
        emit(Error(message: _getErrorMessage(failure)));
      },
      (integer) async {
        emit(Loading());
        final result = await getConcreteNumberTrivia(Params(number: integer));
        result.fold(
          (failure) => emit(Error(message: _getErrorMessage(failure))),
          (trivia) => emit(Loaded(trivia: trivia)),
        );
      },
    );
  }

  FutureOr<void> _getTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final result = await getRandomNumberTrivia(NoParams());
    result.fold(
      (failure) => emit(Error(message: _getErrorMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return serverFailureMessage;
      case const (CacheFailure):
        return cacheFailureMessage;
      case const (InvalidInputFailure):
        return invalidInputErrorMessage;
      default:
        return 'Unexpected error';
    }
  }
}

