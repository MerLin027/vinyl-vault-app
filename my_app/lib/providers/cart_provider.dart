import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
	final ApiService _apiService;

	List<CartItem> _items = <CartItem>[];
	bool _isLoading = false;
	String? _error;

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

	Future<void> loadCart() async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_items = await _apiService.getCart();
		} catch (e) {
			_error = e.toString();
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<bool> addToCart(String productId, int quantity) async {
		try {
			await _apiService.addToCart(productId, quantity);
			await loadCart();
			return true;
		} catch (e) {
			_error = e.toString();
			notifyListeners();
			return false;
		}
	}

	Future<bool> updateQuantity(String productId, int quantity) async {
		try {
			await _apiService.updateCartItem(productId, quantity);
			await loadCart();
			return true;
		} catch (e) {
			_error = e.toString();
			notifyListeners();
			return false;
		}
	}

	Future<bool> removeItem(String productId) async {
		try {
			await _apiService.removeCartItem(productId);
			await loadCart();
			return true;
		} catch (e) {
			_error = e.toString();
			notifyListeners();
			return false;
		}
	}

	Future<bool> clearCart() async {
		try {
			await _apiService.clearCart();
			_items = <CartItem>[];
			_error = null;
			notifyListeners();
			return true;
		} catch (e) {
			_error = e.toString();
			notifyListeners();
			return false;
		}
	}

	void reset() {
		_items = <CartItem>[];
		_error = null;
		notifyListeners();
	}
}
