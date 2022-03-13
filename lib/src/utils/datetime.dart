import 'logger.dart';

const ptTimezoneOffset = Duration(hours: -7);

Duration ptTimeToNextDay() {
  final nowUtc = DateTime.now().toUtc();
  final ptNow = nowUtc.add(ptTimezoneOffset);
  final ptNextDay = DateTime(ptNow.year, ptNow.month, ptNow.day + 1);
  final diff = ptNextDay.difference(ptNow);
  log(nowUtc.toString());
  log(ptNow.toString());
  log(ptNextDay.toString());
  log(diff.toString());
  return ptNextDay.difference(ptNow);
}
