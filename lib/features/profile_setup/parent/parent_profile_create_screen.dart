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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => currentStep--),
        )
            : null,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStep(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Consumer<ParentProfileProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Loader()
                      : CustomButton(
                    text: currentStep == 1 ? 'Finish Setup' : 'Continue',
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
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: index <= currentStep
                  ? LinearGradient(
                colors: [
                  GlobalVariables.selectedColor,
                  GlobalVariables.selectedColor.withOpacity(0.7),
                ],
              )
                  : null,
              color: index > currentStep
                  ? GlobalVariables.greyBackgroundColor
                  : null,
              borderRadius: BorderRadius.circular(3),
              boxShadow: index <= currentStep
                  ? [
                BoxShadow(
                  color: GlobalVariables.selectedColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepTitle() {
    final titles = [
      'Parent Details',
      'Address Information',
    ];
    return Text(
      titles[currentStep],
      style: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _stepSubtitle() {
    final subtitles = [
      'Tell us about yourself',
      'Where are you located?',
    ];
    return Text(
      subtitles[currentStep],
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.grey.shade600,
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
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: GlobalVariables.selectedColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
              ),
            ),

            CustomTextField(
              controller: nameCtrl,
              hintText: 'Parent Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailCtrl,
              readonly: true,
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneCtrl,
              readonly: true,
              hintText: 'Phone',
              prefixIcon: Icons.phone,
            ),
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
              margin: const EdgeInsets.only(bottom: 24),
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
                Icons.location_on,
                size: 48,
                color: GlobalVariables.selectedColor,
              ),
            ),
          ),

          CustomTextField(
            controller: streetCtrl,
            hintText: 'Street Address',
            prefixIcon: Icons.home,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: cityCtrl,
                  hintText: 'City',
                  prefixIcon: Icons.location_city,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: stateCtrl,
                  hintText: 'State',
                  prefixIcon: Icons.map,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: pincodeCtrl,
            hintText: 'Pincode',
            prefixIcon: Icons.pin_drop,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}