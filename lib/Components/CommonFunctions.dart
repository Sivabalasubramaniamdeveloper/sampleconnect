import 'package:intl/intl.dart';
import '../Utils/Constants/ImageConstants.dart';

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
    print("Error parsing date-time string: $e");
    return DateTime.now();
  }
}
String convertToDateTimeString(String dateTimeString) {
  print(dateTimeString);
  try {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    return dateTime.toString();
  } catch (e) {
    print("Error parsing date-time string: $e");
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



// Future<bool> checkNotificationPermission() async {
//   final settings = await FirebaseMessaging.instance.getNotificationSettings();
//   return settings.authorizationStatus == AuthorizationStatus.authorized;
// }

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input; // Handle empty strings
  return input[0].toUpperCase() + input.substring(1);
}
