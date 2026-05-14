import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

String formatPostTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  // If newer than 7 days, show "5 mins ago", "2 days ago", etc.
  if (difference.inDays < 7) {
    return timeago.format(timestamp);
  }

  // If it's from a different year, show "12 Jan 2024"
  if (timestamp.year != now.year) {
    return DateFormat('d MMM yyyy').format(timestamp);
  }

  // Otherwise, just show "12 Jan"
  return DateFormat('d MMM').format(timestamp);
}
