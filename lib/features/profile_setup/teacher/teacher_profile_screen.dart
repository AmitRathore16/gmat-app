import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileCreateScreen extends StatefulWidget {
  static const String routeName = '/teacherProfile';
  const TeacherProfileCreateScreen({super.key});

  @override
  State<TeacherProfileCreateScreen> createState() => _TeacherProfileCreateScreenState();
}

class _TeacherProfileCreateScreenState extends State<TeacherProfileCreateScreen> {
  int currentStep = 0;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // controllers
  final bioCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final qualificationCtrl = TextEditingController();
  final availabilityCtrl = TextEditingController();

  final subjectInputCtrl = TextEditingController();
  final classInputCtrl = TextEditingController();
  final languageInputCtrl = TextEditingController();

  final salaryMinCtrl = TextEditingController();
  final salaryMaxCtrl = TextEditingController();

  // state
  double experienceYears = 0;
  bool isPublic = true;

  List<String> subjects = [];
  List<int> classes = [];
  List<String> languages = [];

  File? resume;
  File? photo;
  File? demoVideo;

  Future<void> onContinue() async {
    final keys = [_step1Key, _step2Key, _step3Key];

    if (currentStep < 3) {
      if (!keys[currentStep].currentState!.validate()) return;
      setState(() => currentStep++);
    } else {
      final provider = Provider.of<TeacherProfileProvider>(
        context,
        listen: false,
      );

      final success = await provider.upsertTeacherProfile(
        context: context,
        bio: bioCtrl.text.trim(),
        experienceYears: experienceYears.toInt(),
        subjects: subjects,
        classes: classes,
        languages: languages,
        city: cityCtrl.text.trim(),
        expectedSalary: {
          'min': int.tryParse(salaryMinCtrl.text) ?? 0,
          'max': int.tryParse(salaryMaxCtrl.text) ?? 0,
        },
        availability: availabilityCtrl.text.trim(),
        isPublic: isPublic,
        tags: [],
        resume: resume,
        photo: photo,
        demoVideo: demoVideo,
        removeDemoVideo: false,
        removePhoto: false,
        removeResume: false,
      );

      if (success) {
        showSnackBar(context, "Profile created successfully");
        context.read<AuthProvider>().setHasTeacherProfile(true);

        Navigator.pushNamedAndRemoveUntil(
          context,
          TeacherDashboard.routeName,
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
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
              child: Consumer<TeacherProfileProvider>(
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
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
      'Teacher Profile',
      'Professional Details',
      'Availability & Pricing',
      'Media & Documents',
    ];
    return PrimaryText(text: titles[currentStep], size: 26);
  }

  Widget _stepSubtitle() {
    final subtitles = [
      'Tell us about yourself',
      'Share your expertise and qualifications',
      'Set your teaching preferences',
      'Upload supporting documents',
    ];
    return SecondaryText(text: subtitles[currentStep], size: 14);
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _stepBasic();
      case 1:
        return _stepProfessional();
      case 2:
        return _stepAvailability();
      case 3:
        return _stepMedia();
      default:
        return const SizedBox();
    }
  }

  // STEP 1 - Basic Info
  Widget _stepBasic() {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            controller: bioCtrl,
            hintText: 'Short bio',
            prefixIcon: Icons.person_outline_rounded,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cityCtrl,
            hintText: 'City',
            prefixIcon: Icons.location_city_rounded,
          ),
        ],
      ),
    );
  }

  // STEP 2 - Professional
  Widget _stepProfessional() {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            controller: qualificationCtrl,
            hintText: 'Highest Qualification',
            prefixIcon: Icons.school_rounded,
          ),
          const SizedBox(height: 24),
          const PrimaryText(text: 'Subjects You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: subjects,
            controller: subjectInputCtrl,
            hint: 'Add subject',
            title: 'Add Subject',
            placeholder: 'e.g. Mathematics',
            onAdd: (val) => setState(() => subjects.add(val)),
            onRemove: (val) => setState(() => subjects.remove(val)),
          ),
          const SizedBox(height: 24),
          const PrimaryText(text: 'Languages You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: languages,
            controller: languageInputCtrl,
            hint: 'Add language',
            title: 'Add Language',
            placeholder: 'e.g. English',
            onAdd: (val) => setState(() => languages.add(val)),
            onRemove: (val) => setState(() => languages.remove(val)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PrimaryText(text: 'Years of Experience', size: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: GlobalVariables.selectedColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${experienceYears.toInt()} Years',
                  style: TextStyle(
                    color: GlobalVariables.selectedColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: experienceYears,
            min: 0,
            max: 40,
            divisions: 40,
            activeColor: GlobalVariables.selectedColor,
            onChanged: (v) => setState(() => experienceYears = v),
          ),
          const SizedBox(height: 24),
          const PrimaryText(text: 'Teaching Mode', size: 16),
          const SizedBox(height: 8),
          _lockedBox('Online only'),
        ],
      ),
    );
  }

  // STEP 3 - Availability
  Widget _stepAvailability() {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const PrimaryText(text: 'Classes You Teach', size: 16),
          const SizedBox(height: 12),
          _chipInput(
            items: classes.map((e) => e.toString()).toList(),
            controller: classInputCtrl,
            hint: 'Add class',
            title: 'Add Class',
            placeholder: 'e.g. 10',
            onAdd: (val) => setState(() => classes.add(int.tryParse(val) ?? 0)),
            onRemove: (val) =>
                setState(() => classes.remove(int.tryParse(val))),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: availabilityCtrl,
            hintText: 'Availability (e.g. Weekends)',
            prefixIcon: Icons.calendar_today_rounded,
          ),
          const SizedBox(height: 16),
          const PrimaryText(text: 'Expected Salary Range', size: 16),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: salaryMinCtrl,
                  hintText: 'Min Salary',
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  controller: salaryMaxCtrl,
                  hintText: 'Max Salary',
                  prefixIcon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  GlobalVariables.selectedColor.withOpacity(0.08),
                  GlobalVariables.selectedColor.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: GlobalVariables.selectedColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PrimaryText(text: 'Make profile public', size: 16),
                      const SizedBox(height: 4),
                      SecondaryText(
                        text: 'Allow institutions to find your profile',
                        size: 13,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isPublic,
                  onChanged: (v) => setState(() => isPublic = v),
                  activeColor: GlobalVariables.selectedColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 4 - Media
  Widget _stepMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const PrimaryText(text: 'Profile Photo', size: 16),
        const SizedBox(height: 4),
        Text(
          'Upload your professional photo',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        _filePickerBox(
          file: photo,
          icon: Icons.person,
          label: photo != null ? 'Photo uploaded' : 'Upload profile photo',
          onTap: () async {
            final files = await pickImages(type: FileType.image);
            if (files.isNotEmpty) {
              setState(() => photo = files.first);
            }
          },
        ),
        const SizedBox(height: 24),
        const PrimaryText(text: 'Demo Video', size: 16),
        const SizedBox(height: 4),
        Text(
          'Showcase your teaching style',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        _filePickerBox(
          file: demoVideo,
          icon: Icons.play_circle_rounded,
          label: demoVideo != null ? 'Video uploaded' : 'Upload demo video',
          onTap: () async {
            final files = await pickImages(
              type: FileType.custom,
              allowedExtensions: ['mp4', 'mkv', 'webm', '3gp', 'mov', 'avi', 'flv', 'mpeg', 'mpg', 'wmv', 'm4v'],
            );
            if (files.isNotEmpty) {
              setState(() => demoVideo = files.first);
            }
          },
        ),
        const SizedBox(height: 24),
        const PrimaryText(text: 'Resume', size: 16),
        const SizedBox(height: 4),
        Text(
          'Upload your professional resume (PDF)',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        _filePickerBox(
          file: resume,
          icon: Icons.picture_as_pdf_rounded,
          label: resume != null ? 'Resume uploaded' : 'Upload resume',
          onTap: () async {
            final files = await pickImages(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (files.isNotEmpty) setState(() => resume = files.first);
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Helper Widgets
  Widget _chipInput({
    required List<String> items,
    required TextEditingController controller,
    required String hint,
    required String title,
    required String placeholder,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...items.map(
              (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: GlobalVariables.selectedColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e,
                  style: TextStyle(
                    color: GlobalVariables.selectedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => onRemove(e),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: GlobalVariables.primaryTextColor,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: GlobalVariables.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: placeholder,
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: GlobalVariables.greyBackgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: GlobalVariables.selectedColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        onAdd(controller.text.trim());
                        controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: GoogleFonts.inter(
                        color: GlobalVariables.selectedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: GlobalVariables.selectedColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  size: 16,
                  color: GlobalVariables.selectedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Add',
                  style: TextStyle(
                    color: GlobalVariables.selectedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _lockedBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.laptop_rounded, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: GlobalVariables.primaryTextColor),
            ),
          ),
          const Icon(Icons.lock_rounded, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _filePickerBox({
    required File? file,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: file != null
              ? GlobalVariables.selectedColor.withOpacity(0.08)
              : GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: file != null
                ? GlobalVariables.selectedColor.withOpacity(0.3)
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: file != null
                    ? GlobalVariables.selectedColor.withOpacity(0.15)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                file != null ? Icons.check_circle : icon,
                color: file != null
                    ? GlobalVariables.selectedColor
                    : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: file != null ? GlobalVariables.selectedColor : Colors.grey.shade700,
                  fontWeight: file != null ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.upload_file_rounded,
              color: Colors.grey.shade500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}