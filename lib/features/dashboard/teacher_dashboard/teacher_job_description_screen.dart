import 'package:get_me_a_tutor/import_export.dart';

class TeacherJobDescriptionScreen extends StatelessWidget {
  static const String routeName = '/teacherJobDescription';

  final JobModel job;

  const TeacherJobDescriptionScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      return '${diff.inDays} days ago';
    }

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,

      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Job Details',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),

      body: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, _) {
          final credits = teacherProvider.teacher?.credits ?? 0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),

                // Job Title
                Text(
                  job.title,
                  style: GoogleFonts.inter(
                    fontSize: 28 * scale,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Posted ${timeAgo(job.createdAt)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GlobalVariables.selectedColor.withOpacity(0.12),
                        GlobalVariables.selectedColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Posted by: ${job.postedByRole}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: GlobalVariables.selectedColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Salary + Mode Cards
                Row(
                  children: [
                    Expanded(
                      child: _infoCard(
                        icon: Icons.currency_rupee,
                        title: 'Salary',
                        value: job.salary != null
                            ? '₹${job.salary}'
                            : 'Not specified',
                        bg: const Color(0xFFEAF3FF),
                        iconColor: const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _infoCard(
                        icon: Icons.work_outline,
                        title: 'Job Type',
                        value: job.jobType,
                        bg: const Color(0xFFF5F5F5),
                        iconColor: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Location + Class Range
                _detailTile(
                  icon: Icons.location_on,
                  title: 'Location',
                  value: job.location ?? 'Not specified',
                ),

                if (job.classRange != null) ...[
                  const SizedBox(height: 16),
                  _detailTile(
                    icon: Icons.school,
                    title: 'Class Range',
                    value: job.classRange!,
                  ),
                ],

                if (job.deadline != null) ...[
                  const SizedBox(height: 16),
                  _detailTile(
                    icon: Icons.event,
                    title: 'Application Deadline',
                    value:
                    '${job.deadline!.day}/${job.deadline!.month}/${job.deadline!.year}',
                  ),
                ],

                const SizedBox(height: 28),

                // Subjects
                Text(
                  'Subjects',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: job.subjects.map((subject) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                      child: Text(
                        subject,
                        style: GoogleFonts.inter(
                          color: GlobalVariables.selectedColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Description
                Text(
                  'Job Description',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GlobalVariables.greyBackgroundColor.withOpacity(0.5),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    job.description?.isNotEmpty == true
                        ? job.description!
                        : 'No description provided.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 140),
              ],
            ),
          );
        },
      ),

      // Bottom Apply Section
      bottomNavigationBar: Consumer<TeacherProvider>(
        builder: (context, teacherProvider, _) {
          final credits = teacherProvider.teacher?.credits ?? 0;

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Credits Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            size: 18,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Balance: $credits Credits',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            GlobalVariables.selectedColor.withOpacity(0.15),
                            GlobalVariables.selectedColor.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GlobalVariables.selectedColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'Cost: 5 Credits',
                        style: GoogleFonts.inter(
                          color: GlobalVariables.selectedColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
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
                      final provider = Provider.of<JobApplicationProvider>(
                          context,
                          listen: false);

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalVariables.selectedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                      shadowColor: GlobalVariables.selectedColor.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Apply using credits',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Reusable Widgets
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color bg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bg.withOpacity(0.5),
            bg.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            GlobalVariables.greyBackgroundColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlobalVariables.selectedColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: GlobalVariables.selectedColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}