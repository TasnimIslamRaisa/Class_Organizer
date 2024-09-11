import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Unique {
  // Generate a UUID for user ID
  String userId() {
    var uuid = Uuid();
    String s = uuid.v4().replaceAll("-", "");
    Random dice = Random();
    int num = dice.nextInt(10);
    Random sec = Random.secure();
    int nu = sec.nextInt(9);

    // Generate timestamp-based ID
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    String year = DateTime.now().year.toString();
    int m = Random().nextInt(int.parse(year)) + 1;
    String mm = m.toString();
    String uId = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    return "$s$mm$id$uId";
  }

  // Simple UUID generation
  String uId() {
    var uuid = Uuid();
    return uuid.v4().replaceAll("-", "");
  }

  // Generate unique ID with datetime and hex code
  String generateUniqueID() {
    String dateTime = DateFormat('yyyyMMdd_HHmmss_SSS').format(DateTime.now());
    String hexCode = generateHexCode();
    return "${dateTime}_$hexCode";
  }

  // Get current time in HH:mm format
  String getCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  // Get time in 12-hour format with AM/PM
  String getTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  // Get current date in yyyy-MM-dd format
  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Generate a random hex code using UUID
  String generateHexCode() {
    var uuid = Uuid();
    return uuid.v4().split('-').first;
  }

  // Get current date and time in yyyy-MM-dd HH:mm:ss format
  String getCurrentDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  // Get current date and time in 12-hour format with AM/PM
  String getDateTime() {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());
  }

  // Generate a unique integer ID based on the current time
  int uniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  // Get formatted date with a day offset
  String getFormattedDate(int dayOffset) {
    DateTime date = DateTime.now().add(Duration(days: dayOffset));
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Get formatted day name with a day offset
  String getFormattedDay(int dayOffset) {
    DateTime date = DateTime.now().add(Duration(days: dayOffset));
    return DateFormat('EEEE').format(date);
  }

  // Get today's day name
  String getToday() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  // Convert string to Date object
  static DateTime convertStringToDate(String dateString, String format) {
    return DateFormat(format).parse(dateString);
  }

  // Get day name from Date object
  static String getDayNameFromDate(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  // Get day of the month from a date string
  static String getDayOfMonth(String dateTime) {
    DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTime);
    return DateFormat('dd').format(date);
  }

  // Get month from date string
  static String getMonth(String dateTime) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(dateTime);
    return DateFormat('MM').format(date);
  }

  // Get day name from a datetime string
  static String getDayName(String dateTime) {
    DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTime);
    return DateFormat('EEE').format(date);
  }

  // Get month name from a datetime string
  static String getMonthName(String dateTime) {
    DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTime);
    return DateFormat('MMM').format(date);
  }

  // Get time with AM/PM from a datetime string
  static String getTimeWithAMPM(String dateTime) {
    DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss a').parse(dateTime);
    return DateFormat('hh:mm a').format(date);
  }
}
