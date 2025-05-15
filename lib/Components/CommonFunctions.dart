import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../Utils/Constants/ColorConstants.dart';
import '../Utils/Constants/ImageConstants.dart';
import '../Utils/Constants/TextConstants.dart';

String formatDateTime(String timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return DateFormat('dd-MM-yyyy hh:mm:a').format(dateTime);
}

String formatDate(String timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return DateFormat('dd-MM-yyyy').format(dateTime);
}

String formatTime(String timestamp) {
  final dateTime =
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  return DateFormat('hh:mm:a').format(dateTime);
}

DateTime convertToDateTime(String dateTimeString) {
  try {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy hh:mm a");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    return dateTime;
  } catch (e) {
    return DateTime.now();
  }
}

String convertToDateTimeString(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('dd-MM HH:mm a').format(dateTime);
    return formattedDate;
  } catch (e) {
    return DateTime.now().toString();
  }
}

DateTime convertEpochToDateTime(int epochTime) {
  try {
    return DateTime.fromMillisecondsSinceEpoch(epochTime * 1000, isUtc: true)
        .toLocal();
  } catch (e) {
    print("Error converting epoch time: $e");
    return DateTime.now();
  }
}

int convertToEpoch(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return dateTime.millisecondsSinceEpoch; // Returns epoch in milliseconds
}

String convertEpochToReadableFormattedDate(int epochTime) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTime);
  return DateFormat("MMM d yyyy h:mm a").format(dateTime);
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String generateChatID(String uuid1,String uuid2){
  List uuids=[uuid1,uuid2];
  uuids.sort();
  String chatID=uuids.fold('', (id,uuid)=>"$id$uuid");
  return chatID.trim();
}

String limitMessage(String message, {int limit = 10}) {
  if (message.length <= limit) {
    return message;
  } else {
    return "${message.substring(0, limit)}...";
  }
}

String formatTimestampToTime(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  final String formattedTime = DateFormat('dd/MM hh:mm a').format(dateTime);
  return formattedTime;
}

String formatDateTimeString(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formatted = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  return formatted;
}