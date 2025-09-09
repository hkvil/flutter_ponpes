import 'package:intl/intl.dart';

/// Kelas utilitas untuk memformat waktu dan tanggal.
///
/// `currentTime()` mengembalikan jam dan menit saja (format "HH:mm"),
/// sedangkan `currentDay()` mengembalikan nama hari dan tanggal lengkap,
/// dengan penamaan hari Minggu sebagai "Ahad".
class DateText {
  // Constructor privat agar kelas ini tidak diinstansiasi.
  DateText._();

  /// Mengembalikan waktu saat ini dalam format "HH:mm".
  static String currentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm', 'id_ID').format(now);
    // Pastikan Anda sudah memanggil initializeDateFormatting('id_ID') di main().
  }

  /// Mengembalikan hari dan tanggal saat ini.
  ///
  /// Hari Minggu diterjemahkan menjadi "Ahad", sesuai standar penamaan pesantren.
  static String currentDay() {
    final now = DateTime.now();
    final Map<int, String> dayNames = {
      1: 'Senin',
      2: 'Selasa',
      3: 'Rabu',
      4: 'Kamis',
      5: 'Jumat',
      6: 'Sabtu',
      7: 'Ahad',
    };
    final dayName = dayNames[now.weekday] ?? '';
    final datePart = DateFormat('d MMMM yyyy', 'id_ID').format(now);
    return '$dayName, $datePart';
  }
}
