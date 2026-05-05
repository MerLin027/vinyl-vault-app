import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../screens/session_expired_screen.dart';
import 'auth_service.dart';

/// Global request timeout applied to every HTTP call.
const Duration _kTimeout = Duration(seconds: 15);

class ApiService {
	static GlobalKey<NavigatorState>? navigatorKey;
	static bool _isSessionExpiredModalShown = false;

	final AuthService _authService;

	ApiService({AuthService? authService})
			: _authService = authService ?? AuthService();

	// ─── Auth helpers ────────────────────────────────────────────────────────

	Future<void> _handleUnauthorized() async {
		await _authService.deleteToken();

		if (_isSessionExpiredModalShown) return;

		final navigator = navigatorKey?.currentState;
		if (navigator == null) return;

		_isSessionExpiredModalShown = true;
		navigator.pushAndRemoveUntil(
			PageRouteBuilder(
				pageBuilder: (context, animation, secondaryAnimation) =>
						const SessionExpiredScreen(),
				transitionsBuilder: (context, animation, secondaryAnimation, child) =>
						FadeTransition(opacity: animation, child: child),
				transitionDuration: const Duration(milliseconds: 300),
			),
			(route) => false,
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

	// ─── Centralised error classifier ────────────────────────────────────────

	/// Runs [call], adds a [_kTimeout], and maps low-level network exceptions
	/// (SocketException, HandshakeException, TimeoutException, FormatException)
	/// to readable messages so the UI never shows raw Dart exception strings.
	Future<T> _safeRequest<T>(Future<T> Function() call) async {
		try {
			return await call().timeout(_kTimeout);
		} on SocketException {
			throw Exception('No internet connection. Please check your network and try again.');
		} on HandshakeException {
			throw Exception('Secure connection failed. Please try again.');
		} on TimeoutException {
			throw Exception('The request timed out. Please try again.');
		} on FormatException {
			throw Exception('Received an unexpected response from the server. Please try again.');
		}
		// All other exceptions (including our own Exception throws) propagate
		// naturally to the caller.
	}

	/// Extracts the server-supplied error message from a non-2xx body, or falls
	/// back to [fallback].
	String _extractErrorMessage(String body, String fallback) {
		try {
			final data = jsonDecode(body);
			if (data is Map<String, dynamic> &&
					data['message'] is String &&
					(data['message'] as String).isNotEmpty) {
				return data['message'] as String;
			}
		} catch (_) {}
		return fallback;
	}

	// ─── Products ────────────────────────────────────────────────────────────

	Future<List<Product>> getProducts({
		String? genre,
		String? decade,
		String? condition,
		String? search,
	}) async {
		return _safeRequest(() async {
			final queryParams = <String, String>{};
			if (genre != null && genre.isNotEmpty) queryParams['genre'] = genre;
			if (decade != null && decade.isNotEmpty) queryParams['decade'] = decade;
			if (condition != null && condition.isNotEmpty) queryParams['condition'] = condition;
			if (search != null && search.isNotEmpty) queryParams['search'] = search;

			final uri = Uri.parse('${Constants.apiBaseUrl}/products')
					.replace(queryParameters: queryParams.isEmpty ? null : queryParams);

			final response = await http.get(
				uri,
				headers: await _getHeaders(requiresAuth: false),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch products'));
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

			throw const FormatException('Unexpected JSON structure for products list.');
		});
	}

	Future<Product> getProductById(String id) async {
		return _safeRequest(() async {
			final response = await http.get(
				Uri.parse('${Constants.apiBaseUrl}/products/$id'),
				headers: await _getHeaders(requiresAuth: false),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch product'));
			}

			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				final productData = decoded['product'] ?? decoded['data'] ?? decoded;
				if (productData is Map) {
					return Product.fromJson(productData.cast<String, dynamic>());
				}
			}

			throw Exception('Invalid product response');
		});
	}

	// ─── Cart ────────────────────────────────────────────────────────────────

	Future<List<CartItem>> getCart() async {
		return _safeRequest(() async {
			final response = await http.get(
				Uri.parse('${Constants.apiBaseUrl}/cart'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch cart'));
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

			throw const FormatException('Unexpected JSON structure for cart.');
		});
	}

	Future<void> addToCart(String productId, int quantity) async {
		return _safeRequest(() async {
			final response = await http.post(
				Uri.parse('${Constants.apiBaseUrl}/cart'),
				headers: await _getHeaders(),
				body: jsonEncode({
					'productId': productId,
					'quantity': quantity,
				}),
			);

			await _throwIfUnauthorized(response);
			if (!(response.statusCode == 200 || response.statusCode == 201)) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to add item to cart'));
			}
		});
	}

	Future<void> updateCartItem(String productId, int quantity) async {
		return _safeRequest(() async {
			final response = await http.put(
				Uri.parse('${Constants.apiBaseUrl}/cart/$productId'),
				headers: await _getHeaders(),
				body: jsonEncode({'quantity': quantity}),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to update cart item'));
			}
		});
	}

	Future<void> removeCartItem(String productId) async {
		return _safeRequest(() async {
			final response = await http.delete(
				Uri.parse('${Constants.apiBaseUrl}/cart/$productId'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to remove cart item'));
			}
		});
	}

	Future<void> clearCart() async {
		return _safeRequest(() async {
			final response = await http.delete(
				Uri.parse('${Constants.apiBaseUrl}/cart'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to clear cart'));
			}
		});
	}

	// ─── Orders ──────────────────────────────────────────────────────────────

	Future<Order> placeOrder(String shippingAddress) async {
		return _safeRequest(() async {
			final response = await http.post(
				Uri.parse('${Constants.apiBaseUrl}/orders'),
				headers: await _getHeaders(),
				body: jsonEncode({'shippingAddress': shippingAddress}),
			);

			await _throwIfUnauthorized(response);

			if (!(response.statusCode == 200 || response.statusCode == 201)) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to place order'));
			}

			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				final dynamic orderData = decoded['order'] ?? decoded['data'] ?? decoded;
				if (orderData is Map) {
					return Order.fromJson(orderData.cast<String, dynamic>());
				}
			}

			throw Exception('Invalid order response');
		});
	}

	Future<List<Order>> getOrders() async {
		return _safeRequest(() async {
			final response = await http.get(
				Uri.parse('${Constants.apiBaseUrl}/orders'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch orders'));
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

			throw const FormatException('Unexpected JSON structure for orders list.');
		});
	}

	Future<Order> getOrderById(String id) async {
		return _safeRequest(() async {
			final response = await http.get(
				Uri.parse('${Constants.apiBaseUrl}/orders/$id'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch order'));
			}

			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				final dynamic orderData = decoded['order'] ?? decoded['data'] ?? decoded;
				if (orderData is Map) {
					return Order.fromJson(orderData.cast<String, dynamic>());
				}
			}

			throw Exception('Invalid order response');
		});
	}

	// ─── User ─────────────────────────────────────────────────────────────────

	Future<User> getProfile() async {
		return _safeRequest(() async {
			final response = await http.get(
				Uri.parse('${Constants.apiBaseUrl}/users/profile'),
				headers: await _getHeaders(),
			);

			await _throwIfUnauthorized(response);

			if (response.statusCode != 200) {
				throw Exception(_extractErrorMessage(response.body, 'Failed to fetch profile'));
			}

			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				final dynamic userData = decoded['user'] ?? decoded['data'] ?? decoded;
				if (userData is Map) {
					return User.fromJson(userData.cast<String, dynamic>());
				}
			}

			throw Exception('Invalid profile response');
		});
	}

	Future<User> updateProfile({String? username, String? phone, String? address}) async {
		return _safeRequest(() async {
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
				throw Exception(_extractErrorMessage(response.body, 'Failed to update profile'));
			}

			final decoded = jsonDecode(response.body);
			if (decoded is Map<String, dynamic>) {
				final dynamic userData = decoded['user'] ?? decoded['data'] ?? decoded;
				if (userData is Map) {
					return User.fromJson(userData.cast<String, dynamic>());
				}
			}

			throw Exception('Invalid profile response');
		});
	}
}
