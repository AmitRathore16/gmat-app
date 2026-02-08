import 'package:get_me_a_tutor/import_export.dart';

class ActiveJobsScreen extends StatefulWidget {
  final int jobsPosted;
  static const routeName = '/activeJobs';
  const ActiveJobsScreen({super.key, required this.jobsPosted});

  @override
  State<ActiveJobsScreen> createState() => _ActiveJobsScreenState();
}

class _ActiveJobsScreenState extends State<ActiveJobsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).fetchMyJobs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const PrimaryText(text: 'Active Jobs', size: 22),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 36),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Loader();

          final activeJobs =
          provider.jobs.where((job) => job.status != 'closed').toList();

          if (activeJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_off_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No active jobs yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Post a job to start hiring',
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
            itemCount: activeJobs.length,
            itemBuilder: (context, index) {
              final job = activeJobs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: JobCard(
                  job: job,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDescriptionScreen(
                          job: job,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
