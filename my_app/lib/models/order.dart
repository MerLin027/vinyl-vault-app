class Order {
	final String id;
	final String userId;
	final String orderNumber;
	final List<OrderItem> items;
	final String shippingAddress;
	final double subtotal;
	final double shipping;
	final double total;
	final String status;
	final String paymentMethod;
	final DateTime createdAt;

	Order({
		required this.id,
		required this.userId,
		required this.orderNumber,
		required this.items,
		required this.shippingAddress,
		required this.subtotal,
		required this.shipping,
		required this.total,
		required this.status,
		required this.paymentMethod,
		required this.createdAt,
	});

	Order.fromJson(Map<String, dynamic> json)
			: id = (json['_id'] ?? '').toString(),
				userId = (json['userId'] ?? '').toString(),
				orderNumber = (json['orderNumber'] ?? '').toString(),
				items = ((json['items'] as List?) ?? <dynamic>[])
						.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
						.toList(),
				shippingAddress = (json['shippingAddress'] ?? '').toString(),
				subtotal = _asDouble(json['subtotal']),
				shipping = _asDouble(json['shipping']),
				total = _asDouble(json['total']),
				status = (json['status'] ?? '').toString(),
				paymentMethod = (json['paymentMethod'] ?? '').toString(),
				createdAt = DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
						DateTime.fromMillisecondsSinceEpoch(0);

	Map<String, dynamic> toJson() {
		return {
			'_id': id,
			'userId': userId,
			'orderNumber': orderNumber,
			'items': items.map((item) => item.toJson()).toList(),
			'shippingAddress': shippingAddress,
			'subtotal': subtotal,
			'shipping': shipping,
			'total': total,
			'status': status,
			'paymentMethod': paymentMethod,
			'createdAt': createdAt.toIso8601String(),
		};
	}

	static double _asDouble(dynamic value) {
		if (value is num) {
			return value.toDouble();
		}

		if (value is String) {
			final parsed = double.tryParse(value);
			if (parsed != null) return parsed;
		}

		throw FormatException('Expected a numeric sum, but received: $value');
	}
}

class OrderItem {
	final String productId;
	final String title;
	final String artist;
	final String imageUrl;
	final double price;
	final int quantity;

	OrderItem({
		required this.productId,
		required this.title,
		required this.artist,
		required this.imageUrl,
		required this.price,
		required this.quantity,
	});

	OrderItem.fromJson(Map<String, dynamic> json)
			: productId = _readProductId(json['productId']),
				title = (json['title'] ?? '').toString(),
				artist = (json['artist'] ?? '').toString(),
				imageUrl = (json['imageUrl'] ?? '').toString(),
				price = _asDouble(json['price']),
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

	static double _asDouble(dynamic value) {
		if (value is num) {
			return value.toDouble();
		}

		if (value is String) {
			final parsed = double.tryParse(value);
			if (parsed != null) return parsed;
		}

		throw FormatException('Expected a numeric price, but received: $value');
	}

	static String _readProductId(dynamic product) {
		if (product is Map) {
			final id = product['_id'];
			if (id != null) return id.toString();
			throw const FormatException('Expected _id inside product object');
		}

		if (product is String) {
			return product;
		}

		throw FormatException('Expected product ID sequence, but got: $product');
	}

	static int _asInt(dynamic value) {
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

		throw FormatException('Expected an integer quantity, but received: $value');
	}
}
