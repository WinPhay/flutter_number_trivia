import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/data/resources/number_trivia_local_resource.dart';
import 'package:number_trivia/features/number_trivia/data/resources/number_trivia_remote_resource.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteResource extends Mock
  implements NumberTriviaRemoteResource {}

class MockNumberTriviaLocalResource extends Mock
  implements NumberTriviaLocalResource {}

class MockNetworkInfo extends Mock
  implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteResource mockNumberTriviaRemoteResource;
  late MockNumberTriviaLocalResource mockNumberTriviaLocalResource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteResource = MockNumberTriviaRemoteResource();
    mockNumberTriviaLocalResource = MockNumberTriviaLocalResource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteResource: mockNumberTriviaRemoteResource,
      localResource: mockNumberTriviaLocalResource,
      networkInfo: mockNetworkInfo
    );
  });

  group('getConcreteNumberTrivia', 
  () {

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test text');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if the device is online', 
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected as Function());
      });
    
    group('device is online',() { 

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful', 
        () async {
          // arrange
          when(mockNumberTriviaRemoteResource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaRemoteResource.getConcreteNumberTrivia(tNumber) as Function());
          expect(result, equals(Right(tNumberTrivia)));
        });
    });

    group('device is offline', () { 

      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return local data when the call to local data source is successful', 
        () async {
          // arrange
          when(mockNumberTriviaLocalResource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNumberTriviaLocalResource.getLastNumberTrivia() as Function());
          expect(result, equals(Right(tNumberTrivia)));
        });
    });
  });
}