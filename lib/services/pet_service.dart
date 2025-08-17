import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class PetService {
  static PetService? _instance;
  static PetService get instance => _instance ??= PetService._();
  PetService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get user's pets
  Future<List<Map<String, dynamic>>> getUserPets() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('pets')
          .select()
          .eq('owner_id', userId)
          .eq('is_active', true)
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get user pets: $error');
      rethrow;
    }
  }

  // Create new pet profile
  Future<Map<String, dynamic>> createPet({
    required String name,
    required String breed,
    required String gender,
    required int ageYears,
    required int ageMonths,
    double? weightKg,
    String? sizeCategory,
    String? photoUrl,
    String? medicalNotes,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final petData = {
        'owner_id': userId,
        'name': name,
        'breed': breed,
        'gender': gender,
        'age_years': ageYears,
        'age_months': ageMonths,
        'weight_kg': weightKg,
        'size_category': sizeCategory,
        'photo_url': photoUrl,
        'medical_notes': medicalNotes,
      };

      final response =
          await _client.from('pets').insert(petData).select().single();

      debugPrint('✅ Pet created successfully: ${response['name']}');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to create pet: $error');
      rethrow;
    }
  }

  // Update pet profile
  Future<Map<String, dynamic>> updatePet({
    required String petId,
    String? name,
    String? breed,
    String? gender,
    int? ageYears,
    int? ageMonths,
    double? weightKg,
    String? sizeCategory,
    String? photoUrl,
    String? medicalNotes,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (breed != null) updates['breed'] = breed;
      if (gender != null) updates['gender'] = gender;
      if (ageYears != null) updates['age_years'] = ageYears;
      if (ageMonths != null) updates['age_months'] = ageMonths;
      if (weightKg != null) updates['weight_kg'] = weightKg;
      if (sizeCategory != null) updates['size_category'] = sizeCategory;
      if (photoUrl != null) updates['photo_url'] = photoUrl;
      if (medicalNotes != null) updates['medical_notes'] = medicalNotes;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('pets')
          .update(updates)
          .eq('id', petId)
          .select()
          .single();

      debugPrint('✅ Pet updated successfully: ${response['name']}');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to update pet: $error');
      rethrow;
    }
  }

  // Delete pet (soft delete)
  Future<bool> deletePet(String petId) async {
    try {
      await _client.from('pets').update({'is_active': false}).eq('id', petId);

      debugPrint('✅ Pet deleted successfully');
      return true;
    } catch (error) {
      debugPrint('❌ Failed to delete pet: $error');
      return false;
    }
  }

  // Get pet's vaccinations
  Future<List<Map<String, dynamic>>> getPetVaccinations(String petId) async {
    try {
      final response = await _client
          .from('vaccinations')
          .select()
          .eq('pet_id', petId)
          .order('vaccination_date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get pet vaccinations: $error');
      rethrow;
    }
  }

  // Add vaccination record
  Future<Map<String, dynamic>> addVaccination({
    required String petId,
    required String vaccineName,
    required DateTime vaccinationDate,
    DateTime? nextDueDate,
    String? veterinarianName,
    String? batchNumber,
    String? notes,
  }) async {
    try {
      final vaccinationData = {
        'pet_id': petId,
        'vaccine_name': vaccineName,
        'vaccination_date':
            vaccinationDate.toIso8601String().split('T')[0], // Date only
        'next_due_date': nextDueDate?.toIso8601String().split('T')[0],
        'veterinarian_name': veterinarianName,
        'batch_number': batchNumber,
        'notes': notes,
      };

      final response = await _client
          .from('vaccinations')
          .insert(vaccinationData)
          .select()
          .single();

      debugPrint('✅ Vaccination added successfully');
      return response;
    } catch (error) {
      debugPrint('❌ Failed to add vaccination: $error');
      rethrow;
    }
  }

  // Get upcoming vaccinations (due in next 30 days)
  Future<List<Map<String, dynamic>>> getUpcomingVaccinations() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));

      final response = await _client
          .from('vaccinations')
          .select('*, pets!inner(*)')
          .eq('pets.owner_id', userId)
          .eq('pets.is_active', true)
          .lte('next_due_date',
              thirtyDaysFromNow.toIso8601String().split('T')[0])
          .order('next_due_date');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      debugPrint('❌ Failed to get upcoming vaccinations: $error');
      rethrow;
    }
  }

  // Upload pet image to Supabase Storage
  Future<String?> uploadPetImage({
    required String petId,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final filePath = '$userId/$petId/$fileName';

      await _client.storage
          .from('pet-profiles')
          .uploadBinary(filePath, Uint8List.fromList(fileBytes));

      final imageUrl =
          _client.storage.from('pet-profiles').getPublicUrl(filePath);

      debugPrint('✅ Pet image uploaded successfully');
      return imageUrl;
    } catch (error) {
      debugPrint('❌ Failed to upload pet image: $error');
      return null;
    }
  }
}