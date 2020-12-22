import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:luggin/core/erros/failures.dart';
import 'package:luggin/core/usecases/usecase.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';
import 'package:luggin/features/countries/domaine/repositories/country_repository.dart';

class GetCountries implements UseCase<Country, NoParams> {
  final CountryRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, Country>> call(NoParams params) async {
    return await repository.getContries();
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
