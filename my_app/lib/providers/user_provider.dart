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
	bool _disposed = false;
	/// Operation lock — prevents concurrent auth calls (e.g. rapid double-tap
	/// on Login / Sign Up / Save Profile) from firing overlapping requests.
	bool _isBusy = false;

	UserProvider({AuthService? authService, ApiService? apiService})
			: _authService = authService ?? AuthService(),
				_apiService = apiService ?? ApiService();

	User? get currentUser => _currentUser;
	bool get isLoggedIn => _isLoggedIn;
	bool get isLoading => _isLoading;
	String? get error => _error;

	@override
	void dispose() {
		_disposed = true;
		super.dispose();
	}

	@override
	void notifyListeners() {
		if (!_disposed) {
			super.notifyListeners();
		}
	}

	/// Strips the raw Dart "Exception: " prefix so UI error labels only show
	/// the human-readable message produced by ApiService / AuthService.
	static String _cleanMessage(Object e) {
		final raw = e.toString();
		const prefix = 'Exception: ';
		return raw.startsWith(prefix) ? raw.substring(prefix.length) : raw;
	}

	Future<bool> login(String email, String password) async {
		if (_isBusy) return false;
		_isBusy = true;
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
			_error = _cleanMessage(e);
			success = false;
		} finally {
			_isBusy = false;
			_isLoading = false;
			notifyListeners();
		}

		return success;
	}

	Future<bool> signup(String username, String email, String password) async {
		if (_isBusy) return false;
		_isBusy = true;
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
			_error = _cleanMessage(e);
			success = false;
		} finally {
			_isBusy = false;
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
		if (_disposed) return;
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			final user = await _apiService.getProfile();
			_currentUser = user;
			_isLoggedIn = true;
			_error = null;
		} catch (e) {
			// Profile fetch failed (e.g. network error or 401).
			// Mark as logged-out so the app doesn't navigate to MainScreen
			// with a null user and stale isLoggedIn = true.
			_currentUser = null;
			_isLoggedIn = false;
			_error = _cleanMessage(e);
		} finally {
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
		}
	}

	Future<bool> updateProfile({String? username, String? phone, String? address}) async {
		if (_disposed || _isBusy) return false;
		_isBusy = true;
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
			return true;
		} catch (e) {
			_error = _cleanMessage(e);
			return false;
		} finally {
			_isBusy = false;
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
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
