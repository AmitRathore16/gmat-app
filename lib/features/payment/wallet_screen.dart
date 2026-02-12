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
        elevation: 0,
        backgroundColor: GlobalVariables.surfaceColor,
        centerTitle: false,
        iconTheme: const IconThemeData(color: GlobalVariables.primaryTextColor),
        title: Text(
          'My Wallet',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: GlobalVariables.primaryTextColor,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: GlobalVariables.primaryColor.withOpacity(0.92),
                borderRadius:
                BorderRadius.circular(GlobalVariables.defaultRadius),
                boxShadow: GlobalVariables.softCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Balance',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.88),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.currentCredits} Credits',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 13,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Credits are used for jobs & visibility',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Top Up Credits',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a pack to continue teaching or posting jobs.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: GlobalVariables.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _creditPacks.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GlobalVariables.primarySoft
                          : GlobalVariables.surfaceColor,
                      borderRadius: BorderRadius.circular(
                          GlobalVariables.defaultRadius),
                      border: Border.all(
                        color: isSelected
                            ? GlobalVariables.primaryColor
                            : Colors.grey.shade200,
                        width: isSelected ? 1.6 : 1.2,
                      ),
                      boxShadow: isSelected
                          ? GlobalVariables.subtleShadow
                          : const [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: GlobalVariables.primaryColor
                                    .withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.bolt_rounded,
                                size: 18,
                                color: GlobalVariables.primaryColor,
                              ),
                            ),
                            if (index == 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: GlobalVariables.successColor
                                      .withOpacity(0.08),
                                  borderRadius:
                                  BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Popular',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: GlobalVariables.successColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${pack['credits']} Credits',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: GlobalVariables.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${(pack['amount'] / 100).toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: GlobalVariables.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: 16,
                              color: isSelected
                                  ? GlobalVariables.primaryColor
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isSelected
                                  ? 'Selected'
                                  : 'Tap to select',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isSelected
                                    ? GlobalVariables.primaryColor
                                    : Colors.grey.shade500,
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

            const SizedBox(height: 20),

            if (selectedPack.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: GlobalVariables.surfaceColor,
                  borderRadius: BorderRadius.circular(
                      GlobalVariables.smallRadius),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: GlobalVariables.primaryColor
                            .withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_open_rounded,
                        color: GlobalVariables.primaryColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You will be redirected to a secure payment page to complete this purchase.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: GlobalVariables.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 4),

            CustomButton(
              text: 'Proceed to Payment',
              onTap:
              _selectedPackId != null ? _proceedToPayment : () {},
              isOutlined: _selectedPackId == null,
            ),
          ],
        ),
      ),
    );
  }
}