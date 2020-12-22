import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luggin/core/erros/exceptions.dart';
import 'package:luggin/core/erros/failures.dart';
import 'package:luggin/core/network/network_info.dart';
import 'package:luggin/features/countries/data/datasources/country_remote_datasource.dart';
import 'package:luggin/features/countries/data/models/country_model.dart';
import 'package:luggin/features/countries/data/repositories/country_repository_impl.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';

class MockRemoteDataSource extends Mock implements ContryRemoteDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  CountryRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CountryRepositoryImpl(
      networkInfo: mockNetworkInfo,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('get country', () {
    final tCountryModel = CountryModel(
      id: 1,
      name: 'cameroon',
      flag: 'cm',
      code: 'cm',
      diallingCode: '+237',
      currency: 'XAF',
    );

    final Country tCountry = tCountryModel;

    test('should check if the device is online', () async {
      //arrage
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getContries();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        //arrage
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(mockRemoteDataSource.getCountry()).thenAnswer(
          (_) async => tCountryModel,
        );
        //act
        final result = await repository.getContries();
        //assert
        expect(result, equals(Right(tCountry)));
      });

      test(
          'should return serveur failure when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(mockRemoteDataSource.getCountry()).thenThrow(ServerException());
        //act
        final result = await repository.getContries();
        //assert
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        //arrage
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should not call dataremote sources', () async {
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
      });
    });
  });
}
