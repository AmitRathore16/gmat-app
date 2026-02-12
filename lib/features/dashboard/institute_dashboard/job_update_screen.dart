import 'package:get_me_a_tutor/import_export.dart';

class JobUpdateScreen extends StatefulWidget {
  static const String routeName = '/jobUpdate';
  final JobModel job;

  const JobUpdateScreen({super.key, required this.job});

  @override
  State<JobUpdateScreen> createState() => _JobUpdateScreenState();
}

class _JobUpdateScreenState extends State<JobUpdateScreen> {
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

  @override
  void initState() {
    super.initState();

    final job = widget.job;

    titleCtrl.text = job.title;
    descCtrl.text = job.description ?? '';
    classRangeCtrl.text = job.classRange ?? '';
    salaryCtrl.text = job.salary?.toString() ?? '';
    locationCtrl.text = job.location ?? '';

    subjects = List.from(job.subjects);
    jobType = job.jobType;
    deadline = job.deadline;
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

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    if (deadline == null) {
      showSnackBar(context, 'Please select a deadline');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Update Job'),
        content: const Text(
          'Are you sure you want to update this job?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final jobProvider =
              Provider.of<JobProvider>(context, listen: false);

              final body = {
                'title': titleCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'subjects': subjects,
                'classRange': classRangeCtrl.text.trim(),
                'salary': int.tryParse(salaryCtrl.text) ?? 0,
                'location': locationCtrl.text.trim(),
                'jobType': jobType,
                'deadline': deadline!.toIso8601String(),
              };

              final success = await jobProvider.updateJob(
                context: context,
                jobId: widget.job.id,
                body: body,
              );

              if (success) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const PrimaryText(text: 'Update Job', size: 22),
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
                                    Icons.calendar_today_rounded,
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
                  text: 'Update Job',
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
          color: GlobalVariables.primaryTextColor,
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
              style: const TextStyle(color: GlobalVariables.primaryTextColor),
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
                title: const Text('Add Subject'),
                content: TextField(
                  controller: subjectInputCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter subject name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
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
                    child: const Text('Add'),
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