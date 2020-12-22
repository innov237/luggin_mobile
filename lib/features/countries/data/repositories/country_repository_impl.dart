import 'package:dartz/dartz.dart';
import 'package:luggin/core/erros/exceptions.dart';
import 'package:luggin/core/erros/failures.dart';
import 'package:luggin/core/network/network_info.dart';
import 'package:luggin/features/countries/data/datasources/country_remote_datasource.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';
import 'package:luggin/features/countries/domaine/repositories/country_repository.dart';
import 'package:meta/meta.dart';

class CountryRepositoryImpl implements CountryRepository {
  final ContryRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  CountryRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Country>> getContries() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getCountry());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return null;
    }
  }
}
