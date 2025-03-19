import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtils {
  final DateTime _currentDateTime;
  final DateFormat _defaultDateFormatter;

  MyDateUtils({DateTime? currentDateTime, String? dateFormat})
      : _currentDateTime = currentDateTime ?? DateTime.now(),
        _defaultDateFormatter = dateFormat == null ? DateFormat('yyyy-MM-dd') : DateFormat(dateFormat);

  static String getTodayDate({dateFormat = 'yyyy-MM-dd'}) {
    final DateFormat formatter = DateFormat(dateFormat);
    var today = DateTime.now();
    return formatter.format(today);
  }

  static String parseStringDate({String? date, toDateFormat = "dd MMM", bool checkInvalidDate = false}) {
    if (date == null || date.isEmpty) {
      return "";
    }
    if (checkInvalidDate && date == "0000-00-00") {
      return "";
    }
    try {
      final date2 = DateTime.parse(date);
      final DateFormat formatter = DateFormat(toDateFormat);
      return formatter.format(date2);
    } catch (_) {
      debugPrint('Debug MyDateUtils.parseStringDate : $_ ');
      return "";
    }
  }

  static String parseTimeStamp(int timeStamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return parseDate(date: date, toDateFormat: "EEE, dd MMM yyyy, hh:mm:ss a");
  }

  static String parseDate({DateTime? date, toDateFormat = "dd MMM", bool checkInvalidDate = false}) {
    if (date == null) {
      return "";
    }
    try {
      final DateFormat formatter = DateFormat(toDateFormat);
      return formatter.format(date);
    } catch (_) {
      return "";
    }
  }

  Future<DateTime?> openDatePicker(BuildContext context,
      {DateTime? firstDate, DateTime? lastDate, DateTime? initialDate}) async {
    final date = await showDatePicker(
        context: (context),
        firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 4)),
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 4)),
        initialDate: initialDate ?? DateTime.now());
    return date;
  }

  /// returns date of current week's first day (Monday)
  String getStartWeekDate() {
    int currentDay = _currentDateTime.weekday;
    DateTime firstDayOfWeek = _currentDateTime.subtract(Duration(days: currentDay - 1));
    return _defaultDateFormatter.format(firstDayOfWeek);
  }

  /// returns date of current week's last day (Sunday)
  String getEndWeekDate() {
    int currentDay = _currentDateTime.weekday;
    DateTime lastDayOfWeek = _currentDateTime.add(Duration(days: 7 - currentDay));
    return _defaultDateFormatter.format(lastDayOfWeek);
  }

  /// returns start date of current month
  String getMonthStartDate() {
    DateTime firstDayOfMonth = DateTime(_currentDateTime.year, _currentDateTime.month, 1);
    return _defaultDateFormatter.format(firstDayOfMonth);
  }

  /// returns end date of current month
  String getMonthEndDate() {
    int currentMonth = _currentDateTime.month;
    DateTime lastDayOfMonth = DateTime(_currentDateTime.year, currentMonth + 1, 0);
    return _defaultDateFormatter.format(lastDayOfMonth);
  }

  /// returns current date if [duration] parameter is null else current date + [duration].
  ///
  /// return date in [_defaultDateFormatter] which is in 'yyyy-MM-dd' format if [dateFormat] is null.
  ///
  /// [_defaultDateFormatter] is optional parameter in [MyDateUtils] class with default value of 'yyyy-MM-dd''.
  ///
  String getDate({Duration duration = Duration.zero, String? dateFormat}) {
    final DateFormat formatter = dateFormat == null ? _defaultDateFormatter : DateFormat(dateFormat);
    var date = _currentDateTime.add(duration);
    return formatter.format(date);
  }

  String getDateDifference(String? startDateStr, String? endDateStr) {
    final startDate = parseStringDate(date: startDateStr, toDateFormat: "yyyy-MM-dd");
    final endDate = parseStringDate(date: endDateStr, toDateFormat: "yyyy-MM-dd");
    //final _startDate = DateFormat("yyyy-MM-dd").parse(startDate);
    //final _endDate = DateFormat("yyyy-MM-dd").parse(endDate);
    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      try {
        final differenceInDays = DateTime.parse(endDate).difference(DateTime.parse(startDate)).inDays;
        return differenceInDays.toString();
      } on Exception catch (_) {
        return "0";
      }
    } else {
      return "0";
    }
  }

  ///returns date range of previous week's start and end day's date.
  ///
  /// date range is from monday to sunday.
  MyDate previousWeek() {
    var currentWeek = getCurrentWeek();
    return currentWeek.subtract(const Duration(days: 7));
  }

  ///returns date range of next week's date from monday to sunday
  MyDate nextWeek() {
    var currentWeek = getCurrentWeek();
    return currentWeek.add(const Duration(days: 7));
  }

  ///returns date range of current week's date from monday to sunday
  MyDate getCurrentWeek() {
    int currentDay = _currentDateTime.weekday;
    //DateTime firstDayOfWeek = _currentDateTime.subtract(Duration(days: currentDay - 1));
    DateTime firstDayOfWeek =
        DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day - (currentDay - 1));
    DateTime lastDayOfWeek =
        DateTime(_currentDateTime.year, _currentDateTime.month, _currentDateTime.day + (7 - currentDay));
    //DateTime lastDayOfWeek = _currentDateTime.add(Duration(days: 7 - currentDay));
    return MyDate(firstDayOfWeek, lastDayOfWeek);
  }

  MyDate previousMonth() {
    return _currentMonth(-1);
  }

  MyDate currentMonth() {
    return _currentMonth(0);
  }

  MyDate nextMonth() {
    return _currentMonth(1);
  }

  MyDate _currentMonth(int addMonth) {
    int currentMonth = _currentDateTime.month + addMonth;
    DateTime firstDayOfMonth = DateTime(_currentDateTime.year, currentMonth, 1);
    DateTime lastDayOfMonth = DateTime(_currentDateTime.year, currentMonth + 1, 0);
    return MyDate(firstDayOfMonth, lastDayOfMonth);
  }

  ///returns date range of today and today minus 6.
  ///
  ///Eg. monday and previous tuesday.
  MyDate previousWeekFromToday() {
    var today = dateOnly(_currentDateTime);
    var from = dateOnly(today.subtract(const Duration(days: 6)));
    return MyDate(from, today);
  }

  ///remove time from [DateTime]
  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
}

class MyDate {
  DateTime startDate;
  DateTime endDate;

  MyDate(this.startDate, this.endDate);

  factory MyDate.today() {
    var currentDate = DateTime.now();
    var today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    return MyDate(today, today);
  }

  MyDate subtract(Duration duration) {
    return MyDate(startDate.subtract(duration), endDate.subtract(duration));
  }

  MyDate add(Duration duration) {
    return MyDate(startDate.add(duration), endDate.add(duration));
  }

  String get formattedStartDate => MyDateUtils.parseDate(date: startDate, toDateFormat: "dd/MM/yyyy");

  String get formattedEndDate => MyDateUtils.parseDate(date: endDate, toDateFormat: "dd/MM/yyyy");

  @override
  String toString() {
    return 'MyDate{startDate: $startDate, endDate: $endDate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDate && runtimeType == other.runtimeType && startDate == other.startDate && endDate == other.endDate;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}
