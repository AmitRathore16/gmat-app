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
          gradient: LinearGradient(
            colors: [
              Colors.white,
              GlobalVariables.greyBackgroundColor.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: GlobalVariables.greyBackgroundColor,
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
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: GlobalVariables.selectedColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: GlobalVariables.selectedColor.withOpacity(0.12),
                backgroundImage: photo != null && photo!.isNotEmpty
                    ? NetworkImage(photo!)
                    : null,
                child: (photo == null || photo!.isEmpty)
                    ? Icon(
                  Icons.person_outline,
                  color: GlobalVariables.selectedColor,
                  size: 28,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Applied for $role',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: GlobalVariables.selectedColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: GlobalVariables.selectedColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
