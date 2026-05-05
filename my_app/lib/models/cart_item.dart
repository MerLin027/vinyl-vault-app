class CartItem {
	final String productId;
	final String title;
	final String artist;
	final String imageUrl;
	final double price;
	final int quantity;

	CartItem({
		required this.productId,
		required this.title,
		required this.artist,
		required this.imageUrl,
		required this.price,
		required this.quantity,
	});

	CartItem.fromJson(Map<String, dynamic> json)
		  : productId = _readProductId(json['productId']),
			title = _readProductField(json['productId'], 'title'),
			artist = _readProductField(json['productId'], 'artist'),
			imageUrl = _firstImage(_readProductFieldDynamic(json['productId'], 'images')),
			price = _asDouble(_readProductFieldDynamic(json['productId'], 'price')),
				quantity = _asInt(json['quantity']);

	Map<String, dynamic> toJson() {
		return {
			'productId': productId,
			'title': title,
			'artist': artist,
			'imageUrl': imageUrl,
			'price': price,
			'quantity': quantity,
		};
	}

	static String _readProductId(dynamic product) {
		if (product == null) return '';
		if (product is Map) {
			final id = product['_id'];
			if (id != null) return id.toString();
			return '';
		}

		if (product is String) {
			return product;
		}

		return '';
	}

	static dynamic _readProductFieldDynamic(dynamic product, String key) {
		if (product is Map) {
			return product[key];
		}

		return null;
	}

	static String _readProductField(dynamic product, String key) {
		return (_readProductFieldDynamic(product, key) ?? '').toString();
	}

	static String _firstImage(dynamic images) {
		if (images is List && images.isNotEmpty) {
			return images.first.toString();
		}
		return '';
	}

	static double _asDouble(dynamic value) {
		if (value == null) return 0.0;
		if (value is num) {
			return value.toDouble();
		}

		if (value is String) {
			final parsed = double.tryParse(value);
			if (parsed != null) return parsed;
		}

		return 0.0;
	}

	static int _asInt(dynamic value) {
		if (value == null) return 0;
		if (value is int) {
			return value;
		}

		if (value is num) {
			return value.toInt();
		}

		if (value is String) {
			final parsed = int.tryParse(value);
			if (parsed != null) return parsed;
		}

		return 0;
	}
}
