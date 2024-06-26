import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternetConnection() async {
  return await InternetConnectionChecker().hasConnection;
}

void main() async {
  bool result = await checkInternetConnection();
  print(result);
}