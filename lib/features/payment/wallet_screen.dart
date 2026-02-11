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
        showSnackBar(context, 'Error loading credit packs: $e');
      }
    }
  }

  Future<void> _proceedToPayment() async {
    if (_selectedPackId == null) {
      showSnackBar(context, 'Please select a credit pack');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final order = await _paymentService.createOrder(
        context,
        userId: widget.userId,
        packId: _selectedPackId!,
        userRole: widget.userRole,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      var options = {
        'key': 'rzp_test_RoFhlvQ5GI48tx', // Replace with your Razorpay key
        'amount': order['amount'],
        'name': 'Get Me A Tutor',
        'description': 'Credit Purchase',
        'order_id': order['id'],
        'prefill': {
          'contact': '',
          'email': ''
        },
        'theme': {
          'color': '#639BF7'
        }
      };

      _razorpay.open(options);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showSnackBar(context, 'Error creating order: $e');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showSnackBar(context, 'Payment successful! Credits will be added shortly.');
    Navigator.pop(context, true); // Return to dashboard with success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showSnackBar(context, 'Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showSnackBar(context, 'External wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;
    final selectedPack = _creditPacks.firstWhere(
          (p) => p['id'] == _selectedPackId,
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Wallet',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Credits Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24 * scale),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalVariables.selectedColor,
                    GlobalVariables.selectedColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: GlobalVariables.selectedColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AVAILABLE CREDITS',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.currentCredits}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 48 * scale,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'credits available',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Top Up Credits Section
            Text(
              'Top Up Credits',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Credit Packs Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _creditPacks.length,
              itemBuilder: (context, index) {
                final pack = _creditPacks[index];
                final isSelected = _selectedPackId == pack['id'];
                final isPopular = index == 1;
                final isBestValue = index == 2;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPackId = pack['id'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? GlobalVariables.selectedColor
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? GlobalVariables.selectedColor.withOpacity(0.2)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              _getIconForPack(index),
                              color: GlobalVariables.selectedColor,
                              size: 28,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? GlobalVariables.selectedColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? GlobalVariables.selectedColor
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                                  : null,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${pack['credits']}',
                              style: GoogleFonts.inter(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                            Text(
                              'Credits',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '₹${(pack['amount'] / 100).toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                            if (isPopular || isBestValue)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isPopular
                                      ? Colors.orange.shade100
                                      : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isPopular ? 'POPULAR' : 'BEST VALUE',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: isPopular
                                        ? Colors.orange.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: GlobalVariables.selectedColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Credits are used to unlock premium features and contact details. Credits do not expire as long as your account is active.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Summary
            if (_selectedPackId != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total to pay',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹${(selectedPack['amount'] / 100).toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: GlobalVariables.selectedColor,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedPackId != null ? _proceedToPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalVariables.selectedColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: _selectedPackId != null ? 5 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Proceed to Payment',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Security Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  'Secure encrypted payment',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPack(int index) {
    switch (index) {
      case 0:
        return Icons.flash_on;
      case 1:
        return Icons.local_fire_department;
      case 2:
        return Icons.diamond;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }
}