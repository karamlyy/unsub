class AppDateFormatter {
  static const List<String> _months = [
    'january','february','march','april','may','june',
    'july','august','september','october','november','december'
  ];

  static String monthDay(DateTime d) => '${d.day} ${_months[d.month - 1]}';
}