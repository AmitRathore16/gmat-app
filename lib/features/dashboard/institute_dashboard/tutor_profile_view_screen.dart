import 'package:get_me_a_tutor/import_export.dart';

class TutorProfileViewScreen extends StatefulWidget {
  static const routeName = '/tutorProfileView';
  final String userId;
  const TutorProfileViewScreen({super.key, required this.userId});

  @override
  State<TutorProfileViewScreen> createState() => _TutorProfileViewScreenState();
}

class _TutorProfileViewScreenState extends State<TutorProfileViewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherProvider>().fetchTeacherProfile(context, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tutor Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 36),
        ),
      ),
      body: Consumer<TeacherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Loader();

          final t = provider.teacher;
          if (t == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: GlobalVariables.selectedColor.withOpacity(0.08),
                  ),
                  child: Column(
                    children: [
                      // PHOTO
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: GlobalVariables.selectedColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: GlobalVariables.selectedColor.withOpacity(
                                0.3,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.white,
                          backgroundImage: t.photo?.url != null
                              ? NetworkImage(t.photo!.url!)
                              : null,
                          child: t.photo == null
                              ? Icon(
                                  Icons.person,
                                  size: 48,
                                  color: GlobalVariables.selectedColor,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.city ?? 'Location not specified',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BIO
                      if (t.bio != null && t.bio!.isNotEmpty) ...[
                        const PrimaryText(text: 'About', size: 18),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: GlobalVariables.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            t.bio!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // EXPERIENCE & AVAILABILITY
                      Row(
                        children: [
                          Expanded(
                            child: _infoCard(
                              icon: Icons.work_outline,
                              label: 'Experience',
                              value: '${t.experienceYears} years',
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoCard(
                              icon: Icons.schedule,
                              label: 'Availability',
                              value: t.availability ?? 'Not specified',
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // SUBJECTS
                      const PrimaryText(text: 'Subjects', size: 18),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: t.subjects
                            .map(
                              (s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: GlobalVariables.selectedColor
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: GlobalVariables.selectedColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 24),

                      // EXPECTED SALARY
                      if (t.expectedSalary != null) ...[
                        const PrimaryText(text: 'Expected Salary', size: 18),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: GlobalVariables.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                color: GlobalVariables.selectedColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '₹${t.expectedSalary!.min} - ₹${t.expectedSalary!.max}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // RESOURCES
                      const PrimaryText(text: 'Resources', size: 18),
                      const SizedBox(height: 12),

                      if (t.demoVideoUrl != null && t.demoVideoUrl!.isNotEmpty)
                        _resourceTile(
                          icon: Icons.play_circle_fill,
                          title: 'Demo Video',
                          subtitle: 'Watch teaching demonstration',
                          color: Colors.red,
                          onTap: () async {
                            final uri = Uri.parse(t.demoVideoUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              showSnackBar(context, 'Could not open video');
                            }
                          },
                        ),

                      if (t.demoVideoUrl != null && t.demoVideoUrl!.isNotEmpty)
                        const SizedBox(height: 12),

                      if (t.resume?.url != null && t.resume!.url!.isNotEmpty)
                        _resourceTile(
                          icon: Icons.description,
                          title: 'Resume',
                          subtitle: 'View complete resume',
                          color: Colors.blue,
                          onTap: () {
                            launchUrl(Uri.parse(t.resume!.url!));
                          },
                        ),

                      if ((t.resume?.url == null || t.resume!.url!.isEmpty) &&
                          (t.demoVideoUrl == null || t.demoVideoUrl!.isEmpty))
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: GlobalVariables.greyBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'No resources uploaded',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _resourceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
