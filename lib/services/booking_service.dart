import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class BookingService {
  static BookingService? _instance;
  static BookingService get instance => _instance ??= BookingService._();
  BookingService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get user's appointments
  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('appointments')
          .select('*, pets!inner(*)')
          .eq('pets.owner_id', userId)
          .order('appointment_date')
          .order('appointment_time');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get user appointments: $error');
      rethrow;
    }
  }

  // Book appointment (grooming or clinic)
  Future<Map<String, dynamic>> bookAppointment({
    required String petId,
    String? businessId,
    required String appointmentType, // 'grooming' or 'clinic'
    required DateTime appointmentDate,
    required String appointmentTime,
    String? serviceDetails,
    double? estimatedCost,
    String? notes,
  }) async {
    try {
      final appointmentData = {
        'pet_id': petId,
        'business_id': businessId,
        'appointment_type': appointmentType,
        'appointment_date': appointmentDate.toIso8601String().split('T')[0],
        'appointment_time': appointmentTime,
        'service_details': serviceDetails,
        'estimated_cost': estimatedCost,
        'notes': notes,
        'status': 'pending',
      };

      final response = await _client
          .from('appointments')
          .insert(appointmentData)
          .select('*, pets(*)')
          .single();

      debugPrint('✅ Appointment booked successfully');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to book appointment: $error');
      rethrow;
    }
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await _client.from('appointments').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', appointmentId);

      debugPrint('✅ Appointment status updated to: $status');
      return true;
    } catch (error) {
      debugPrint('❌ Failed to update appointment status: $error');
      return false;
    }
  }

  // Get user's consultations
  Future<List<Map<String, dynamic>>> getUserConsultations() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('consultations')
          .select('*, pets!inner(*)')
          .eq('pets.owner_id', userId)
          .order('scheduled_datetime');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get user consultations: $error');
      rethrow;
    }
  }

  // Book e-consultation
  Future<Map<String, dynamic>> bookConsultation({
    required String petId,
    required String vetName,
    String? vetSpecialization,
    required double consultationFee,
    required DateTime scheduledDateTime,
    String? notes,
  }) async {
    try {
      final consultationData = {
        'pet_id': petId,
        'vet_name': vetName,
        'vet_specialization': vetSpecialization,
        'consultation_fee': consultationFee,
        'scheduled_datetime': scheduledDateTime.toIso8601String(),
        'notes': notes,
        'status': 'scheduled',
      };

      final response = await _client
          .from('consultations')
          .insert(consultationData)
          .select('*, pets(*)')
          .single();

      debugPrint('✅ Consultation booked successfully');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to book consultation: $error');
      rethrow;
    }
  }

  // Get available vets from Businesses table
  Future<List<Map<String, dynamic>>> getAvailableVets({
    String? location,
    String? specialization,
  }) async {
    try {
      var query = _client.from('Businesses').select();

      if (location != null) {
        query = query.ilike('location', '%$location%');
      }

      // Filter for veterinary businesses
      query = query.ilike('business_name', '%vet%');

      final response = await query.order('business_name');
      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get available vets: $error');
      rethrow;
    }
  }

  // Get nearby clinics from Businesses table
  Future<List<Map<String, dynamic>>> getNearbyClinics({
    String location = 'Delhi',
  }) async {
    try {
      final response = await _client
          .from('Businesses')
          .select()
          .ilike('location', '%$location%')
          .or('business_name.ilike.%clinic%,business_name.ilike.%hospital%,business_name.ilike.%vet%')
          .order('business_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get nearby clinics: $error');
      rethrow;
    }
  }

  // Get appointment statistics
  Future<Map<String, int>> getAppointmentStats() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get counts for different statuses
      final pendingData = await _client
          .from('appointments')
          .select('id, pets!inner(owner_id)')
          .eq('pets.owner_id', userId)
          .eq('status', 'pending')
          .count();

      final confirmedData = await _client
          .from('appointments')
          .select('id, pets!inner(owner_id)')
          .eq('pets.owner_id', userId)
          .eq('status', 'confirmed')
          .count();

      final completedData = await _client
          .from('appointments')
          .select('id, pets!inner(owner_id)')
          .eq('pets.owner_id', userId)
          .eq('status', 'completed')
          .count();

      return {
        'pending': pendingData.count ?? 0,
        'confirmed': confirmedData.count ?? 0,
        'completed': completedData.count ?? 0,
      };
    } catch (error) {
      debugPrint('❌ Failed to get appointment statistics: $error');
      return {'pending': 0, 'confirmed': 0, 'completed': 0};
    }
  }
}
