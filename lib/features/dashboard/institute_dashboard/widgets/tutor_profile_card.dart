import 'package:get_me_a_tutor/import_export.dart';

class TutorProfileCard extends StatelessWidget {
  final TutorSearchModel tutor;
  final VoidCallback onViewProfile;

  const TutorProfileCard({
    super.key,
    required this.tutor,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: GlobalVariables.surfaceColor,
        borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius + 6),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: GlobalVariables.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: GlobalVariables.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(GlobalVariables.defaultRadius + 6),
                topRight: Radius.circular(GlobalVariables.defaultRadius + 6),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: GlobalVariables.primarySoft,
                    borderRadius:
                        BorderRadius.circular(GlobalVariables.smallRadius),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.black87,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Tutor',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: GlobalVariables.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: GlobalVariables.primaryTextColor,
                            ),
                          ),
                          Text(
                            ' (124 reviews)',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: GlobalVariables.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: GlobalVariables.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: GlobalVariables.successColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${tutor.experienceYears} yrs',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: GlobalVariables.successColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio
                Text(
                  tutor.bio,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: GlobalVariables.secondaryTextColor,
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Subjects
                Text(
                  'Subjects',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: GlobalVariables.secondaryTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tutor.subjects
                      .map(
                        (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: GlobalVariables.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: GlobalVariables.primaryColor.withOpacity(0.35),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: GlobalVariables.primaryColor,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),

                const SizedBox(height: 20),

                // View Profile Button
                CustomButton(
                  text: 'View Full Profile',
                  onTap: onViewProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}