import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Country extends Equatable {
  final int id;
  final String name;
  final String code;
  final String currency;
  final String diallingCode;
  final String flag;

  Country({
    @required this.id,
    @required this.name,
    @required this.code,
    @required this.diallingCode,
    @required this.currency,
    @required this.flag,
  });

  @override
  List<Object> get props => [id, name, code, diallingCode, currency, flag];
}
