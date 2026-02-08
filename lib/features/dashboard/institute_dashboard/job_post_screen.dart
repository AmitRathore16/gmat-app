import 'package:get_me_a_tutor/import_export.dart';

class JobPostScreen extends StatefulWidget {
  static const String routeName = '/jobPost';
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> {
  final _formKey = GlobalKey<FormState>();

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

  Future<void> pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: GlobalVariables.selectedColor,
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
        title: const PrimaryText(text: 'Post a Job', size: 22),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 36,
            color: Colors.black,
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
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: GlobalVariables.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: GlobalVariables.selectedColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: GlobalVariables.selectedColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    deadline == null
                                        ? 'Select deadline'
                                        : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                                    style: TextStyle(
                                      color: deadline == null
                                          ? Colors.grey.shade600
                                          : Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey.shade400,
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
                child: CustomButton(
                  text: 'Post Job',
                  onTap: submit,
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
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
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
              style: const TextStyle(color: Colors.black87),
            ),
            backgroundColor: GlobalVariables.selectedColor.withOpacity(0.12),
            deleteIcon: Icon(
              Icons.close,
              color: GlobalVariables.selectedColor,
              size: 18,
            ),
            onDeleted: () => setState(() => subjects.remove(s)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: GlobalVariables.selectedColor.withOpacity(0.3),
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Mathematics',
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
              color: GlobalVariables.greyBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: GlobalVariables.selectedColor.withOpacity(0.5),
              ),
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
                  'Add Subject',
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

  Widget _jobTypeChip(String value, String label) {
    final bool selected = jobType == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => jobType = value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? GlobalVariables.selectedColor
                : GlobalVariables.greyBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? GlobalVariables.selectedColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
