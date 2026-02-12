import 'package:get_me_a_tutor/import_export.dart';

class JobPostingCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobPostingCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              GlobalVariables.selectedColor.withOpacity(0.02),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: GlobalVariables.selectedColor.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Icon + Title + Salary)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GlobalVariables.selectedColor.withOpacity(0.15),
                        GlobalVariables.selectedColor.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: GlobalVariables.selectedColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: 24,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: GlobalVariables.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (job.classRange != null)
                        Text(
                          'Class ${job.classRange}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                if (job.salary != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade50,
                          Colors.green.shade100.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '₹${job.salary}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: GlobalVariables.selectedColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Posted by: ${job.postedByRole}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: GlobalVariables.selectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tags (Subjects + JobType)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...job.subjects.map(
                      (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GlobalVariables.selectedColor.withOpacity(0.12),
                          GlobalVariables.selectedColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: GlobalVariables.selectedColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: GlobalVariables.selectedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: GlobalVariables.greyBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    job.jobType,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: GlobalVariables.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Divider
            Divider(
              color: Colors.grey.withOpacity(0.2),
              height: 1,
              thickness: 1,
            ),

            const SizedBox(height: 14),

            // Footer
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    job.location ?? 'Location not specified',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final teacherProvider =
                    Provider.of<TeacherProvider>(context, listen: false);

                    final teacher = teacherProvider.teacher;
                    final credits = teacher?.credits ?? 0;

                    // Not enough credits
                    if (credits < 5) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Not enough credits'),
                          content: const Text(
                            'Applying to a job costs 5 credits. Please buy credits to continue.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
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

                    // Profile is private
                    if (teacher?.isPublic == false) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Profile is Private'),
                          content: const Text(
                            'Please make your profile public to start applying for jobs.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    // Apply to job
                    final provider =
                    Provider.of<JobApplicationProvider>(context, listen: false);

                    final success = await provider.applyToJob(
                      context: context,
                      jobId: job.id,
                    );

                    if (success) {
                      final auth =
                      Provider.of<AuthProvider>(context, listen: false);
                      // Refresh teacher data (credits -5, jobsApplied +1)
                      await Provider.of<TeacherProvider>(
                        context,
                        listen: false,
                      ).fetchTeacherProfile(context, auth.userId!);

                      showSnackBar(context, 'Applied successfully');
                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: GlobalVariables.selectedColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}