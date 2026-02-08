import 'package:get_me_a_tutor/import_export.dart';

class OtpVerifyScreen extends StatefulWidget {
  static const String routeName = '/otpVerifyScreen';
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isResendingOtp = false;
  final List<TextEditingController> _emailOtpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  final List<FocusNode> _emailOtpFocusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _emailOtpControllers) {
      controller.dispose();
    }
    for (var focusNode in _emailOtpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onEmailOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _emailOtpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _emailOtpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;

    // OTP box dimensions - slightly larger and more consistent
    final otpBoxSize = 52.0;
    final spacing = 8.0;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16 * scaleFactor),

                    // Back Button
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 36,
                        color: GlobalVariables.primaryTextColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    // Icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              GlobalVariables.selectedColor.withOpacity(0.15),
                              GlobalVariables.selectedColor.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: GlobalVariables.selectedColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mark_email_read,
                          size: 48,
                          color: GlobalVariables.selectedColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 32 * scaleFactor),

                    // Title
                    Center(
                      child: Text(
                        'OTP Verification',
                        style: GoogleFonts.inter(
                          fontSize: 28 * scaleFactor,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: 12 * scaleFactor),

                    // Subtitle
                    Center(
                      child: Text(
                        'Enter the 6-digit code sent to',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14 * scaleFactor,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Center(
                      child: Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.selectedColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 40 * scaleFactor),

                    // OTP Input Fields
                    Center(
                      child: Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: otpBoxSize,
                            height: otpBoxSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _emailOtpControllers[index],
                              focusNode: _emailOtpFocusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              cursorColor: GlobalVariables.selectedColor,
                              maxLength: 1,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: GlobalVariables.primaryTextColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                errorStyle: const TextStyle(
                                  fontSize: 0,
                                  height: 0,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: GlobalVariables.selectedColor,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) =>
                                  _onEmailOtpChanged(index, value),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    // Resend OTP
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.inter(
                        fontSize: 14 * scaleFactor,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    _isResendingOtp
                        ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GlobalVariables.selectedColor,
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isResendingOtp = true;
                        });

                        final authProvider =
                        Provider.of<AuthProvider>(context,
                            listen: false);

                        await authProvider.resendEmailOtp(
                          context: context,
                        );

                        setState(() {
                          _isResendingOtp = false;
                        });
                      },
                      child: Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.selectedColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40 * scaleFactor),

              // Verify Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return authProvider.isLoading
                      ? const Center(child: Loader())
                      : CustomButton(
                    text: 'Verify & Continue',
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (_formKey.currentState!.validate()) {
                        // Combine OTP digits
                        final otp = _emailOtpControllers
                            .map((c) => c.text)
                            .join();

                        if (otp.length != 6) {
                          showSnackBar(
                              context, 'Please enter complete OTP');
                          return;
                        }

                        final authProvider =
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        final role =
                        await authProvider.verifyEmailOtp(
                          otp: otp,
                          context: context,
                        );

                        if (role != null) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignupSuccessScreen.routeName,
                                (route) => false,
                            arguments: role,
                          );
                        }
                      }
                    },
                  );
                },
              ),

              SizedBox(height: 24 * scaleFactor),
              ],
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }
}