import 'package:dartz/dartz.dart';
import 'package:luggin/core/erros/failures.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';

abstract class CountryRepository {
  Future<Either<Failure, Country>> getContries();
}
