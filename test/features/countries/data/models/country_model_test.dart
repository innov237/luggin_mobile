import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:luggin/features/countries/data/models/country_model.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCountryModel = CountryModel(
    id: 1,
    name: "cameroun",
    code: "cm",
    diallingCode: "+237",
    currency: "XAF",
    flag: "cm",
  );

  test('should be a subclass of country entity', () {
    //assert
    expect(tCountryModel, isA<Country>());
  });

  group('fromJson', () {
    test('should return valid model when the JSON is same as fixture',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('country.json'));
      //act
      final result = CountryModel.fromJson(jsonMap);
      //assert
      expect(result, tCountryModel);
    });
  });

  group('toJson', () {
    test('should return JSON Map containing the proper data', () async {
      //act
      final result = tCountryModel.toJson();
      //assert
      final expectedMap = {
        "id": 1,
        "name": "cameroun",
        "code": "cm",
        "diallingCode": "+237",
        "currency": "XAF",
        "flag": "cm",
      };
      expect(result, expectedMap);
    });
  });
}
