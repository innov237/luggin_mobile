import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);

  List<Object> get props => [];
}

//General failure
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
