import 'package:luggin/features/countries/data/models/country_model.dart';

abstract class ContryRemoteDatasource {
  ///Calls the http://seremoword.com/seremoapi/public/api/getAllCountry endpoint
  ///
  /// Trows a [ServerException] for all error codes.
  Future<CountryModel> getCountry();
}
