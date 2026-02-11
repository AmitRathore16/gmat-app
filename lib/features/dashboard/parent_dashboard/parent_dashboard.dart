import 'package:get_me_a_tutor/features/dashboard/parent_dashboard/parent_profile_screen.dart';
import 'package:get_me_a_tutor/features/dashboard/parent_dashboard/parent_profile_update_screen.dart';
import 'package:get_me_a_tutor/import_export.dart';

class ParentDashboard extends StatefulWidget {
  static const String routeName = '/parentDashboard';
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();

      if (auth.role == 'parent' && auth.token != null) {
        context.read<ParentProfileProvider>().fetchMyParentProfile(context);
      }

      context.read<JobApplicationProvider>().fetchRecentApplications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    }

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,

      body: SafeArea(
        child: _currentIndex == 0
            ? RefreshIndicator(
                color: GlobalVariables.selectedColor,
                onRefresh: () async {
                  await context
                      .read<JobApplicationProvider>()
                      .fetchRecentApplications(context);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header Section
                      Container(
                        color: GlobalVariables.surfaceColor,
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _topHeader(scale),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: GlobalVariables.primaryColor
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(
                                      GlobalVariables.smallRadius,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.dashboard_rounded,
                                    color: GlobalVariables.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dashboard',
                                      style: GoogleFonts.inter(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: GlobalVariables.primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      "Here's what's happening today",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: GlobalVariables.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Main Content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),

                            /// ───────── Stats ─────────
                            Consumer<ParentProfileProvider>(
                              builder: (context, provider, _) {
                                final parent = provider.parent;

                                return Row(
                                  children: [
                                    Expanded(
                                      child: _statCard(
                                        scale,
                                        title: 'Tutors Hired',
                                        value: '${parent?.tutorsHired ?? 0}',
                                        icon: Icons.school_rounded,
                                        color: GlobalVariables.successColor,
                                        onTap: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _statCard(
                                        scale,
                                        title: 'Active Jobs',
                                        value: '${parent?.jobsPosted ?? 0}',
                                        icon: Icons.work_rounded,
                                        color: GlobalVariables.warningColor,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ActiveJobsScreen(
                                                jobsPosted:
                                                    parent?.jobsPosted ?? 0,
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

                            const SizedBox(height: 20),

                            /// ───────── Credit Balance ─────────
                            Consumer<ParentProfileProvider>(
                              builder: (context, provider, _) {
                                final credits = provider.parent?.credits ?? 0;
                                final maxCredits = 1000;
                                final progress = credits == 0
                                    ? 0.02
                                    : (credits / maxCredits).clamp(0.0, 1.0);

                                return GestureDetector(
                                  onTap: () {
                                    final auth = context.read<AuthProvider>();
                                    Navigator.pushNamed(
                                      context,
                                      '/wallet',
                                      arguments: {
                                        'currentCredits': credits,
                                        'userId': auth.userId,
                                        'userRole': 'parent',
                                      },
                                    ).then((value) {
                                      if (value == true) {
                                        context
                                            .read<ParentProfileProvider>()
                                            .fetchMyParentProfile(context);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      color: GlobalVariables.primaryColor
                                          .withOpacity(0.96),
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow:
                                          GlobalVariables.softCardShadow,
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
                                                          12,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .account_balance_wallet_rounded,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Available Credits',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                final auth = context
                                                    .read<AuthProvider>();
                                                Navigator.pushNamed(
                                                  context,
                                                  '/wallet',
                                                  arguments: {
                                                    'currentCredits': credits,
                                                    'userId': auth.userId,
                                                    'userRole': 'parent',
                                                  },
                                                ).then((value) {
                                                  if (value == true) {
                                                    context
                                                        .read<
                                                          ParentProfileProvider
                                                        >()
                                                        .fetchMyParentProfile(
                                                          context,
                                                        );
                                                  }
                                                });
                                              },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 14,
                                                    vertical: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      999,
                                                    ),
                                                    boxShadow:
                                                        GlobalVariables
                                                            .subtleShadow,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add_circle,
                                                        size: 16,
                                                        color: GlobalVariables
                                                            .primaryColor,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        'Top Up',
                                                        style: GoogleFonts.inter(
                                                          color: GlobalVariables
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                'cr',
                                                style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 8,
                                            backgroundColor: Colors.white
                                                .withOpacity(0.2),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Colors.white),
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text(
                                          '${(credits * 100 / maxCredits).toStringAsFixed(0)}% of $maxCredits credits',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 28),

                            /// ───────── Quick Actions ─────────
                            Row(
                              children: [
                                Icon(
                                  Icons.flash_on_rounded,
                                  color: GlobalVariables.selectedColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Quick Actions',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: GlobalVariables.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _quickAction(
                                    icon: Icons.add_circle_outline_rounded,
                                    text: 'Post Job',
                                    gradient: [
                                      const Color(0xFF667EEA),
                                      const Color(0xFF764BA2),
                                    ],
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
                                    text: 'Find Tutors',
                                    gradient: [
                                      const Color(0xFFF093FB),
                                      const Color(0xFFF5576C),
                                    ],
                                    onTap: () {
                                      setState(() => _currentIndex = 2);
                                    },
                                  ),
                                ),
                              ],
                            ),


                            const SizedBox(height: 32),

                            /// ───────── Recent Applications ─────────
                            Consumer<ParentProfileProvider>(
                              builder: (context, provider, _) {
                                final parent = provider.parent;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.receipt_long_rounded,
                                          color: Colors.black87,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Recent Applications',
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                GlobalVariables.primaryTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AllJobsScreen(
                                              jobsPosted: parent!.jobsPosted,
                                            ),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: GoogleFonts.inter(
                                              color:
                                                  GlobalVariables.selectedColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12,
                                            color:
                                                GlobalVariables.selectedColor,
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
                                  children: provider.recentApplications.map((
                                    app,
                                  ) {
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
                      ),
                    ],
                  ),
                ),
              )
            : _currentIndex == 1
            ? const Center(child: Text('Jobs Screen'))
            : _currentIndex == 2
            ? TutorDiscoveryScreen()
            : const ParentProfileScreen(),
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
          elevation: 0,
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 26),
              activeIcon: Icon(Icons.home_rounded, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded, size: 26),
              activeIcon: Icon(Icons.work_rounded, size: 26),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded, size: 26),
              activeIcon: Icon(Icons.search_rounded, size: 26),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 26),
              activeIcon: Icon(Icons.person_rounded, size: 26),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  /// ───────── HEADER ─────────
  Widget _topHeader(double scale) {
    return Consumer<ParentProfileProvider>(
      builder: (context, provider, _) {
        final parent = provider.parent;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        GlobalVariables.selectedColor,
                        GlobalVariables.selectedColor.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: GlobalVariables.selectedColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.transparent,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning 👋',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      parent?.name ?? 'Parent',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.black87,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 32 * scale,
                fontWeight: FontWeight.w800,
                color: color,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
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
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 26, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 56,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'All Caught Up!',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No new applications at the moment',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
