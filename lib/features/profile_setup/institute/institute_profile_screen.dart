import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/instituteProfile';
  const InstituteProfileCreateScreen({super.key});

  @override
  State<InstituteProfileCreateScreen> createState() =>
      _InstituteProfileCreateScreenState();
}

class _InstituteProfileCreateScreenState
    extends State<InstituteProfileCreateScreen> {
  int currentStep = 0;
  static const int maxGalleryImages = 10;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // controllers
  final institutionNameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();

  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  String? institutionType;

  File? logo;
  List<File> galleryImages = [];

  final institutionTypes = [
    'School',
    'College',
    'Coaching Institute',
    'Training Center',
    'Online Academy',
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    emailCtrl.text = authProvider.email ?? '';
    phoneCtrl.text = authProvider.phone ?? '';
  }

  Future<void> onContinue() async {
    final keys = [_step1Key, _step2Key, _step3Key];

    if (currentStep < 3) {
      if (currentStep < keys.length &&
          !keys[currentStep].currentState!.validate()) return;
      setState(() => currentStep++);
    } else {
      final provider =
      Provider.of<InstituteProfileProvider>(context, listen: false);

      final success = await provider.createInstituteProfile(
        context: context,
        institutionName: institutionNameCtrl.text.trim(),
        institutionType: institutionType!,
        about: aboutCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        website: websiteCtrl.text.trim(),
        address: {
          'street': streetCtrl.text.trim(),
          'city': cityCtrl.text.trim(),
          'state': stateCtrl.text.trim(),
          'pincode': pincodeCtrl.text.trim(),
        },
        logo: logo,
        galleryImages: galleryImages,
      );

      if (success) {
        showSnackBar(context, 'Institution profile created');
        context.read<AuthProvider>().setHasInstituteProfile(true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          InstituteDashboard.routeName,
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: GlobalVariables.primaryTextColor),
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
              child: Consumer<InstituteProfileProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const Loader()
                      : CustomButton(
                    text: currentStep == 3 ? 'Finish Setup' : 'Continue',
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
        4,
            (index) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? GlobalVariables.selectedColor
                  : GlobalVariables.greyBackgroundColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepTitle() {
    final titles = [
      'Institution Details',
      'Contact Information',
      'Location',
      'Media & Branding',
    ];
    return PrimaryText(text: titles[currentStep], size: 26);
  }

  Widget _stepSubtitle() {
    final subtitles = [
      'Tell us about your institution',
      'How can people reach you?',
      'Where are you located?',
      'Add logo and gallery images',
    ];
    return SecondaryText(text: subtitles[currentStep], size: 14);
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _stepBasicInfo();
      case 1:
        return _stepContact();
      case 2:
        return _stepAddress();
      case 3:
        return _stepMedia();
      default:
        return const SizedBox();
    }
  }

  // STEP 1
  Widget _stepBasicInfo() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            controller: institutionNameCtrl,
            hintText: 'Institution Name',
            prefixIcon: Icons.business_rounded,
          ),
          const SizedBox(height: 16),
          CustomDropdown<String>(
            value: institutionType,
            items: institutionTypes,
            hintText: 'Institution Type',
            prefixIcon: Icons.school_rounded,
            itemLabel: (e) => e,
            onChanged: (val) => setState(() => institutionType = val),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: aboutCtrl,
            hintText: 'About Institution',
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  // STEP 2
  Widget _stepContact() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            readonly: true,
            controller: emailCtrl,
            hintText: 'Email',
            prefixIcon: Icons.email_rounded,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            readonly: true,
            controller: phoneCtrl,
            hintText: 'Phone',
            prefixIcon: Icons.phone_rounded,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: websiteCtrl,
            hintText: 'Website (Optional)',
            prefixIcon: Icons.language_rounded,
          ),
        ],
      ),
    );
  }

  // STEP 3
  Widget _stepAddress() {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            controller: streetCtrl,
            hintText: 'Street Address',
            prefixIcon: Icons.location_on,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(controller: cityCtrl, hintText: 'City'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(controller: stateCtrl, hintText: 'State'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: pincodeCtrl,
            hintText: 'Pincode',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // STEP 4
  Widget _stepMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const PrimaryText(text: 'Institution Logo', size: 16),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () async {
              final files = await pickImages(type: FileType.image);
              if (files.isNotEmpty) {
                setState(() => logo = files.first);
              }
            },
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: GlobalVariables.greyBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: GlobalVariables.selectedColor.withOpacity(0.3),
                  width: 2,
                ),
                image: logo != null
                    ? DecorationImage(
                  image: FileImage(logo!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: logo == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 40,
                    color: GlobalVariables.selectedColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Logo',
                    style: TextStyle(
                      color: GlobalVariables.selectedColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PrimaryText(text: 'Gallery Images', size: 16),
            Text(
              '${galleryImages.length}/$maxGalleryImages',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Add photos to showcase your institution',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...galleryImages.asMap().entries.map((entry) {
              final index = entry.key;
              final img = entry.value;
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      img,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => galleryImages.removeAt(index));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            if (galleryImages.length < maxGalleryImages)
              GestureDetector(
                onTap: () async {
                  final remaining = maxGalleryImages - galleryImages.length;

                  if (remaining <= 0) {
                    _showLimitDialog(context);
                    return;
                  }

                  final images = await pickImages(
                    type: FileType.image,
                    max: remaining,
                  );
                  if (images.isEmpty) return;

                  if (images.length > remaining) {
                    _showLimitDialog(context);
                  }

                  setState(() {
                    galleryImages.addAll(images.take(remaining));
                  });
                },
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: GlobalVariables.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: GlobalVariables.selectedColor.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Limit Reached'),
        content: Text(
          'You can only upload up to $maxGalleryImages images in the gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}