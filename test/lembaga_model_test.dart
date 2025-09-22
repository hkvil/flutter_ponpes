import 'package:flutter_test/flutter_test.dart';
import 'package:pesantren_app/models/lembaga_model.dart';

void main() {
  test('Lembaga.fromJson parses correctly', () {
    final json = {
      'id': 1,
      'attributes': {
        'nama': 'Contoh',
        'slug': 'contoh',
        'images': [],
        'videos': [],
        'kontak': [],
      }
    };
    final lembaga = Lembaga.fromJson(json);
    expect(lembaga.id, 1);
    expect(lembaga.nama, 'Contoh');
    expect(lembaga.slug, 'contoh');
    expect(lembaga.images, isEmpty);
    expect(lembaga.videos, isEmpty);
    expect(lembaga.kontak, isEmpty);
  });
}
