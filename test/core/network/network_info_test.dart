import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockInterConnectionChecker extends Mock
  implements InternetConnectionChecker {}

void main() {
  late MockInterConnectionChecker mockInterConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockInterConnectionChecker = MockInterConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInterConnectionChecker);
  });

  group(
    'isConnected', 
    () {
      test(
        'should forward the call to InternetConnectionChecker.hasConnection',
        () async {
          // arrange
          final tHasConnectionFuture = Future.value(true);
          when(mockInterConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
          print(mockInterConnectionChecker.hasConnection);
          // act
          final result = await networkInfoImpl.isConnected;
          // assert
          verify(mockInterConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
        },
      );
  });
}