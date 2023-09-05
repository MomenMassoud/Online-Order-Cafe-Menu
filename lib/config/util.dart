import 'package:intl/intl.dart';

class Util
{
  static String getHumanReadableDate( int dt )
  {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);

    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  }
}