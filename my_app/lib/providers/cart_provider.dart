import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
	final ApiService _apiService;

	List<CartItem> _items = <CartItem>[];
	bool _isLoading = false;
	String? _error;
	bool _disposed = false;
	/// Operation lock — prevents concurrent mutating calls (add/update/remove)
	/// from racing with each other and the subsequent loadCart refresh.
	bool _isBusy = false;

	CartProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

	List<CartItem> get items => _items;
	bool get isLoading => _isLoading;
	String? get error => _error;

	int get itemCount =>
			_items.fold<int>(0, (sum, item) => sum + item.quantity);

	double get subtotal =>
			_items.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));

	double get shipping => 0.0;

	double get total => subtotal + shipping;

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
	/// the human-readable message produced by ApiService.
	static String _cleanMessage(Object e) {
		final raw = e.toString();
		const prefix = 'Exception: ';
		return raw.startsWith(prefix) ? raw.substring(prefix.length) : raw;
	}

	Future<void> loadCart() async {
		if (_disposed) return;
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_items = await _apiService.getCart();
		} catch (e) {
			_error = _cleanMessage(e);
		} finally {
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
		}
	}

	Future<bool> addToCart(String productId, int quantity) async {
		if (_disposed || _isBusy) return false;
		_isBusy = true;
		try {
			await _apiService.addToCart(productId, quantity);
			await loadCart();
			return true;
		} catch (e) {
			if (!_disposed) {
				_error = _cleanMessage(e);
				notifyListeners();
			}
			return false;
		} finally {
			_isBusy = false;
		}
	}

	Future<bool> updateQuantity(String productId, int quantity) async {
		if (_disposed || _isBusy) return false;
		_isBusy = true;
		try {
			await _apiService.updateCartItem(productId, quantity);
			await loadCart();
			return true;
		} catch (e) {
			if (!_disposed) {
				_error = _cleanMessage(e);
				notifyListeners();
			}
			return false;
		} finally {
			_isBusy = false;
		}
	}

	Future<bool> removeItem(String productId) async {
		if (_disposed || _isBusy) return false;
		_isBusy = true;
		try {
			await _apiService.removeCartItem(productId);
			await loadCart();
			return true;
		} catch (e) {
			if (!_disposed) {
				_error = _cleanMessage(e);
				notifyListeners();
			}
			return false;
		} finally {
			_isBusy = false;
		}
	}

	Future<bool> clearCart() async {
		if (_disposed) return false;
		try {
			await _apiService.clearCart();
			_items = <CartItem>[];
			_error = null;
			notifyListeners();
			return true;
		} catch (e) {
			if (!_disposed) {
				_error = _cleanMessage(e);
				notifyListeners();
			}
			return false;
		}
	}

	void reset() {
		_items = <CartItem>[];
		_error = null;
		notifyListeners();
	}
}
