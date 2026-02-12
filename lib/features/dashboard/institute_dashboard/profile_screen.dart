import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileScreen extends StatelessWidget {
  const InstituteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;
    String buildAddress(InstitutionAddress address) {
      final parts = [
        address.street,
        address.city,
        address.state,
        address.pincode,
      ].where((e) => e != null && e.trim().isNotEmpty).toList();

      return parts.isEmpty ? 'Not provided' : parts.join(', ');
    }

    return Consumer<InstituteProvider>(
      builder: (context, provider, _) {
        final institute = provider.institution;
        final hasLogo =
            institute?.logo != null && institute!.logo!.trim().isNotEmpty;
        if (provider.isLoading) {
          return const Center(child: Loader());
        }

        if (institute == null) {
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

              /// ───────── Header ─────────
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
                        backgroundColor: GlobalVariables.selectedColor
                            .withOpacity(0.15),
                        backgroundImage: hasLogo
                            ? NetworkImage(institute.logo!)
                            : null,
                        child: !hasLogo
                            ? Icon(
                          Icons.school_rounded,
                          size: 42,
                          color: GlobalVariables.selectedColor,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      institute.institutionName,
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
                        institute.institutionType,
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

              /// ───────── Info Card ─────────
              _infoCard(
                title: 'About',
                value: institute.about ?? 'No description provided',
              ),

              _infoCard(
                title: 'Email',
                value: institute.email ?? 'Not provided',
                icon: Icons.email_rounded,
              ),

              _infoCard(
                title: 'Phone',
                value: institute.phone ?? 'Not provided',
                icon: Icons.phone_rounded,
              ),

              _infoCard(
                title: 'Website',
                value: institute.website ?? 'Not provided',
                icon: Icons.language,
              ),

              if (institute.address != null)
                _infoCard(
                  title: 'Address',
                  value: buildAddress(institute.address!),
                  icon: Icons.location_on,
                ),

              const SizedBox(height: 28),

              /// ───────── Stats ─────────
              Row(
                children: [
                  Expanded(
                    child: _statBox(
                      title: 'Credits',
                      value: institute.credits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBox(
                      title: 'Jobs Posted',
                      value: institute.jobsPosted.toString(),
                    ),
                  ),
                ],
              ),

              // ───────── Gallery Images ─────────
              const SizedBox(height: 24),
              const PrimaryText(text: 'Gallery', size: 18),
              const SizedBox(height: 12),

              Consumer<InstituteProvider>(
                builder: (context, provider, _) {
                  final images = provider.institution?.galleryImages ?? [];

                  return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GlobalVariables.greyBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: images.isEmpty
                          ? Column(
                        children: const [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          SecondaryText(
                            text: 'No gallery images uploaded yet',
                            size: 14,
                          ),
                        ],
                      )
                          : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 👈 4 images per row
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1, // square
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              image: DecorationImage(
                                image: NetworkImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      )

                  );
                },
              ),

              const SizedBox(height: 32),

              /// ───────── Actions ─────────
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InstituteProfileUpdateScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _actionTile(
                text: 'Reset Password',
                icon: Icons.lock_reset,
                onTap: () {
                  _showResetPasswordDialog(context);
                },
              ),

              _actionTile(
                text: 'Logout',
                icon: Icons.logout,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
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

                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            final instituteProvider =
                            Provider.of<InstituteProvider>(
                              context,
                              listen: false,
                            );

                            await authProvider.logout(context: context);
                            instituteProvider.clearInstitute();

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreenNew.routeName,
                                  (route) => false,
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
                      title: const Text('Delete Account'),
                      content: const Text(
                        'This will permanently delete your institute profile and log you out. '
                            'This action cannot be undone.\n\nAre you sure?',
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
                            final instituteProvider =
                            Provider.of<InstituteProvider>(context, listen: false);

                            final success = await authProvider.deleteAccount(context: context);

                            if (success) {
                              instituteProvider.clearInstitute();

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

  // ───────── Reusable Widgets ─────────

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

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

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