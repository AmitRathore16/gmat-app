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
        context
            .read<ParentProfileProvider>()
            .fetchMyParentProfile(context);
      }

      context
          .read<JobApplicationProvider>()
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
                    PrimaryText(text: 'Dashboard', size: 28 * scale),
                    const SizedBox(height: 4),
                    SecondaryText(
                      text: "Here's what's happening today.",
                      size: 14,
                    ),

                    const SizedBox(height: 20),

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
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                scale,
                                title: 'Active Jobs',
                                value: '${parent?.jobsPosted ?? 0}',
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

                    const SizedBox(height: 16),

                    /// ───────── Credit Balance ─────────
                    Consumer<ParentProfileProvider>(
                      builder: (context, provider, _) {
                        final credits = provider.parent?.credits ?? 0;
                        final maxCredits = 1000;
                        final progress = credits == 0
                            ? 0.02
                            : (credits / maxCredits).clamp(0.0, 1.0);

                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(20 * scale),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  GlobalVariables.selectedColor.withOpacity(0.15),
                                  GlobalVariables.selectedColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: GlobalVariables.selectedColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: GlobalVariables.selectedColor.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
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
                                            color: GlobalVariables.selectedColor.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_wallet,
                                            size: 20,
                                            color: GlobalVariables.selectedColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Credit Balance',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: GlobalVariables.selectedColor,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: GlobalVariables.selectedColor.withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'Top up',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
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
                                        fontSize: 38 * scale,
                                        fontWeight: FontWeight.w800,
                                        color: GlobalVariables.selectedColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        'credits available',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
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
                                        minHeight: 10,
                                        backgroundColor: Colors.white.withOpacity(0.5),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          GlobalVariables.selectedColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ───────── Quick Actions ─────────
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
                              setState(() => _currentIndex = 2);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// ───────── Recent Applications ─────────

                    // Recent Applications
                    Consumer<ParentProfileProvider>(
                      builder: (context, provider, _) {
                        final parent = provider.parent;

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
                                      jobsPosted: parent!.jobsPosted,
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
                          children: provider.recentApplications.map(
                                (app) {
                              return RecentApplicationCard(
                                onTap: () {},
                                photo: app.tutorPhoto,
                                name: app.tutorName,
                                role: app.jobTitle,
                                time: timeAgo(app.createdAt),
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              )
          )
              : _currentIndex == 1
              ? const Center(child: Text('Jobs Screen'))
              : _currentIndex == 2
              ? TutorDiscoveryScreen()
              : const ParentProfileScreen()
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: GlobalVariables.selectedColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.work), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: ''),
        ],
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
                    boxShadow: [
                      BoxShadow(
                        color: GlobalVariables.selectedColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor:
                    GlobalVariables.selectedColor.withOpacity(0.2),
                    child: const Icon(Icons.person,
                        size: 32, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SecondaryText(
                        text: 'Welcome back,', size: 12),
                    PrimaryText(
                      text: parent?.name ?? 'Parent',
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications, color: Colors.black),
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
          gradient: LinearGradient(
            colors: [
              GlobalVariables.selectedColor.withOpacity(0.08),
              GlobalVariables.selectedColor.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: GlobalVariables.selectedColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: GlobalVariables.selectedColor.withOpacity(0.08),
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
                fontSize: 32 * scale,
                fontWeight: FontWeight.w700,
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
          gradient: LinearGradient(
            colors: [
              GlobalVariables.selectedColor.withOpacity(0.08),
              GlobalVariables.selectedColor.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: GlobalVariables.selectedColor.withOpacity(0.2),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: GlobalVariables.selectedColor,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GlobalVariables.selectedColor,
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
        gradient: LinearGradient(
          colors: [
            GlobalVariables.greyBackgroundColor.withOpacity(0.5),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You are all caught up!',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No new applications at the moment',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}