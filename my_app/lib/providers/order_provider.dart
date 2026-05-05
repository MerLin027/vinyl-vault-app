import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
	final ApiService _apiService;

	List<Order> _orders = <Order>[];
	Order? _currentOrder;
	bool _isLoading = false;
	String? _error;
	bool _disposed = false;
	/// Submission lock — prevents concurrent placeOrder calls (e.g. rapid
	/// double-tap on the "Place Order" button) from creating duplicate orders.
	bool _isSubmitting = false;

	OrderProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

	List<Order> get orders => _orders;
	Order? get currentOrder => _currentOrder;
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
	/// the human-readable message produced by ApiService.
	static String _cleanMessage(Object e) {
		final raw = e.toString();
		const prefix = 'Exception: ';
		return raw.startsWith(prefix) ? raw.substring(prefix.length) : raw;
	}

	Future<void> loadOrders() async {
		if (_disposed) return;
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_orders = await _apiService.getOrders();
			_error = null;
		} catch (e) {
			_error = _cleanMessage(e);
		} finally {
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
		}
	}

	Future<void> getOrderById(String id) async {
		if (_disposed) return;
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_currentOrder = await _apiService.getOrderById(id);
			_error = null;
		} catch (e) {
			_error = _cleanMessage(e);
		} finally {
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
		}
	}

	Future<bool> placeOrder(String shippingAddress) async {
		if (_disposed || _isSubmitting) return false;
		_isSubmitting = true;
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			// Place the order — if this throws, the order was NOT created.
			_currentOrder = await _apiService.placeOrder(shippingAddress);

			// Refresh the order list. Non-critical background refresh:
			// a failure here must NOT mark the order as failed.
			try {
				await loadOrders();
			} catch (_) {
				// Non-fatal — the order was placed; the list will refresh next time.
			}

			return true;
		} catch (e) {
			_error = _cleanMessage(e);
			return false;
		} finally {
			_isSubmitting = false;
			if (!_disposed) {
				_isLoading = false;
				notifyListeners();
			}
		}
	}

	void reset() {
		_orders = <Order>[];
		_currentOrder = null;
		_error = null;
		notifyListeners();
	}
}
