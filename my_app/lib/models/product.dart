class Product {
	final String id;
	final String title;
	final String artist;
	final double price;
	final String genre;
	final String decade;
	final List<String> images;
	final String condition;
	final double rating;
	final String description;

	Product({
		required this.id,
		required this.title,
		required this.artist,
		required this.price,
		required this.genre,
		required this.decade,
		required this.images,
		required this.condition,
		required this.rating,
		required this.description,
	});

	Product.fromJson(Map<String, dynamic> json)
			: id = (json['_id'] ?? '').toString(),
				title = (json['title'] ?? '').toString(),
				artist = (json['artist'] ?? '').toString(),
				price = _asDouble(json['price']),
				genre = (json['genre'] ?? '').toString(),
				decade = (json['decade'] ?? '').toString(),
				images = (json['images'] as List?)
								?.map((image) => image.toString())
								.toList() ??
						<String>[],
				condition = (json['condition'] ?? '').toString(),
				rating = _asDouble(json['rating']),
				description = (json['description'] ?? '').toString();

	Map<String, dynamic> toJson() {
		return {
			'_id': id,
			'title': title,
			'artist': artist,
			'price': price,
			'genre': genre,
			'decade': decade,
			'images': images,
			'condition': condition,
			'rating': rating,
			'description': description,
		};
	}

	static double _asDouble(dynamic value) {
		if (value is num) {
			return value.toDouble();
		}

		if (value is String) {
			return double.tryParse(value) ?? 0.0;
		}

		return 0.0;
	}
}
