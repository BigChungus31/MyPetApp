import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class DeliveryService {
  static DeliveryService? _instance;
  static DeliveryService get instance => _instance ??= DeliveryService._();
  DeliveryService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get user's delivery orders
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('delivery_orders')
          .select('*, order_items(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get user orders: $error');
      rethrow;
    }
  }

  // Create new delivery order
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
    double deliveryFee = 50.0,
    String? estimatedDeliveryTime,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Calculate total
      final double orderTotal = items.fold(0.0, (sum, item) {
            return sum + (item['total_price'] ?? 0.0);
          }) +
          deliveryFee;

      // Create order
      final orderData = {
        'user_id': userId,
        'order_total': orderTotal,
        'delivery_address': deliveryAddress,
        'delivery_fee': deliveryFee,
        'status': 'pending',
        'estimated_delivery_time': estimatedDeliveryTime,
      };

      final orderResponse = await _client
          .from('delivery_orders')
          .insert(orderData)
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Add order items
      final orderItems = items.map((item) {
        return {
          'order_id': orderId,
          'product_name': item['product_name'],
          'product_category': item['product_category'],
          'quantity': item['quantity'],
          'unit_price': item['unit_price'],
          'total_price': item['total_price'],
          'product_image_url': item['product_image_url'],
        };
      }).toList();

      await _client.from('order_items').insert(orderItems);

      debugPrint('✅ Order created successfully: $orderId');

      // Return order with items
      final completeOrder = await _client
          .from('delivery_orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .single();

      return completeOrder;
    } catch (error) {
      debugPrint('❌ Failed to create order: $error');
      rethrow;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
    DateTime? actualDeliveryTime,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status,
      };

      if (actualDeliveryTime != null) {
        updates['actual_delivery_time'] = actualDeliveryTime.toIso8601String();
      }

      await _client.from('delivery_orders').update(updates).eq('id', orderId);

      debugPrint('✅ Order status updated to: $status');
      return true;
    } catch (error) {
      debugPrint('❌ Failed to update order status: $error');
      return false;
    }
  }

  // Get order statistics
  Future<Map<String, dynamic>> getOrderStats() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get total orders count
      final totalOrdersData = await _client
          .from('delivery_orders')
          .select('id')
          .eq('user_id', userId)
          .count();

      // Get delivered orders count
      final deliveredOrdersData = await _client
          .from('delivery_orders')
          .select('id')
          .eq('user_id', userId)
          .eq('status', 'delivered')
          .count();

      // Get pending orders count
      final pendingOrdersData = await _client
          .from('delivery_orders')
          .select('id')
          .eq('user_id', userId)
          .inFilter('status', [
        'pending',
        'confirmed',
        'preparing',
        'out_for_delivery'
      ]).count();

      // Calculate total spent
      final ordersResponse = await _client
          .from('delivery_orders')
          .select('order_total')
          .eq('user_id', userId)
          .eq('status', 'delivered');

      final totalSpent = ordersResponse.fold(0.0, (sum, order) {
        return sum + (order['order_total'] ?? 0.0);
      });

      return {
        'total_orders': totalOrdersData.count ?? 0,
        'delivered_orders': deliveredOrdersData.count ?? 0,
        'pending_orders': pendingOrdersData.count ?? 0,
        'total_spent': totalSpent,
      };
    } catch (error) {
      debugPrint('❌ Failed to get order statistics: $error');
      return {
        'total_orders': 0,
        'delivered_orders': 0,
        'pending_orders': 0,
        'total_spent': 0.0,
      };
    }
  }

  // Get popular products (mock data - would be from admin panel in real app)
  List<Map<String, dynamic>> getPopularProducts() {
    return [
      {
        'product_name': 'Royal Canin Golden Retriever Adult Dry Food - 12kg',
        'product_category': 'food',
        'unit_price': 2800.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=300',
        'rating': 4.5,
        'description':
            'Specially formulated for Golden Retrievers over 15 months old',
      },
      {
        'product_name': 'KONG Classic Dog Toy - Large',
        'product_category': 'toys',
        'unit_price': 450.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=300',
        'rating': 4.8,
        'description': 'Durable rubber toy perfect for large dogs',
      },
      {
        'product_name': 'Pedigree DentaStix Daily Dental Chews',
        'product_category': 'accessories',
        'unit_price': 320.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=300',
        'rating': 4.3,
        'description': 'Daily dental care for dogs - reduces tartar buildup',
      },
      {
        'product_name': 'Whiskas Adult Cat Food - Ocean Fish, 1.2kg',
        'product_category': 'food',
        'unit_price': 185.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?w=300',
        'rating': 4.2,
        'description': 'Complete and balanced nutrition for adult cats',
      },
      {
        'product_name': 'Pet Carrier Bag - Medium Size',
        'product_category': 'accessories',
        'unit_price': 1250.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300',
        'rating': 4.4,
        'description': 'Comfortable and secure pet carrier for travel',
      },
      {
        'product_name': 'Fancy Feast Cat Treats - Chicken Flavor',
        'product_category': 'food',
        'unit_price': 95.00,
        'product_image_url':
            'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=300',
        'rating': 4.6,
        'description': 'Delicious treats that cats love',
      },
    ];
  }

  // Search products
  List<Map<String, dynamic>> searchProducts(String query, {String? category}) {
    final allProducts = getPopularProducts();

    return allProducts.where((product) {
      final matchesQuery = product['product_name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());

      final matchesCategory =
          category == null || product['product_category'] == category;

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
