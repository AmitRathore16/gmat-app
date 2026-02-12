import 'package:get_me_a_tutor/import_export.dart';

class TeacherProfileScreen extends StatelessWidget {
  final String name;
  const TeacherProfileScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        final teacher = provider.teacher;

        if (provider.isLoading) {
          return const Center(child: Loader());
        }

        if (teacher == null) {
          return const Center(
            child: SecondaryText(text: 'No profile data found', size: 20),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header with Profile Photo
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: GlobalVariables.selectedColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
                        backgroundImage: (teacher.photo?.url != null &&
                            teacher.photo!.url!.isNotEmpty)
                            ? NetworkImage(teacher.photo!.url!)
                            : null,
                        child: (teacher.photo?.url == null || teacher.photo!.url!.isEmpty)
                            ? Icon(
                          Icons.person,
                          size: 42,
                          color: GlobalVariables.selectedColor,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: GlobalVariables.primaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            GlobalVariables.selectedColor.withOpacity(0.15),
                            GlobalVariables.selectedColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        teacher.city ?? 'No city provided',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: GlobalVariables.selectedColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Bio Card
              _infoCard(
                title: 'Bio',
                value: teacher.bio ?? 'No bio provided',
                icon: Icons.info_outline,
              ),

              // Experience Card
              _infoCard(
                title: 'Experience',
                value: '${teacher.experienceYears} years',
                icon: Icons.badge,
              ),

              // Availability Card
              if (teacher.availability != null)
                _infoCard(
                  title: 'Availability',
                  value: teacher.availability!,
                  icon: Icons.schedule,
                ),

              // Expected Salary Card
              if (teacher.expectedSalary != null)
                _infoCard(
                  title: 'Expected Salary',
                  value: '₹${teacher.expectedSalary!.min} - ₹${teacher.expectedSalary!.max}',
                  icon: Icons.currency_rupee_rounded,
                ),

              const SizedBox(height: 20),

              // Subjects Section
              _chipSection(
                title: 'Subjects',
                values: teacher.subjects,
              ),

              // Classes Section
              _chipSection(
                title: 'Classes',
                values: teacher.classes.map((e) => e.toString()).toList(),
              ),

              // Languages Section
              _chipSection(
                title: 'Languages',
                values: teacher.languages,
              ),

              // Tags Section
              if (teacher.tags.isNotEmpty)
                _chipSection(
                  title: 'Tags',
                  values: teacher.tags,
                ),

              const SizedBox(height: 28),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Credits',
                      value: teacher.credits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Jobs Applied',
                      value: teacher.jobsApplied.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Exams Passed',
                      value: teacher.examsPassed.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Rating',
                      value: teacher.rating.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Documents Section
              if (teacher.resume?.url != null && teacher.resume!.url!.isNotEmpty)
                _actionTile(
                  text: 'View Resume',
                  icon: Icons.picture_as_pdf_rounded,
                  onTap: () {
                    final url = teacher.resume!.url!;
                    launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                )
              else
                _infoCard(
                  title: 'Resume',
                  value: 'Not uploaded',
                  icon: Icons.picture_as_pdf_rounded,
                ),

              if (teacher.demoVideoUrl != null && teacher.demoVideoUrl!.isNotEmpty)
                _actionTile(
                  text: 'Watch Demo Video',
                  icon: Icons.play_circle_rounded,
                  onTap: () async {
                    final uri = Uri.parse(teacher.demoVideoUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      showSnackBar(context, 'Could not open video');
                    }
                  },
                )
              else
                _infoCard(
                  title: 'Demo Video',
                  value: 'Not uploaded',
                  icon: Icons.play_circle_rounded,
                ),

              const SizedBox(height: 24),

              // Edit Profile Button
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherProfileUpdateScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Action Tiles
              _actionTile(
                text: 'Reset Password',
                icon: Icons.lock_reset,
                onTap: () => _showResetPasswordDialog(context),
              ),

              _actionTile(
                text: 'Logout',
                icon: Icons.logout,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                            await authProvider.logout(context: context);
                            provider.clearTeacher();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreenNew.routeName,
                                  (_) => false,
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              _actionTile(
                text: 'Delete Account',
                icon: Icons.delete_forever,
                isDanger: true,
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Delete Account'),
                      content: const Text(
                        'This will permanently delete your account and log you out. '
                            'This action cannot be undone. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                            final success =
                            await authProvider.deleteAccount(context: context);
                            if (success) {
                              provider.clearTeacher();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreenNew.routeName,
                                    (_) => false,
                              );
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  // Helper Widgets - Matching Institute/Parent Pattern
  Widget _chipSection({
    required String title,
    required List<String> values,
  }) {
    if (values.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: GlobalVariables.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: values.map((v) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                v,
                style: GoogleFonts.inter(
                  color: GlobalVariables.selectedColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            GlobalVariables.greyBackgroundColor.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GlobalVariables.selectedColor.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GlobalVariables.selectedColor.withOpacity(0.15),
                    GlobalVariables.selectedColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: GlobalVariables.selectedColor,
              ),
            ),
          if (icon != null) const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: GlobalVariables.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GlobalVariables.selectedColor.withOpacity(0.15),
            GlobalVariables.selectedColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: GlobalVariables.selectedColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GlobalVariables.selectedColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: GlobalVariables.selectedColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDanger
                ? [
              Colors.red.withOpacity(0.08),
              Colors.red.withOpacity(0.02),
            ]
                : [
              GlobalVariables.greyBackgroundColor.withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDanger
                ? Colors.red.withOpacity(0.2)
                : GlobalVariables.selectedColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDanger
                    ? Colors.red.withOpacity(0.12)
                    : GlobalVariables.selectedColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDanger ? Colors.red : GlobalVariables.selectedColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: isDanger ? Colors.red : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDanger ? Colors.red : Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    final tokenCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tokenCtrl,
              decoration: const InputDecoration(
                labelText: 'Reset Token',
                hintText: 'Enter token from email',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (tokenCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
                showSnackBar(context, 'All fields are required');
                return;
              }

              final authProvider =
              Provider.of<AuthProvider>(context, listen: false);

              final success = await authProvider.resetPassword(
                context: context,
                email: authProvider.email!,
                token: tokenCtrl.text.trim(),
                newPassword: passwordCtrl.text.trim(),
              );

              if (success) {
                Navigator.pop(context);
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}