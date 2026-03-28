import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../screens/session_expired_screen.dart';
import 'auth_service.dart';

class ApiService {
	static GlobalKey<NavigatorState>? navigatorKey;
	static bool _isSessionExpiredModalShown = false;

	final AuthService _authService;

	ApiService({AuthService? authService})
			: _authService = authService ?? AuthService();

	Future<void> _handleUnauthorized() async {
		final context = navigatorKey?.currentContext;
		if (context == null) {
			return;
		}

		await _authService.deleteToken();

		if (_isSessionExpiredModalShown) {
			return;
		}

		if (!context.mounted) {
			return;
		}

		_isSessionExpiredModalShown = true;

		showDialog<void>(
			context: context,
			barrierDismissible: false,
			builder: (_) => const SessionExpiredScreen(),
		).whenComplete(() {
			_isSessionExpiredModalShown = false;
		});
	}

	Future<void> _throwIfUnauthorized(http.Response response) async {
		if (response.statusCode == 401) {
			await _handleUnauthorized();
			throw Exception('Session expired');
		}
	}

	Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
		final headers = <String, String>{
			'Content-Type': 'application/json',
		};

		if (requiresAuth) {
			final token = await _authService.getToken();
			if (token != null && token.isNotEmpty) {
				headers['Authorization'] = 'Bearer $token';
			}
		}

		return headers;
	}

	Future<List<Product>> getProducts({
		String? genre,
		String? decade,
		String? condition,
		String? search,
	}) async {
		final queryParams = <String, String>{};
		if (genre != null && genre.isNotEmpty) queryParams['genre'] = genre;
		if (decade != null && decade.isNotEmpty) queryParams['decade'] = decade;
		if (condition != null && condition.isNotEmpty) {
			queryParams['condition'] = condition;
		}
		if (search != null && search.isNotEmpty) queryParams['search'] = search;

		final uri = Uri.parse('${Constants.apiBaseUrl}/products')
				.replace(queryParameters: queryParams.isEmpty ? null : queryParams);

		final response = await http.get(
			uri,
			headers: await _getHeaders(requiresAuth: false),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch products';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);

		if (decoded is List) {
			return decoded
					.map((item) => Product.fromJson((item as Map).cast<String, dynamic>()))
					.toList();
		}

		if (decoded is Map<String, dynamic>) {
			final dynamic listData = decoded['products'] ?? decoded['data'] ?? decoded['items'];
			if (listData is List) {
				return listData
						.map((item) => Product.fromJson((item as Map).cast<String, dynamic>()))
						.toList();
			}
		}

		return <Product>[];
	}

	Future<Product> getProductById(String id) async {
		final response = await http.get(
			Uri.parse('${Constants.apiBaseUrl}/products/$id'),
			headers: await _getHeaders(requiresAuth: false),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch product';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final productData = decoded['product'] ?? decoded['data'] ?? decoded;
			if (productData is Map) {
				return Product.fromJson(productData.cast<String, dynamic>());
			}
		}

		throw Exception('Invalid product response');
	}

	Future<List<CartItem>> getCart() async {
		final response = await http.get(
			Uri.parse('${Constants.apiBaseUrl}/cart'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch cart';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final items = decoded['items'];
			if (items is List) {
				return items
						.map((item) => CartItem.fromJson((item as Map).cast<String, dynamic>()))
						.toList();
			}
		}

		return <CartItem>[];
	}

	Future<void> addToCart(String productId, int quantity) async {
		final response = await http.post(
			Uri.parse('${Constants.apiBaseUrl}/cart'),
			headers: await _getHeaders(),
			body: jsonEncode({
				'productId': productId,
				'quantity': quantity,
			}),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to add item to cart';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}
	}

	Future<void> updateCartItem(String productId, int quantity) async {
		final response = await http.put(
			Uri.parse('${Constants.apiBaseUrl}/cart/$productId'),
			headers: await _getHeaders(),
			body: jsonEncode({'quantity': quantity}),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to update cart item';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}
	}

	Future<void> removeCartItem(String productId) async {
		final response = await http.delete(
			Uri.parse('${Constants.apiBaseUrl}/cart/$productId'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to remove cart item';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}
	}

	Future<void> clearCart() async {
		final response = await http.delete(
			Uri.parse('${Constants.apiBaseUrl}/cart'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to clear cart';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}
	}

	Future<Order> placeOrder(String shippingAddress) async {
		final response = await http.post(
			Uri.parse('${Constants.apiBaseUrl}/orders'),
			headers: await _getHeaders(),
			body: jsonEncode({'shippingAddress': shippingAddress}),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to place order';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final dynamic orderData = decoded['order'] ?? decoded['data'] ?? decoded;
			if (orderData is Map) {
				return Order.fromJson(orderData.cast<String, dynamic>());
			}
		}

		throw Exception('Invalid order response');
	}

	Future<List<Order>> getOrders() async {
		final response = await http.get(
			Uri.parse('${Constants.apiBaseUrl}/orders'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch orders';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is List) {
			return decoded
					.map((item) => Order.fromJson((item as Map).cast<String, dynamic>()))
					.toList();
		}

		if (decoded is Map<String, dynamic>) {
			final dynamic listData = decoded['orders'] ?? decoded['data'] ?? decoded['items'];
			if (listData is List) {
				return listData
						.map((item) => Order.fromJson((item as Map).cast<String, dynamic>()))
						.toList();
			}
		}

		return <Order>[];
	}

	Future<Order> getOrderById(String id) async {
		final response = await http.get(
			Uri.parse('${Constants.apiBaseUrl}/orders/$id'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch order';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final dynamic orderData = decoded['order'] ?? decoded['data'] ?? decoded;
			if (orderData is Map) {
				return Order.fromJson(orderData.cast<String, dynamic>());
			}
		}

		throw Exception('Invalid order response');
	}

	Future<User> getProfile() async {
		final response = await http.get(
			Uri.parse('${Constants.apiBaseUrl}/users/profile'),
			headers: await _getHeaders(),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to fetch profile';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final dynamic userData = decoded['user'] ?? decoded['data'] ?? decoded;
			if (userData is Map) {
				return User.fromJson(userData.cast<String, dynamic>());
			}
		}

		throw Exception('Invalid profile response');
	}

	Future<User> updateProfile({String? username, String? phone, String? address}) async {
		final body = <String, dynamic>{};
		if (username != null) body['username'] = username;
		if (phone != null) body['phone'] = phone;
		if (address != null) body['address'] = address;

		final response = await http.put(
			Uri.parse('${Constants.apiBaseUrl}/users/profile'),
			headers: await _getHeaders(),
			body: jsonEncode(body),
		);

		await _throwIfUnauthorized(response);

		if (response.statusCode != 200) {
			var message = 'Failed to update profile';
			try {
				final data = jsonDecode(response.body);
				if (data is Map<String, dynamic> &&
						data['message'] is String &&
						(data['message'] as String).isNotEmpty) {
					message = data['message'] as String;
				}
			} catch (_) {}
			throw Exception(message);
		}

		final decoded = jsonDecode(response.body);
		if (decoded is Map<String, dynamic>) {
			final dynamic userData = decoded['user'] ?? decoded['data'] ?? decoded;
			if (userData is Map) {
				return User.fromJson(userData.cast<String, dynamic>());
			}
		}

		throw Exception('Invalid profile response');
	}
}
