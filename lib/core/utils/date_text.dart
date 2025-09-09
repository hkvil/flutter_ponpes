import 'package:intl/intl.dart';

/// Utility for formatting dates into Indonesian locale strings.
///
/// The [nowId] method returns the current date and time formatted
/// according to the pattern used in the provided UI design, e.g.
/// `15:00, Selasa, 29 Agustus 2025`.
class DateText {
  /// Returns the current date and time formatted for Indonesian locale.
  static String nowId() {
    final now = DateTime.now();
    return DateFormat('HH:mm, EEEE, d MMMM yyyy', 'id_ID').format(now);
  }
}