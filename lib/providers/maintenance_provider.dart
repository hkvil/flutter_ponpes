import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MaintenanceProvider extends ChangeNotifier {
  bool _isInMaintenance = false;
  String _maintenanceMessage = 'Aplikasi sedang dalam maintenance';
  bool _isChecking = false;
  DateTime? _lastCheckTime;

  bool get isInMaintenance => _isInMaintenance;
  String get maintenanceMessage => _maintenanceMessage;
  bool get isChecking => _isChecking;

  Future<void> checkBackendStatus() async {
    // Rate limiting: minimum 5 seconds between checks
    final now = DateTime.now();
    if (_lastCheckTime != null &&
        now.difference(_lastCheckTime!).inSeconds < 5) {
      return; // Too soon, skip this check
    }

    if (_isChecking) return;

    _isChecking = true;
    _lastCheckTime = now;
    notifyListeners();

    try {
      final apiHost = dotenv.env['API_HOST']!;
      final dio = Dio();

      // Check status endpoint with Strapi JSON format
      final response = await dio.get(
        '$apiHost/api/status',
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Parse Strapi JSON response
      final jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        final isMaintenance =
            jsonData['data']['isMaintenance'] as bool? ?? false;

        if (isMaintenance) {
          // Backend is in maintenance mode
          _isInMaintenance = true;
          _maintenanceMessage =
              'Aplikasi sedang dalam maintenance. Coba lagi nanti.';
        } else {
          // Backend is healthy
          _isInMaintenance = false;
          _maintenanceMessage = '';
        }
      } else {
        // Invalid response format
        _isInMaintenance = true;
        _maintenanceMessage =
            'Format response tidak valid. Aplikasi dalam mode offline.';
      }
    } on DioException catch (e) {
      // Backend is down or not responding
      _isInMaintenance = true;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _maintenanceMessage =
            'Koneksi timeout. Backend sedang tidak merespons.';
      } else if (e.type == DioExceptionType.connectionError) {
        _maintenanceMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      } else if (e.response?.statusCode == 503) {
        _maintenanceMessage =
            'Server sedang dalam maintenance. Coba lagi nanti.';
      } else {
        _maintenanceMessage =
            'Backend sedang bermasalah. Aplikasi dalam mode offline.';
      }
    } catch (e) {
      _isInMaintenance = true;
      _maintenanceMessage =
          'Terjadi kesalahan sistem. Aplikasi dalam mode offline.';
    }

    _isChecking = false;
    notifyListeners();
  }

  void forceMaintenanceMode(String message) {
    _isInMaintenance = true;
    _maintenanceMessage = message;
    notifyListeners();
  }

  void exitMaintenanceMode() {
    _isInMaintenance = false;
    _maintenanceMessage = '';
    notifyListeners();
  }
}
