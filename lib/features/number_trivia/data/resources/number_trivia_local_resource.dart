import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalResource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// 
  /// the user had an internet connection.
  /// 
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Caches the [NumberTriviaModel] to local storage.
  /// 
  /// Throws [CachException] if no cache was present.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalResourceImpl implements NumberTriviaLocalResource {
  
  final SharedPreferences sharedPreferences;
  
  NumberTriviaLocalResourceImpl({required this.sharedPreferences});
  
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);

    if(jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(cachedNumberTrivia, triviaToCache.toJson() as String);
  }
}