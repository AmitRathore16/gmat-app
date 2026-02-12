import 'package:get_me_a_tutor/import_export.dart';

class InstituteDashboard extends StatefulWidget {
  static const String routeName = '/instituteDashboard';
  const InstituteDashboard({super.key});

  @override
  State<InstituteDashboard> createState() => _InstituteDashboardState();
}

class _InstituteDashboardState extends State<InstituteDashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.role == 'institute' && auth.token != null) {
        context.read<InstituteProvider>().fetchMyInstitute(
          context,
          silent: true,
        );
      }

      context.read<JobApplicationProvider>().fetchRecentApplications(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;
    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: _currentIndex == 0
            ? RefreshIndicator(
          onRefresh: () async {
            await context
                .read<JobApplicationProvider>()
                .fetchRecentApplications(context);
          },
          color: const Color(0xFF3B82F6),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20 * scale),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _topHeader(scale),
                    const SizedBox(height: 32),
                    Text(
                      'Dashboard',
                      style: GoogleFonts.inter(
                        fontSize: 32 * scale,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Here's what's happening today",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

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
                                icon: Icons.people_outline_rounded,
                                color: const Color(0xFF3B82F6),
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                scale,
                                title: 'Active Jobs',
                                value: '${institute?.jobsPosted ?? 0}',
                                icon: Icons.work_outline_rounded,
                                color: const Color(0xFF10B981),
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
                        final credits =
                            provider.institution?.credits ?? 0;
                        final maxCredits = 1000;
                        final rawProgress = credits / maxCredits;
                        final progress = credits == 0
                            ? 0.02
                            : rawProgress.clamp(0.0, 1.0);

                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 10 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: GestureDetector(
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
                                      .fetchMyInstitute(
                                    context,
                                    silent: true,
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(24 * scale),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF2563EB),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withOpacity(0.3),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.2),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12),
                                            ),
                                            child: const Icon(
                                              Icons
                                                  .account_balance_wallet_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Credit Balance',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(100),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.add_circle_rounded,
                                              size: 16,
                                              color: Color(0xFF3B82F6),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Top up',
                                              style: GoogleFonts.inter(
                                                color: const Color(
                                                    0xFF3B82F6),
                                                fontWeight:
                                                FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$credits',
                                        style: GoogleFonts.inter(
                                          fontSize: 48 * scale,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8),
                                        child: Text(
                                          'credits available',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: Colors.white
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(
                                          milliseconds: 1200),
                                      tween:
                                      Tween(begin: 0.0, end: progress),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, value, _) {
                                        return LinearProgressIndicator(
                                          value: value,
                                          minHeight: 6,
                                          backgroundColor: Colors.white
                                              .withOpacity(0.2),
                                          valueColor:
                                          const AlwaysStoppedAnimation<
                                              Color>(Colors.white),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _quickAction(
                            icon: Icons.add_circle_outline_rounded,
                            text: 'Post a Job',
                            color: const Color(0xFF3B82F6),
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
                            icon: Icons.search_rounded,
                            text: 'Search Tutors',
                            color: const Color(0xFF10B981),
                            onTap: () {
                              setState(() {
                                _currentIndex = 2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Recent Applications
                    Consumer<InstituteProvider>(
                      builder: (context, provider, _) {
                        final institute = provider.institution;

                        return Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Applications',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
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
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF3B82F6),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ],
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
                          children: provider.recentApplications
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final app = entry.value;

                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                  milliseconds: 400 + (index * 100)),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset:
                                    Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: RecentApplicationCard(
                                onTap: () {},
                                photo: app.tutorPhoto,
                                name: app.tutorName,
                                role: app.jobTitle,
                                time: timeAgo(app.createdAt),
                              ),
                            );
                          })
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        )
            : _currentIndex == 1
            ? const Text('Jobs Screen')
            : _currentIndex == 2
            ? const TutorDiscoveryScreen()
            : const InstituteProfileScreen(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: const Color(0xFF3B82F6),
          unselectedItemColor: const Color(0xFF94A3B8),
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 24),
              activeIcon: Icon(Icons.dashboard_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded, size: 24),
              activeIcon: Icon(Icons.work_rounded, size: 24),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 24),
              activeIcon: Icon(Icons.search_rounded, size: 24),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 24),
              activeIcon: Icon(Icons.person_rounded, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

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
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFF1F5F9),
                              backgroundImage:
                              hasLogo ? NetworkImage(institute.logo!) : null,
                              child: !hasLogo
                                  ? const Icon(
                                Icons.school_rounded,
                                size: 24,
                                color: Color(0xFF64748B),
                              )
                                  : null,
                            ),
                          ),
                          if (institute?.isActive == true)
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border:
                                  Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      institute?.institutionName ?? 'Your Institute',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF475569),
                  size: 22,
                ),
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
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - animValue)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 32 * scale,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(double scale) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.15),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 48,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You're all caught up!",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No new applications at the moment',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}