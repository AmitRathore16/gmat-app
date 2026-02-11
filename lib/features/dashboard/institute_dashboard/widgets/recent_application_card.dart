import 'package:get_me_a_tutor/import_export.dart';

class RecentApplicationCard extends StatelessWidget {
  final String name;
  final String role;
  final String time;
  final String? photo;
  final VoidCallback onTap;

  const RecentApplicationCard({
    super.key,
    this.photo,
    required this.name,
    required this.role,
    required this.time,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GlobalVariables.surfaceColor,
          borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: GlobalVariables.subtleShadow,
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: GlobalVariables.primarySoft,
                backgroundImage: photo != null && photo!.isNotEmpty
                    ? NetworkImage(photo!)
                    : null,
                child: (photo == null || photo!.isEmpty)
                    ? Icon(
                  Icons.person_rounded,
                  color: GlobalVariables.primaryColor,
                  size: 26,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: GlobalVariables.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Applied for $role',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: GlobalVariables.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                color: GlobalVariables.primarySoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: GlobalVariables.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: GlobalVariables.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}