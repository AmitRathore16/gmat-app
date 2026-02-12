import 'package:get_me_a_tutor/import_export.dart';

class JobPostScreen extends StatefulWidget {
  static const String routeName = '/jobPost';
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;

  // controllers
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final classRangeCtrl = TextEditingController();
  final salaryCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final subjectInputCtrl = TextEditingController();

  // state
  DateTime? deadline;
  String jobType = 'full-time';
  List<String> subjects = [];

  final jobTypes = ['full-time', 'part-time', 'contract'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    classRangeCtrl.dispose();
    salaryCtrl.dispose();
    locationCtrl.dispose();
    subjectInputCtrl.dispose();
    super.dispose();
  }

  Future<void> pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => deadline = picked);
    }
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (deadline == null) {
      showSnackBar(context, 'Please select a deadline');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    int credits = 0;

    if (auth.role == 'institute') {
      credits = Provider.of<InstituteProvider>(
        context,
        listen: false,
      ).institution?.credits ?? 0;
    }

    if (auth.role == 'parent') {
      credits = Provider.of<ParentProfileProvider>(
        context,
        listen: false,
      ).parent?.credits ?? 0;
    }

    if (credits < 5) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Not enough credits'),
          content: const Text(
            'Each job posting costs 5 credits. Please buy credits to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Buy credits flow
              },
              child: const Text('Buy Credits'),
            ),
          ],
        ),
      );
      return;
    }

    final jobProvider = Provider.of<JobProvider>(
      context,
      listen: false,
    );

    final body = {
      'title': titleCtrl.text.trim(),
      'description': descCtrl.text.trim(),
      'subjects': subjects,
      'classRange': classRangeCtrl.text.trim(),
      'salary': int.tryParse(salaryCtrl.text) ?? 0,
      'location': locationCtrl.text.trim(),
      'jobType': jobType,
      'deadline': deadline!.toIso8601String(),
      'status': 'active',
    };

    final success = await jobProvider.createJob(
      context: context,
      body: body,
    );
    if (success) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.role == 'institute') {
        await Provider.of<InstituteProvider>(
          context,
          listen: false,
        ).fetchMyInstitute(context);
      }

      if (auth.role == 'parent') {
        await Provider.of<ParentProfileProvider>(
          context,
          listen: false,
        ).fetchMyParentProfile(context);
      }

      showSnackBar(context, 'Job posted successfully');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Post a Job',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _animController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Job Title'),
                        CustomTextField(
                          controller: titleCtrl,
                          hintText: 'e.g. Mathematics Teacher',
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Job Description'),
                        CustomTextField(
                          controller: descCtrl,
                          hintText: 'Describe the role and responsibilities...',
                          maxLines: 5,
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Subjects'),
                        _chipInput(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionLabel('Class Range'),
                                  CustomTextField(
                                    controller: classRangeCtrl,
                                    hintText: 'e.g. 6-10',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionLabel('Salary (₹)'),
                                  CustomTextField(
                                    controller: salaryCtrl,
                                    hintText: 'e.g. 25000',
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Location'),
                        CustomTextField(
                          controller: locationCtrl,
                          hintText: 'e.g. New Delhi',
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Job Type'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _jobTypeChip('full-time', 'Full Time'),
                            const SizedBox(width: 10),
                            _jobTypeChip('part-time', 'Part Time'),
                            const SizedBox(width: 10),
                            _jobTypeChip('contract', 'Contract'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _sectionLabel('Application Deadline'),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: pickDeadline,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF3B82F6).withOpacity(0.15),
                                            const Color(0xFF3B82F6).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_today_rounded,
                                        color: Color(0xFF3B82F6),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      deadline == null
                                          ? 'Select deadline'
                                          : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                                      style: GoogleFonts.inter(
                                        color: deadline == null
                                            ? const Color(0xFF64748B)
                                            : const Color(0xFF0F172A),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: submit,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3B82F6),
                          Color(0xFF2563EB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Post Job',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _chipInput() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...subjects.map(
              (s) => Chip(
            label: Text(
              s,
              style: const TextStyle(color: Color(0xFF0F172A)),
            ),
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
            deleteIcon: const Icon(
              Icons.close,
              color: Color(0xFF3B82F6),
              size: 18,
            ),
            onDeleted: () => setState(() => subjects.remove(s)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
              ),
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
                  'Add Subject',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: subjectInputCtrl,
                      autofocus: true,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Mathematics',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
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
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (subjectInputCtrl.text.isNotEmpty) {
                        setState(() =>
                            subjects.add(subjectInputCtrl.text.trim()));
                        subjectInputCtrl.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w700,
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
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF3B82F6).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  size: 16,
                  color: Color(0xFF3B82F6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Add Subject',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF3B82F6),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _jobTypeChip(String value, String label) {
    final bool selected = jobType == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => jobType = value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected
                ? const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF2563EB),
              ],
            )
                : null,
            color: selected ? null : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFE5E7EB),
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: selected ? Colors.white : const Color(0xFF475569),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}