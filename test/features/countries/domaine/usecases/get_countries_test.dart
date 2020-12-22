import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:luggin/core/usecases/usecase.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';
import 'package:luggin/features/countries/domaine/repositories/country_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:luggin/features/countries/domaine/usecases/get_county.dart";

class MockCountryRepository extends Mock implements CountryRepository {}

void main() {
  GetCountries usecase;
  MockCountryRepository mockCountryRepository;
  setUp(() {
    mockCountryRepository = MockCountryRepository();
    usecase = GetCountries(mockCountryRepository);
  });

  final tCountry = Country(
    id: 1,
    name: 'cameroon',
    flag: 'cm',
    code: 'cm',
    diallingCode: '+237',
    currency: 'XAF',
  );

  test('should get countries from repository', () async {
    //arrange
    when(mockCountryRepository.getContries()).thenAnswer(
      (_) async => Right(tCountry),
    );
    //act
    final result = await usecase.call(NoParams());
    //assert
    expect(result, Right(tCountry));
    verify(mockCountryRepository.getContries());
    verifyNoMoreInteractions(mockCountryRepository);
  });
}
