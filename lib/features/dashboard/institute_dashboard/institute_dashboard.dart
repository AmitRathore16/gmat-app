import 'package:get_me_a_tutor/import_export.dart';

class InstituteDashboard extends StatefulWidget {
  static const String routeName = '/instituteDashboard';
  const InstituteDashboard({super.key});

  @override
  State<InstituteDashboard> createState() => _InstituteDashboardState();
}

class _InstituteDashboardState extends State<InstituteDashboard> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.role == 'institute' && auth.token != null) {
        context.read<InstituteProvider>().fetchMyInstitute(
          context,
          silent: true, // 👈 this handles profile-not-created case
        );
      }

      context.read<JobApplicationProvider>()
          .fetchRecentApplications(context);
    });
  }
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

      body: SafeArea(
        child: _currentIndex == 0
            ? RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<JobApplicationProvider>()
                  .fetchRecentApplications(context);
            },
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _topHeader(scale),
                    const SizedBox(height: 24),
                    PrimaryText(text: 'Dashboard', size: 26 * scale),
                    const SizedBox(height: 4),
                    const SecondaryText(
                      text: "Here's what's happening today.",
                      size: 14,
                    ),
                    const SizedBox(height: 20),

                    // Stats
                    Consumer<InstituteProvider>(
                      builder: (context, provider, _) {
                        final institute = provider.institution;

                        return Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                scale,
                                title: 'Tutors Hired',
                                value: '${institute?.tutorsHired ?? 0}',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                scale,
                                title: 'Active Jobs',
                                value: '${institute?.jobsPosted}',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ActiveJobsScreen(
                                        jobsPosted: institute!.jobsPosted,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Credit Balance
                    Consumer<InstituteProvider>(
                      builder: (context, provider, _) {
                        final credits = provider.institution?.credits ?? 0;
                        final maxCredits = 1000; // can come from backend later
                        final rawProgress = credits / maxCredits;
                        final progress = credits == 0
                            ? 0.02
                            : rawProgress.clamp(0.0, 1.0);

                        return GestureDetector(
                          onTap: () {
                            final auth = context.read<AuthProvider>();
                            Navigator.pushNamed(
                              context,
                              '/wallet',
                              arguments: {
                                'currentCredits': credits,
                                'userId': auth.userId,
                                'userRole': 'institute',
                              },
                            ).then((value) {
                              if (value == true) {
                                context
                                    .read<InstituteProvider>()
                                    .fetchMyInstitute(context, silent: true);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(20 * scale),
                            decoration: BoxDecoration(
                              color: GlobalVariables.primaryColor
                                  .withOpacity(0.96),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: GlobalVariables.softCardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.16),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                            color:
                                                Colors.white.withOpacity(0.95),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final auth = context.read<AuthProvider>();
                                        Navigator.pushNamed(
                                          context,
                                          '/wallet',
                                          arguments: {
                                            'currentCredits': credits,
                                            'userId': auth.userId,
                                            'userRole': 'institute',
                                          },
                                        ).then((value) {
                                          // Refresh profile after payment
                                          if (value == true) {
                                            context
                                                .read<InstituteProvider>()
                                                .fetchMyInstitute(context, silent: true);
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
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              size: 16,
                                              color:
                                                  GlobalVariables.primaryColor,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Top up',
                                              style: GoogleFonts.inter(
                                                color: GlobalVariables
                                                    .primaryColor,
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
                                      '$credits',
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
                                          color:
                                              Colors.white.withOpacity(0.85),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 8,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );                      },
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const PrimaryText(text: 'Quick Actions', size: 18),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _quickAction(
                            icon: Icons.add,
                            text: 'Post a Job',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                JobPostScreen.routeName,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _quickAction(
                            icon: Icons.search,
                            text: 'Search Tutors',
                            onTap: () {
                              setState(() {
                                _currentIndex = 2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Recent Applications
                    Consumer<InstituteProvider>(
                      builder: (context, provider, _) {
                        final institute = provider.institution;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const PrimaryText(
                              text: 'Recent Applications',
                              size: 18,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AllJobsScreen(
                                      jobsPosted: institute!.jobsPosted,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: GlobalVariables.selectedColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    Consumer<JobApplicationProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Loader();
                        }

                        if (provider.recentApplications.isEmpty) {
                          return _emptyState(scale);
                        }

                        return Column(
                          children: provider.recentApplications.map((app) {
                            return RecentApplicationCard(
                              onTap: () {},
                              photo: app.tutorPhoto,
                              name: app.tutorName,
                              role: app.jobTitle,
                              time: timeAgo(app.createdAt),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              )
        )
            : _currentIndex == 1
                ? const Text('Jobs Screen')
                : _currentIndex == 2
                    ? const TutorDiscoveryScreen()
                    : const InstituteProfileScreen(),
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
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.search),
              label: 'Search',
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

  // ───────── widgets ─────────

  Widget _topHeader(double scale) {
    return Consumer<InstituteProvider>(
      builder: (context, provider, _) {
        final institute = provider.institution;
        final hasLogo =
            institute?.logo != null && institute!.logo!.trim().isNotEmpty;
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
                          hasLogo ? NetworkImage(institute.logo!) : null,
                      child: !hasLogo
                          ? const Icon(
                              Icons.school,
                              size: 32,
                              color: Colors.black54,
                            )
                          : null,
                    ),

                    // active indicator
                    if (institute?.isActive == true)
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
                      text: institute?.institutionName ?? 'Your Institute',
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black87,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
      double scale, {
        required String title,
        required String value,
        required VoidCallback onTap,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 32 * scale,
                fontWeight: FontWeight.w700,
                color: GlobalVariables.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
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

  Widget _emptyState(double scale) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: GlobalVariables.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GlobalVariables.successColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48,
              color: GlobalVariables.successColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You are all caught up!',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: GlobalVariables.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No new applications at the moment',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: GlobalVariables.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
