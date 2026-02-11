import 'package:get_me_a_tutor/import_export.dart';

class TeacherDashboard extends StatefulWidget {
  static const String routeName = '/teacherDashboard';
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.userId != null) {
        Provider.of<TeacherProvider>(
          context,
          listen: false,
        ).fetchTeacherProfile(
          context,
          auth.userId!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final scale = MediaQuery.of(context).size.width / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: _currentIndex == 0
            ? _dashboard(scale)
            : _currentIndex == 1
                ? const Center(child: Text('Jobs Screen'))
                : _currentIndex == 2
                    ? const Center(child: Text('Exams Screen'))
                    : TeacherProfileScreen(
                        name: auth.name ?? 'No name provided',
                      ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: GlobalVariables.surfaceColor,
          boxShadow: GlobalVariables.subtleShadow,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: GlobalVariables.primaryColor,
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          backgroundColor: GlobalVariables.surfaceColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Exams',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboard(double scale) {
    return Consumer2<TeacherProvider, AuthProvider>(
      builder: (context, teacherProvider, authProvider, _) {
        if (teacherProvider.isLoading) {
          return const Center(child: Loader());
        }

        final t = teacherProvider.teacher;
        if (t == null) {
          return const Center(
            child: SecondaryText(text: 'No profile found', size: 18),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await teacherProvider.fetchTeacherProfile(
              context,
              authProvider.userId!,
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _topHeader(scale, t, authProvider),
                const SizedBox(height: 24),
                PrimaryText(text: 'Dashboard', size: 26 * scale),
                const SizedBox(height: 4),
                const SecondaryText(
                  text: "Here's what's happening today.",
                  size: 14,
                ),
                const SizedBox(height: 20),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        scale: scale,
                        icon: Icons.star,
                        title: 'Rating',
                        value: '${t.rating ?? 0}',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        scale: scale,
                        icon: Icons.verified,
                        title: 'Exams Passed',
                        value: '${t.examsPassed ?? 0}',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _statCard(
                  scale: scale,
                  icon: Icons.work_outline,
                  title: 'Jobs Applied',
                  value: '${t.jobsApplied ?? 0}',
                  onTap: () {
                    Navigator.pushNamed(context, AppliedJobsScreen.routeName);
                  },
                  fullWidth: true,
                ),

                const SizedBox(height: 16),

                // Credit Balance Card
                Container(
                  padding: EdgeInsets.all(20 * scale),
                  decoration: BoxDecoration(
                    color: GlobalVariables.primaryColor.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: GlobalVariables.softCardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Credit Balance',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/wallet',
                                arguments: {
                                  'currentCredits': t.credits ?? 0,
                                  'userId': authProvider.userId,
                                  'userRole': 'teacher',
                                },
                              ).then((value) {
                                // Refresh profile after payment
                                if (value == true) {
                                  teacherProvider.fetchTeacherProfile(
                                    context,
                                    authProvider.userId!,
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    size: 16,
                                    color: GlobalVariables.primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Top up',
                                    style: GoogleFonts.inter(
                                      color: GlobalVariables.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${t.credits ?? 0}',
                            style: GoogleFonts.inter(
                              fontSize: 40 * scale,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              'credits available',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: ((t.credits ?? 0) / 1000).clamp(0.02, 1),
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Quick Actions
                const PrimaryText(text: 'Quick Actions', size: 18),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        icon: Icons.work,
                        text: 'View Jobs',
                        onTap: () {
                          Navigator.pushNamed(context, TutorViewJobsScreen.routeName);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.school,
                        text: 'Take Exams',
                        onTap: () {
                          Navigator.pushNamed(context, ExamListingScreen.routeName);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper Widgets
  Widget _topHeader(double scale, teacher, AuthProvider authProvider) {
    final hasPhoto = teacher?.photo?.url != null && teacher!.photo!.url!.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      GlobalVariables.primaryColor.withOpacity(0.08),
                  backgroundImage:
                      hasPhoto ? NetworkImage(teacher.photo!.url!) : null,
                  child: !hasPhoto
                      ? const Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.black54,
                        )
                      : null,
                ),
                if (teacher?.isActive == true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SecondaryText(text: 'Welcome back,', size: 12),
                PrimaryText(
                  text: authProvider.name ?? 'Teacher',
                  size: 16,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded,
              color: Colors.black87),
        ),
      ],
    );
  }

  Widget _statCard({
    required double scale,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18 * scale),
        decoration: BoxDecoration(
          color: GlobalVariables.surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: GlobalVariables.subtleShadow,
        ),
        child: fullWidth
            ? Row(
          children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GlobalVariables.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: GlobalVariables.primaryColor,
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 28 * scale,
                      fontWeight: FontWeight.w700,
                      color: GlobalVariables.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: GlobalVariables.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: GlobalVariables.selectedColor.withOpacity(0.5),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: GlobalVariables.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 28 * scale,
                fontWeight: FontWeight.w700,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: GlobalVariables.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: GlobalVariables.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: GlobalVariables.subtleShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: GlobalVariables.primaryColor,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}