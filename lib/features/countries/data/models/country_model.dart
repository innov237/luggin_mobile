import 'package:meta/meta.dart';
import 'package:luggin/features/countries/domaine/entities/country.dart';

class CountryModel extends Country {
  final int id;
  final String name;
  final String code;
  final String currency;
  final String diallingCode;
  final String flag;

  CountryModel({
    @required this.id,
    @required this.name,
    @required this.code,
    @required this.diallingCode,
    @required this.currency,
    @required this.flag,
  }) : super(
          id: id,
          name: name,
          code: code,
          diallingCode: diallingCode,
          currency: currency,
          flag: flag,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      name: json['country_name'],
      code: json['country_code'],
      diallingCode: json['country_dialling_code'],
      currency: json['country_currency'],
      flag: json['country_flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "diallingCode": diallingCode,
      "currency": currency,
      "flag": flag,
    };
  }
}
