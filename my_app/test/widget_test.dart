import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_vault/models/product.dart';

void main() {
  test('Product.fromJson parses images safely', () {
    final product = Product.fromJson({
      '_id': 'p1',
      'title': 'Kind of Blue',
      'artist': 'Miles Davis',
      'price': 29.99,
      'genre': 'Jazz',
      'decade': '1950s',
      'images': ['https://example.com/cover.jpg'],
      'condition': 'Mint',
      'rating': 4.8,
      'description': 'Classic jazz album',
    });

    expect(product.id, 'p1');
    expect(product.images.isNotEmpty, isTrue);
    expect(product.images[0], 'https://example.com/cover.jpg');
  });
}
