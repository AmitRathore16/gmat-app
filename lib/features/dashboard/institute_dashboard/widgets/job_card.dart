import 'package:get_me_a_tutor/import_export.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String deadlineText() {
      if (job.deadline == null) return 'No deadline';
      final d = job.deadline!;
      return '${d.day}/${d.month}/${d.year}';
    }

    Color statusColor() {
      switch (job.status) {
        case 'active':
          return Colors.green;
        case 'closed':
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: GlobalVariables.surfaceColor,
          borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: GlobalVariables.subtleShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───────── HEADER ─────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GlobalVariables.selectedColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.work_outline,
                    size: 22,
                    color: GlobalVariables.selectedColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Role',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor().withOpacity(0.2),
                        statusColor().withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.status.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ───────── SUBJECTS ─────────
            if (job.subjects.isNotEmpty) ...[
              Text(
                'Subjects',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.subjects
                    .map(
                      (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GlobalVariables.selectedColor.withOpacity(0.12),
                          GlobalVariables.selectedColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: GlobalVariables.selectedColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.selectedColor,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ───────── GRID ROW 1 ─────────
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: job.location ?? 'Not specified',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoTile(
                    icon: Icons.work_history_outlined,
                    label: 'Job Type',
                    value: job.jobType.replaceAll('-', ' ').toUpperCase(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ───────── GRID ROW 2 ─────────
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Deadline',
                    value: deadlineText(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _infoTile(
                    icon: Icons.currency_rupee,
                    label: 'Salary',
                    value: job.salary != null
                        ? '₹${job.salary}'
                        : 'Not specified',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────── INFO TILE ─────────
  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GlobalVariables.backgroundColor,
        borderRadius: BorderRadius.circular(GlobalVariables.smallRadius),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: GlobalVariables.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: GlobalVariables.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: GlobalVariables.primaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
