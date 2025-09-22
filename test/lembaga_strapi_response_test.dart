import 'package:flutter_test/flutter_test.dart';
import 'package:pesantren_app/models/lembaga_model.dart';

void main() {
  test('Parsing list lembaga dari response Strapi', () {
    final response = {
      "data": [
        {
          "id": 4,
          "documentId": "ey456vhntdd4sbfawi9ga8th",
          "nama": "Pusat Kepegawaian dan Pengawasan",
          "slug": "pusat-kepegawaian-dan-pengawasan",
          "images": [],
          "videos": [],
          "kontak": []
        },
      ],
      "meta": {
        "pagination": {"page": 1, "pageSize": 25, "pageCount": 2, "total": 45}
      }
    };
    final list = Lembaga.listFromStrapiEnvelope(response);
    expect(list, isNotEmpty);
    expect(list.first.nama, 'Pusat Kepegawaian dan Pengawasan');
    expect(list.first.slug, 'pusat-kepegawaian-dan-pengawasan');
  });

  test('Parsing detail lembaga dari response Strapi', () {
    final response = {
      "data": [
        {
          "id": 6,
          "documentId": "mj9u1qpbsuer6iqh78qqxghj",
          "nama": "Pusat Pengawasan dan Pembinaan SDM Putri",
          "slug": "pusat-pengawasan-dan-pembinaan-sdm-putri",
          "images": [],
          "videos": [],
          "kontak": []
        }
      ],
      "meta": {
        "pagination": {"page": 1, "pageSize": 25, "pageCount": 1, "total": 1}
      }
    };
    final list = Lembaga.listFromStrapiEnvelope(response);
    expect(list.length, 1);
    expect(list.first.nama, 'Pusat Pengawasan dan Pembinaan SDM Putri');
    expect(list.first.slug, 'pusat-pengawasan-dan-pembinaan-sdm-putri');
  });
}
