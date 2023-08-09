// return a formatted data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // Timestamp is the object we retrive from firestore
  // so to display it, lets convert it to a string
  DateTime dataTime = timestamp.toDate();

  // get year
  String year = dataTime.year.toString();

  // get month
  String month = dataTime.month.toString();

  // get day
  String day = dataTime.day.toString();

  // final formatted date
  String formattedData = '$day/$month/$year';

  return formattedData;
}

String formatTime(Timestamp timestamp) {
  // Timestamp is the object we retrive from firestore
  // so to display it, lets convert it to a string
  DateTime dataTime = timestamp.toDate();

  // get hour
  String hour = dataTime.hour.toString();

  // get minute
  String minute = dataTime.minute.toString();

  // get second
  String second = dataTime.second.toString();

  // final formatted time
  String formattedTime = '$hour:$minute';

  return formattedTime;
}
