import 'package:get_me_a_tutor/import_export.dart';

class AllJobsScreen extends StatefulWidget {
  final int jobsPosted;
  static const routeName = '/allJobs';
  const AllJobsScreen({super.key, required this.jobsPosted});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
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
        title: const PrimaryText(text: 'All Jobs', size: 22),
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
                    'No jobs posted yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start by posting your first job',
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
                        builder: (_) => AllApplicationsScreen(
                          jobId: job.id,
                          jobTitle: job.title,
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
