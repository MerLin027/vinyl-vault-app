import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
	final AuthService _authService;
	final ApiService _apiService;

	User? _currentUser;
	bool _isLoggedIn = false;
	bool _isLoading = false;
	String? _error;

	UserProvider({AuthService? authService, ApiService? apiService})
			: _authService = authService ?? AuthService(),
				_apiService = apiService ?? ApiService();

	User? get currentUser => _currentUser;
	bool get isLoggedIn => _isLoggedIn;
	bool get isLoading => _isLoading;
	String? get error => _error;

	Future<bool> login(String email, String password) async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		var success = false;

		try {
			final result = await _authService.login(email, password);
			success = result['success'] == true;

			if (success) {
				final user = result['user'];
				if (user is User) {
					_currentUser = user;
				}
				_isLoggedIn = true;
				_error = null;
			} else {
				_error = (result['message'] ?? 'Login failed').toString();
			}
		} catch (e) {
			_error = e.toString();
			success = false;
		} finally {
			_isLoading = false;
			notifyListeners();
		}

		return success;
	}

	Future<bool> signup(String username, String email, String password) async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		var success = false;

		try {
			final result = await _authService.signup(username, email, password);
			success = result['success'] == true;

			if (success) {
				final user = result['user'];
				if (user is User) {
					_currentUser = user;
				}
				_isLoggedIn = true;
				_error = null;
			} else {
				_error = (result['message'] ?? 'Signup failed').toString();
			}
		} catch (e) {
			_error = e.toString();
			success = false;
		} finally {
			_isLoading = false;
			notifyListeners();
		}

		return success;
	}

	Future<void> logout() async {
		await _authService.logout();
		_currentUser = null;
		_isLoggedIn = false;
		_error = null;
		notifyListeners();
	}

	Future<void> loadProfile() async {
		try {
			final user = await _apiService.getProfile();
			_currentUser = user;
			_isLoggedIn = true;
			_error = null;
		} catch (e) {
			_error = e.toString();
		}

		notifyListeners();
	}

	Future<bool> updateProfile({String? username, String? phone, String? address}) async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			final updatedUser = await _apiService.updateProfile(
				username: username,
				phone: phone,
				address: address,
			);

			_currentUser = updatedUser;
			_error = null;
			_isLoading = false;
			notifyListeners();
			return true;
		} catch (e) {
			_error = e.toString();
			_isLoading = false;
			notifyListeners();
			return false;
		}
	}

	Future<void> checkLoginStatus() async {
		_isLoggedIn = await _authService.isLoggedIn();

		if (_isLoggedIn) {
			await loadProfile();
		} else {
			_currentUser = null;
			_error = null;
			notifyListeners();
		}
	}
}
