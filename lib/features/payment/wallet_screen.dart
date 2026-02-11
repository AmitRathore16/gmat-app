import 'package:flutter/material.dart';
import 'package:get_me_a_tutor/import_export.dart';
import 'package:get_me_a_tutor/features/payment/payment_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = '/wallet';

  final int currentCredits;
  final String userId;
  final String userRole;

  const WalletScreen({
    super.key,
    required this.currentCredits,
    required this.userId,
    required this.userRole,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final PaymentService _paymentService = PaymentService();
  late Razorpay _razorpay;

  List<Map<String, dynamic>> _creditPacks = [];
  String? _selectedPackId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _loadCreditPacks();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadCreditPacks() async {
    try {
      final packs = await _paymentService.getCreditPacks(context);
      setState(() {
        _creditPacks = packs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showSnackBar(context, 'Error loading credit packs');
      }
    }
  }

  Future<void> _proceedToPayment() async {
    if (_selectedPackId == null) {
      showSnackBar(context, 'Please select a credit pack');
      return;
    }

    try {
      final order = await _paymentService.createOrder(
        userId: widget.userId,
        packId: _selectedPackId!,
        userRole: widget.userRole,
      );

      var options = {
        'key': GlobalVariables.razorpayKeyId,
        'amount': order['amount'],
        'order_id': order['id'],
        'name': 'Get Me A Tutor',
        'description': 'Credit Purchase',
        'theme': {'color': '#639BF7'}
      };

      _razorpay.open(options);

    } catch (e) {
      showSnackBar(context, 'Error creating order');
    }
  }

  // 🔥 IMPORTANT PART
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      await _paymentService.verifyPayment(
        orderId: response.orderId!,
        paymentId: response.paymentId!,
        signature: response.signature!,
        userId: widget.userId,
        userRole: widget.userRole,
      );

      showSnackBar(context, 'Credits added successfully!');
      Navigator.pop(context, true);

    } catch (e) {
      showSnackBar(context, 'Payment verification failed');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showSnackBar(context, 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showSnackBar(context, 'External wallet selected');
  }

  @override
  Widget build(BuildContext context) {
    final selectedPack = _creditPacks.firstWhere(
          (p) => p['id'] == _selectedPackId,
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Wallet', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // CREDITS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalVariables.selectedColor,
                    GlobalVariables.selectedColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AVAILABLE CREDITS',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.currentCredits}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Top Up Credits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _creditPacks.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final pack = _creditPacks[index];
                final isSelected = _selectedPackId == pack['id'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPackId = pack['id'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? GlobalVariables.selectedColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pack['credits']} Credits',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${(pack['amount'] / 100).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                            GlobalVariables.selectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedPackId != null
                    ? _proceedToPayment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  GlobalVariables.selectedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
