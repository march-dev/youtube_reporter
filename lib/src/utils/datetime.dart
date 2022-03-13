const ptTimezoneOffset = -7;

Duration ptTimeToNextDay() {
  final now = DateTime.now();
  final ptNow = now
      .subtract(Duration(hours: ptTimezoneOffset - now.timeZoneOffset.inHours));
  return DateTime(ptNow.year, ptNow.month, ptNow.day + 1).difference(ptNow);
}
