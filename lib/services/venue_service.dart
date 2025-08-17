import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class VenueService {
  static VenueService? _instance;
  static VenueService get instance => _instance ??= VenueService._();
  VenueService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get all pet-friendly venues
  Future<List<Map<String, dynamic>>> getAllVenues({
    String? city,
    String? venueType,
    double? minRating,
  }) async {
    try {
      var query = _client.from('pet_friendly_venues').select();

      if (city != null) {
        query = query.ilike('city', '%$city%');
      }

      if (venueType != null) {
        query = query.eq('venue_type', venueType);
      }

      if (minRating != null) {
        query = query.gte('rating', minRating);
      }

      final response = await query.order('rating', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get venues: $error');
      rethrow;
    }
  }

  // Get venues by type (cafe, restaurant, park, hotel)
  Future<List<Map<String, dynamic>>> getVenuesByType(String venueType) async {
    try {
      final response = await _client
          .from('pet_friendly_venues')
          .select()
          .eq('venue_type', venueType)
          .order('rating', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get venues by type: $error');
      rethrow;
    }
  }

  // Get top-rated venues
  Future<List<Map<String, dynamic>>> getTopRatedVenues({int limit = 10}) async {
    try {
      final response = await _client
          .from('pet_friendly_venues')
          .select()
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get top-rated venues: $error');
      rethrow;
    }
  }

  // Search venues
  Future<List<Map<String, dynamic>>> searchVenues(String query) async {
    try {
      final response = await _client
          .from('pet_friendly_venues')
          .select()
          .or('name.ilike.%$query%,address.ilike.%$query%,venue_type.ilike.%$query%')
          .order('rating', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to search venues: $error');
      rethrow;
    }
  }

  // Get venue details
  Future<Map<String, dynamic>?> getVenueDetails(String venueId) async {
    try {
      final response = await _client
          .from('pet_friendly_venues')
          .select()
          .eq('id', venueId)
          .single();

      return response;
    } catch (error) {
      debugPrint('❌ Failed to get venue details: $error');
      return null;
    }
  }

  // Add new venue (for admin or community contributions)
  Future<Map<String, dynamic>?> addVenue({
    required String name,
    required String address,
    String city = 'Delhi',
    required String venueType,
    double? rating,
    List<String>? petAmenities,
    String? contactNumber,
    String? openingHours,
    String? websiteUrl,
    String? imageUrl,
  }) async {
    try {
      final venueData = {
        'name': name,
        'address': address,
        'city': city,
        'venue_type': venueType,
        'rating': rating,
        'pet_amenities': petAmenities,
        'contact_number': contactNumber,
        'opening_hours': openingHours,
        'website_url': websiteUrl,
        'image_url': imageUrl,
      };

      final response = await _client
          .from('pet_friendly_venues')
          .insert(venueData)
          .select()
          .single();

      debugPrint('✅ Venue added successfully: $name');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to add venue: $error');
      return null;
    }
  }

  // Get venue categories with counts
  Future<List<Map<String, dynamic>>> getVenueCategories() async {
    try {
      // Get counts for each venue type
      final cafeData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .eq('venue_type', 'cafe')
          .count();

      final restaurantData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .eq('venue_type', 'restaurant')
          .count();

      final parkData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .eq('venue_type', 'park')
          .count();

      final hotelData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .eq('venue_type', 'hotel')
          .count();

      return [
        {
          'type': 'cafe',
          'name': 'Pet-Friendly Cafes',
          'count': cafeData.count ?? 0,
          'icon': '☕',
          'color': 'brown',
        },
        {
          'type': 'restaurant',
          'name': 'Restaurants',
          'count': restaurantData.count ?? 0,
          'icon': '🍽️',
          'color': 'orange',
        },
        {
          'type': 'park',
          'name': 'Parks & Gardens',
          'count': parkData.count ?? 0,
          'icon': '🌳',
          'color': 'green',
        },
        {
          'type': 'hotel',
          'name': 'Pet-Friendly Hotels',
          'count': hotelData.count ?? 0,
          'icon': '🏨',
          'color': 'blue',
        },
      ];
    } catch (error) {
      debugPrint('❌ Failed to get venue categories: $error');
      return [];
    }
  }

  // Get nearby venues (mock implementation - would use geolocation in real app)
  Future<List<Map<String, dynamic>>> getNearbyVenues({
    String location = 'Delhi',
    int limit = 20,
  }) async {
    try {
      final response = await _client
          .from('pet_friendly_venues')
          .select()
          .ilike('city', '%$location%')
          .order('rating', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get nearby venues: $error');
      rethrow;
    }
  }

  // Get venue statistics
  Future<Map<String, dynamic>> getVenueStats() async {
    try {
      final totalVenuesData =
          await _client.from('pet_friendly_venues').select('id').count();

      final topRatedData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .gte('rating', 4.5)
          .count();

      final newVenuesData = await _client
          .from('pet_friendly_venues')
          .select('id')
          .gte(
              'created_at',
              DateTime.now()
                  .subtract(const Duration(days: 30))
                  .toIso8601String())
          .count();

      return {
        'total_venues': totalVenuesData.count ?? 0,
        'top_rated_venues': topRatedData.count ?? 0,
        'new_venues_this_month': newVenuesData.count ?? 0,
      };
    } catch (error) {
      debugPrint('❌ Failed to get venue statistics: $error');
      return {
        'total_venues': 0,
        'top_rated_venues': 0,
        'new_venues_this_month': 0,
      };
    }
  }
}
