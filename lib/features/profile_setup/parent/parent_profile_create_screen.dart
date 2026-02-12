import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/parentProfileCreateScreen';

  const ParentProfileCreateScreen({super.key});

  @override
  State<ParentProfileCreateScreen> createState() =>
      _ParentProfileCreateScreenState();
}

class _ParentProfileCreateScreenState extends State<ParentProfileCreateScreen> {
  int currentStep = 0;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    emailCtrl.text = auth.email ?? '';
    phoneCtrl.text = auth.phone ?? '';
  }

  Future<void> onContinue() async {
    if (currentStep == 0 && !_step1Key.currentState!.validate()) return;
    if (currentStep == 1 && !_step2Key.currentState!.validate()) return;

    if (currentStep < 1) {
      setState(() => currentStep++);
    } else {
      final provider =
      Provider.of<ParentProfileProvider>(context, listen: false);

      final success = await provider.createParentProfile(
        context: context,
        body: {
          'name': nameCtrl.text.trim(),
          'email': emailCtrl.text.trim(),
          'phone': phoneCtrl.text.trim(),
          'city': cityCtrl.text.trim(),
          'address': {
            'street': streetCtrl.text.trim(),
            'city': cityCtrl.text.trim(),
            'state': stateCtrl.text.trim(),
            'pincode': pincodeCtrl.text.trim(),
          },
        },
      );

      if (success) {
        showSnackBar(context, 'Parent profile created');
        context.read<AuthProvider>().setHasParentProfile(true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          ParentDashboard.routeName,
              (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_rounded, color: GlobalVariables.primaryTextColor, size: 20),
          ),
          onPressed: () => setState(() => currentStep--),
        )
            : null,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Header Section with Progress
            Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              decoration: BoxDecoration(
                color: GlobalVariables.surfaceColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: GlobalVariables.softCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'STEP ${currentStep + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: GlobalVariables.primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        ' OF 2',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _progressBar(),
                  const SizedBox(height: 24),
                  _stepTitle(),
                  const SizedBox(height: 8),
                  _stepSubtitle(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildStep(),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Consumer<ParentProfileProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Loader()
                      : CustomButton(
                    text: currentStep == 1 ? '✓  Complete Setup' : 'Continue  →',
                    onTap: onContinue,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    return Row(
      children: List.generate(
        2,
            (index) => Expanded(
          child: Container(
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? GlobalVariables.primaryColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepTitle() {
    final titles = [
      'Personal Information',
      'Location Details',
    ];
    return Text(
      titles[currentStep],
      style: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: GlobalVariables.primaryTextColor,
        height: 1.2,
      ),
    );
  }

  Widget _stepSubtitle() {
    final subtitles = [
      'Let us know who you are',
      'Where are you located?',
    ];
    return Text(
      subtitles[currentStep],
      style: GoogleFonts.inter(
        fontSize: 14,
        color: GlobalVariables.secondaryTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStep() {
    if (currentStep == 0) {
      return Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Profile Icon
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GlobalVariables.primaryColor.withOpacity(0.08),
                ),
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: GlobalVariables.primaryTextColor,
                  ),
                ),
              ),
            ),

            Text(
              'Full Name',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: nameCtrl,
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 20),

            Text(
              'Email Address',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: emailCtrl,
              readonly: true,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),

            Text(
              'Phone Number',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: phoneCtrl,
              readonly: true,
              hintText: 'Phone',
              prefixIcon: Icons.phone_outlined,
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Location Icon
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: GlobalVariables.primarySoft,
                shape: BoxShape.circle,
                border: Border.all(
                  color: GlobalVariables.primaryColor.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 56,
                color: GlobalVariables.primaryColor,
              ),
            ),
          ),

          Text(
            'Street Address',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlobalVariables.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: streetCtrl,
            hintText: 'Enter street address',
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: cityCtrl,
                      hintText: 'City',
                      prefixIcon: Icons.location_city_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'State',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: GlobalVariables.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: stateCtrl,
                      hintText: 'State',
                      prefixIcon: Icons.map_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Pincode',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlobalVariables.primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: pincodeCtrl,
            hintText: 'Enter pincode',
            prefixIcon: Icons.pin_drop_outlined,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}