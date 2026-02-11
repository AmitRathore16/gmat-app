import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

class PaymentService {

  // GET CREDIT PACKS (if you have API for it)
  Future<List<Map<String, dynamic>>> getCreditPacks(BuildContext context) async {
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
  }

  // CREATE ORDER
  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required String packId,
    required String userRole,
  }) async {
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
  }

  // VERIFY PAYMENT (IMPORTANT)
  Future<void> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required String userRole,
  }) async {

    final response = await http.post(
      Uri.parse('${GlobalVariables.baseUrl}/api/payment/verify-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
        'userId': userId,
        'userRole': userRole,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Payment verification failed");
    }
  }
}
