import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
	final ApiService _apiService;

	List<Order> _orders = <Order>[];
	Order? _currentOrder;
	bool _isLoading = false;
	String? _error;

	OrderProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

	List<Order> get orders => _orders;
	Order? get currentOrder => _currentOrder;
	bool get isLoading => _isLoading;
	String? get error => _error;

	Future<void> loadOrders() async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_orders = await _apiService.getOrders();
			_error = null;
		} catch (e) {
			_error = e.toString();
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<void> getOrderById(String id) async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		try {
			_currentOrder = await _apiService.getOrderById(id);
			_error = null;
		} catch (e) {
			_error = e.toString();
		} finally {
			_isLoading = false;
			notifyListeners();
		}
	}

	Future<bool> placeOrder(String shippingAddress) async {
		_isLoading = true;
		_error = null;
		notifyListeners();

		var success = false;

		try {
			_currentOrder = await _apiService.placeOrder(shippingAddress);
			await loadOrders();
			success = true;
		} catch (e) {
			_error = e.toString();
			success = false;
		} finally {
			_isLoading = false;
			notifyListeners();
		}

		return success;
	}

	void reset() {
		_orders = <Order>[];
		_currentOrder = null;
		_error = null;
		notifyListeners();
	}
}
