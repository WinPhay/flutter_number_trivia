import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteResource {
  // Calls the http://numbersapi.com/{number} endpoint.
  //
  // Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  // Calls the http://numbersapi.com/random endpoint.
  //
  // Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteResourceImpl implements NumberTriviaRemoteResource {
  
  final http.Client client;

  NumberTriviaRemoteResourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromURL('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromURL('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    final response =  await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}