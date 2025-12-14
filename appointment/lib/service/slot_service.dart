import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/slot_model.dart';
import '../config/env.dart';

class SlotService {
  static Future<List<SlotModel>> getSlotsForDate({
    required String date, // e.g. "2025-12-15"
    required String token,
  }) async {
    final uri = Uri.parse('${Env.apiBaseUrl}/slots?date=$date');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => SlotModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      try {
        final Map<String, dynamic> errorData =
        jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorData['message']?.toString() ??
            'Failed to load slots (${response.statusCode})';
        throw Exception(message);
      } catch (_) {
        throw Exception('Failed to load slots (${response.statusCode})');
      }
    }
  }

  // 👇 NEW: book a slot
  static Future<void> bookSlot({
    required String slotId,
    required String token,
  }) async {
    final uri = Uri.parse('${Env.apiBaseUrl}/book');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'slotId': slotId,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      // success, nothing else to do here
      return;
    } else {
      try {
        final Map<String, dynamic> errorData =
        jsonDecode(response.body) as Map<String, dynamic>;
        final message =
            errorData['message']?.toString() ?? 'Failed to book slot';
        throw Exception(message);
      } catch (_) {
        throw Exception('Failed to book slot (${response.statusCode})');
      }
    }
  }
}
