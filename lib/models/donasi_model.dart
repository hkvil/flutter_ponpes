import 'media_model.dart';

class TransaksiModel {
  final int id;
  final String name;
  final int amount;
  final String date;

  TransaksiModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: int.tryParse(json['amount'].toString()) ?? 0,
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount.toString(),
      'date': date,
    };
  }

  String getFormattedAmount() {
    return _formatCurrency(amount);
  }

  String _formatCurrency(int amount) {
    String str = amount.toString();
    String result = '';
    int counter = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      counter++;
      result = str[i] + result;
      if (counter % 3 == 0 && i != 0) {
        result = '.' + result;
      }
    }

    return 'Rp. $result';
  }
}

class DonasiModel {
  final int id;
  final String documentId;
  final String title;
  final String deadline;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final int target;
  final int terkumpul;
  final MediaModel? media;
  final List<TransaksiModel> transaksi;

  DonasiModel({
    required this.id,
    required this.documentId,
    required this.title,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.target,
    required this.terkumpul,
    this.media,
    this.transaksi = const [],
  });

  factory DonasiModel.fromJson(Map<String, dynamic> json) {
    // Calculate terkumpul from transaksi if not provided
    int calculatedTerkumpul = int.tryParse(json['terkumpul'].toString()) ?? 0;
    List<TransaksiModel> transaksiList = [];

    if (json['transaksi'] != null && json['transaksi'] is List) {
      transaksiList = (json['transaksi'] as List)
          .map((item) => TransaksiModel.fromJson(item))
          .toList();

      // If terkumpul is null, calculate from transaksi
      if (json['terkumpul'] == null) {
        calculatedTerkumpul =
            transaksiList.fold(0, (sum, transaksi) => sum + transaksi.amount);
      }
    }

    return DonasiModel(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      title: json['title'] ?? '',
      deadline: json['deadline'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      target: int.tryParse(json['target'].toString()) ?? 0,
      terkumpul: calculatedTerkumpul,
      media: json['media'] != null ? MediaModel.fromJson(json['media']) : null,
      transaksi: transaksiList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'title': title,
      'deadline': deadline,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'publishedAt': publishedAt,
      'target': target.toString(),
      'terkumpul': terkumpul.toString(),
      'media': media?.toJson(),
      'transaksi': transaksi.map((t) => t.toJson()).toList(),
    };
  }

  // Helper methods
  double get progress => target > 0 ? terkumpul / target : 0.0;

  int get sisaTarget => target - terkumpul;

  int get sisaHari {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final difference = deadlineDate.difference(now).inDays;
      return difference > 0 ? difference : 0;
    } catch (e) {
      return 0;
    }
  }

  String getImageUrl(String baseUrl, {String size = 'medium'}) {
    return media?.getImageUrl(baseUrl, size: size) ?? '';
  }

  // Method untuk format currency
  String getFormattedTarget() {
    return _formatCurrency(target);
  }

  String getFormattedTerkumpul() {
    return _formatCurrency(terkumpul);
  }

  String getFormattedSisaTarget() {
    return _formatCurrency(sisaTarget);
  }

  String _formatCurrency(int amount) {
    // Format Indonesian Rupiah
    String str = amount.toString();
    String result = '';
    int counter = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      counter++;
      result = str[i] + result;
      if (counter % 3 == 0 && i != 0) {
        result = '.' + result;
      }
    }

    return 'Rp. $result';
  }

  // Method untuk cek apakah deadline sudah lewat
  bool get isExpired {
    try {
      final deadlineDate = DateTime.parse(deadline);
      return DateTime.now().isAfter(deadlineDate);
    } catch (e) {
      return false;
    }
  }

  // Method untuk cek apakah target sudah tercapai
  bool get isTargetReached => terkumpul >= target;

  // Status donasi
  String get status {
    if (isExpired) return 'Berakhir';
    if (isTargetReached) return 'Tercapai';
    return 'Aktif';
  }
}
