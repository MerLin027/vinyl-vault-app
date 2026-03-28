import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/constants.dart';
import '../models/user.dart';

class AuthService {
	static const String _tokenKey = 'jwt';

	final FlutterSecureStorage _storage;

	AuthService({FlutterSecureStorage? storage})
			: _storage = storage ?? const FlutterSecureStorage();

	Future<String?> getToken() {
		return _storage.read(key: _tokenKey);
	}

	Future<void> saveToken(String token) {
		return _storage.write(key: _tokenKey, value: token);
	}

	Future<void> deleteToken() {
		return _storage.delete(key: _tokenKey);
	}

	Future<bool> isLoggedIn() async {
		final token = await getToken();
		return token != null && token.isNotEmpty;
	}

	Future<Map<String, dynamic>> signup(
		String username,
		String email,
		String password,
	) async {
		try {
			final response = await http.post(
				Uri.parse('${Constants.apiBaseUrl}/auth/signup'),
				headers: {'Content-Type': 'application/json'},
				body: jsonEncode({
					'username': username,
					'email': email,
					'password': password,
				}),
			);

			final Map<String, dynamic> data = _decodeBody(response.body);

			if (response.statusCode >= 200 && response.statusCode < 300) {
				final token = data['token']?.toString();
				if (token != null && token.isNotEmpty) {
					await saveToken(token);
				}

				return {
					'success': true,
					'user': User.fromJson((data['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
				};
			}

			return {
				'success': false,
				'message': _extractMessage(data),
			};
		} catch (_) {
			return {
				'success': false,
				'message': 'Unable to sign up. Please try again.',
			};
		}
	}

	Future<Map<String, dynamic>> login(String email, String password) async {
		try {
			final response = await http.post(
				Uri.parse('${Constants.apiBaseUrl}/auth/login'),
				headers: {'Content-Type': 'application/json'},
				body: jsonEncode({
					'email': email,
					'password': password,
				}),
			);

			final Map<String, dynamic> data = _decodeBody(response.body);

			if (response.statusCode >= 200 && response.statusCode < 300) {
				final token = data['token']?.toString();
				if (token != null && token.isNotEmpty) {
					await saveToken(token);
				}

				return {
					'success': true,
					'user': User.fromJson((data['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{}),
				};
			}

			return {
				'success': false,
				'message': _extractMessage(data),
			};
		} catch (_) {
			return {
				'success': false,
				'message': 'Unable to log in. Please try again.',
			};
		}
	}

	Future<bool> logout() async {
		final token = await getToken();
		var success = false;

		try {
			final response = await http.post(
				Uri.parse('${Constants.apiBaseUrl}/auth/logout'),
				headers: {
					'Content-Type': 'application/json',
					if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
				},
			);
			success = response.statusCode >= 200 && response.statusCode < 300;
		} catch (_) {
			success = false;
		} finally {
			await deleteToken();
		}

		return success;
	}

	Map<String, dynamic> _decodeBody(String body) {
		if (body.isEmpty) {
			return <String, dynamic>{};
		}

		final decoded = jsonDecode(body);
		if (decoded is Map<String, dynamic>) {
			return decoded;
		}

		return <String, dynamic>{};
	}

	String _extractMessage(Map<String, dynamic> data) {
		final message = data['message'];
		if (message is String && message.isNotEmpty) {
			return message;
		}
		return 'Request failed. Please try again.';
	}
}
