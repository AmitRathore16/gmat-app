import 'package:get_me_a_tutor/import_export.dart';

class AllApplicationsScreen extends StatefulWidget {
  static const routeName = '/allApplications';

  final String jobId;
  final String jobTitle;

  const AllApplicationsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<AllApplicationsScreen> createState() => _AllApplicationsScreenState();
}

class _AllApplicationsScreenState extends State<AllApplicationsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobApplicationProvider>(
        context,
        listen: false,
      ).fetchApplications(
        context: context,
        jobId: widget.jobId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String timeAgo(DateTime date) {
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      return '${diff.inDays} days ago';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            const PrimaryText(text: 'Applications', size: 20),
            const SizedBox(height: 2),
            Text(
              widget.jobTitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 36),
        ),
      ),
      body: Consumer<JobApplicationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Loader();
          }

          if (provider.applications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No applications yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Applications will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.applications.length,
            itemBuilder: (context, index) {
              final app = provider.applications[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RecentApplicationCard(
                  onTap: () {
                    print('NAV tutorUserId: ${app.tutorUserId}');
                    if (app.tutorUserId.isEmpty) {
                      showSnackBar(context, 'Tutor profile unavailable');
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TutorApplicationScreen(
                          teacherName: app.tutorName,
                          tutorUserId: app.tutorUserId,
                          applicationId: app.id,
                          currentStatus: app.status,
                        ),
                      ),
                    );
                  },
                  photo: app.tutorPhoto,
                  name: app.tutorName,
                  role: app.jobTitle,
                  time: timeAgo(app.createdAt),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
