import 'dart:convert';
import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // Get credit packs from backend
  Future<List<Map<String, dynamic>>> getCreditPacks(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/api/payment/credit-packs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load credit packs');
      }
    } catch (e) {
      throw Exception('Error fetching credit packs: $e');
    }
  }

  // Create Razorpay order
  Future<Map<String, dynamic>> createOrder(
      BuildContext context, {
        required String userId,
        required String packId,
        required String userRole,
      }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/api/payment/create-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'packId': packId,
          'userRole': userRole,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }
}