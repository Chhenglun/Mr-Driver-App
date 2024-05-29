// ignore_for_file: deprecated_member_use

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {

  static void launchURL(String text) async {
    String url = text;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  static void call(String number) async {
    String url = "tel:$number";
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  static void sendEmail(String email) async {
    String url = email;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';
    if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0
    ) {
      time = format.format(date);
    }
    var formattedDate = DateFormat.yMMMd().format(date);
    return "$formattedDate $time".replaceAll(",", "");
  }
}
