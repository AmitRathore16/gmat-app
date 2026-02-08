import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/teacherProfileUpdate';
  const TeacherProfileUpdateScreen({super.key});

  @override
  State<TeacherProfileUpdateScreen> createState() =>
      _TeacherProfileUpdateScreenState();
}

class _TeacherProfileUpdateScreenState
    extends State<TeacherProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final bioCtrl = TextEditingController();
  final availabilityCtrl = TextEditingController();
  final salaryMinCtrl = TextEditingController();
  final salaryMaxCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final subjectInputCtrl = TextEditingController();
  final classInputCtrl = TextEditingController();
  final languageInputCtrl = TextEditingController();

  double experienceYears = 0;
  bool isPublic = true;

  File? newDemoVideo;
  File? newPhoto;
  File? newResume;

  bool removePhoto = false;
  bool removeResume = false;
  bool removeDemoVideo = false;

  List<String> subjects = [];
  List<int> classes = [];
  List<String> languages = [];
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    final teacher =
    Provider.of<TeacherProvider>(context, listen: false).teacher!;

    bioCtrl.text = teacher.bio ?? '';
    availabilityCtrl.text = teacher.availability ?? '';
    cityCtrl.text = teacher.city ?? '';
    experienceYears = teacher.experienceYears.toDouble();
    isPublic = teacher.isPublic;

    subjects = List.from(teacher.subjects);
    classes = List.from(teacher.classes);
    languages = List.from(teacher.languages);
    tags = List.from(teacher.tags);

    salaryMinCtrl.text = teacher.expectedSalary?.min?.toString() ?? '';
    salaryMaxCtrl.text = teacher.expectedSalary?.max?.toString() ?? '';
  }

  @override
  void dispose() {
    bioCtrl.dispose();
    availabilityCtrl.dispose();
    salaryMinCtrl.dispose();
    salaryMaxCtrl.dispose();
    subjectInputCtrl.dispose();
    classInputCtrl.dispose();
    languageInputCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<TeacherProfileProvider>(context, listen: false);

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
      tags: tags,
      resume: removeResume ? null : newResume,
      photo: removePhoto ? null : newPhoto,
      demoVideo: removeDemoVideo ? null : newDemoVideo,
      removePhoto: removePhoto,
      removeResume: removeResume,
      removeDemoVideo: removeDemoVideo,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teacher =
    Provider.of<TeacherProvider>(context, listen: false).teacher!;

    ImageProvider? profileImage() {
      if (newPhoto != null) return FileImage(newPhoto!);
      if (removePhoto) return null;
      if (teacher.photo?.url != null && teacher.photo!.url!.isNotEmpty) {
        return NetworkImage(teacher.photo!.url!);
      }
      return null;
    }

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<TeacherProfileProvider>(
        builder: (context, provider, _) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Photo Section
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final files =
                                        await pickImages(type: FileType.image);
                                        if (files.isNotEmpty) {
                                          setState(() {
                                            newPhoto = files.first;
                                            removePhoto = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: GlobalVariables.selectedColor
                                                  .withOpacity(0.2),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: GlobalVariables
                                              .selectedColor
                                              .withOpacity(0.15),
                                          backgroundImage: profileImage(),
                                          child: profileImage() == null
                                              ? const Icon(Icons.person, size: 40)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    if (profileImage() != null)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              newPhoto = null;
                                              removePhoto = true;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: GlobalVariables.selectedColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: GlobalVariables.selectedColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tap to change photo',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          _sectionTitle('Basic Information'),
                          const SizedBox(height: 12),
                          _label('City'),
                          CustomTextField(
                            controller: cityCtrl,
                            hintText: 'City',
                            prefixIcon: Icons.location_city,
                          ),

                          _gap(),
                          _label('Bio'),
                          CustomTextField(
                            controller: bioCtrl,
                            hintText: 'Short bio',
                            maxLines: 4,
                          ),

                          _gap(),
                          _sectionTitle('Professional Details'),
                          const SizedBox(height: 12),
                          _label('Subjects'),
                          _chipInput(
                            items: subjects,
                            controller: subjectInputCtrl,
                            hint: 'Add subject',
                            onAdd: (v) => setState(() => subjects.add(v)),
                            onRemove: (v) => setState(() => subjects.remove(v)),
                          ),

                          _gap(),
                          _label('Classes'),
                          _chipInput(
                            items: classes.map((e) => e.toString()).toList(),
                            controller: classInputCtrl,
                            hint: 'Add class',
                            onAdd: (v) {
                              final val = int.tryParse(v);
                              if (val != null) {
                                setState(() => classes.add(val));
                              }
                            },
                            onRemove: (v) {
                              final val = int.tryParse(v);
                              if (val != null) {
                                setState(() => classes.remove(val));
                              }
                            },
                          ),

                          _gap(),
                          _label('Languages'),
                          _chipInput(
                            items: languages,
                            controller: languageInputCtrl,
                            hint: 'Add language',
                            onAdd: (v) => setState(() => languages.add(v)),
                            onRemove: (v) => setState(() => languages.remove(v)),
                          ),

                          _gap(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _label('Experience'),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      GlobalVariables.selectedColor
                                          .withOpacity(0.15),
                                      GlobalVariables.selectedColor
                                          .withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${experienceYears.toInt()} Years',
                                  style: GoogleFonts.inter(
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
                            onChanged: (v) =>
                                setState(() => experienceYears = v),
                          ),

                          _gap(),
                          _sectionTitle('Availability & Salary'),
                          const SizedBox(height: 12),
                          _label('Availability'),
                          CustomTextField(
                            controller: availabilityCtrl,
                            hintText: 'Availability',
                            prefixIcon: Icons.calendar_today,
                          ),

                          _gap(),
                          _label('Expected Salary Range'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: salaryMinCtrl,
                                  hintText: 'Min',
                                  prefixIcon: Icons.currency_rupee,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  controller: salaryMaxCtrl,
                                  hintText: 'Max',
                                  prefixIcon: Icons.currency_rupee,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

                          _gap(),
                          _sectionTitle('Documents & Media'),
                          const SizedBox(height: 12),
                          _label('Demo Video'),
                          _filePickerBox(
                            icon: Icons.play_circle_fill,
                            label: (teacher.demoVideoUrl != null || newDemoVideo != null) && !removeDemoVideo
                                ? 'Demo video uploaded'
                                : 'Upload demo video',
                            uploaded: (teacher.demoVideoUrl != null || newDemoVideo != null) && !removeDemoVideo,
                            onTap: () async {
                              final files = await pickImages(
                                type: FileType.custom,
                                allowedExtensions: ['mp4', 'mkv', 'webm', 'mov'],
                              );
                              if (files.isNotEmpty) {
                                setState(() {
                                  newDemoVideo = files.first;
                                  removeDemoVideo = false;
                                });
                              }
                            },
                            onRemove: (teacher.demoVideoUrl != null ||
                                newDemoVideo != null)
                                ? () {
                              setState(() {
                                newDemoVideo = null;
                                removeDemoVideo = true;
                              });
                            }
                                : null,
                          ),

                          _gap(),
                          _label('Resume (PDF)'),
                          _filePickerBox(
                            icon: Icons.picture_as_pdf,
                            label: (teacher.resume?.url != null || newResume != null) && !removeResume
                                ? 'Resume uploaded'
                                : 'Upload resume',
                            uploaded: (teacher.resume?.url != null || newResume != null) && !removeResume,
                            onTap: () async {
                              final files = await pickImages(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );
                              if (files.isNotEmpty) {
                                setState(() {
                                  newResume = files.first;
                                  removeResume = false;
                                });
                              }
                            },
                            onRemove:
                            (teacher.resume?.url != null || newResume != null)
                                ? () {
                              setState(() {
                                newResume = null;
                                removeResume = true;
                              });
                            }
                                : null,
                          ),

                          const SizedBox(height: 32),

                          // Public Profile Toggle
                          Container(
                            padding: const EdgeInsets.all(18),
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
                                      Text(
                                        'Make profile public',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Allow institutions to find your profile',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
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

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
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
                          text: 'Save Changes',
                          onTap: submit,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    ),
  );

  Widget _gap() => const SizedBox(height: 20);

  Widget _filePickerBox({
    required IconData icon,
    required String label,
    required bool uploaded,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: uploaded
              ? LinearGradient(
            colors: [
              GlobalVariables.selectedColor.withOpacity(0.08),
              GlobalVariables.selectedColor.withOpacity(0.02),
            ],
          )
              : null,
          color: uploaded ? null : GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded
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
                color: uploaded
                    ? GlobalVariables.selectedColor.withOpacity(0.15)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                uploaded ? Icons.check_circle : icon,
                color: uploaded
                    ? GlobalVariables.selectedColor
                    : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: uploaded
                      ? GlobalVariables.selectedColor
                      : Colors.grey.shade700,
                  fontWeight: uploaded ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: onRemove,
              )
            else
              Icon(
                Icons.upload_file,
                color: Colors.grey.shade500,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _chipInput({
    required List<String> items,
    required TextEditingController controller,
    required String hint,
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
              gradient: LinearGradient(
                colors: [
                  GlobalVariables.selectedColor.withOpacity(0.15),
                  GlobalVariables.selectedColor.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: GlobalVariables.selectedColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e,
                  style: GoogleFonts.inter(
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
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(hint),
                content: TextField(controller: controller),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        onAdd(controller.text.trim());
                        controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
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
                  style: GoogleFonts.inter(
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
}