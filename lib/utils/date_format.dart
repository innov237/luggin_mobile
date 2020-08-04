import 'package:easy_localization/easy_localization.dart';

class ChangeFormatDate {

  static toDateTimeEn(timestamp) {
    String formattedDate =
        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  static toDateTimeFr(timestamp) {
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(timestamp));
    return formattedDate;
  }
}
