const ptTimezoneOffset = Duration(hours: -7);

Duration ptTimeToNextDay() {
  final nowUtc = DateTime.now().toUtc();
  final ptNow = nowUtc.add(ptTimezoneOffset);
  final ptNextDay = DateTime(ptNow.year, ptNow.month, ptNow.day + 1);
  return ptNextDay.difference(ptNow);
}
