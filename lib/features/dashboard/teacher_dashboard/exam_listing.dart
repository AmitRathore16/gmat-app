import 'package:get_me_a_tutor/import_export.dart';

class ExamListingScreen extends StatelessWidget {
  static const String routeName = '/examListing';

  const ExamListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 393;

    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const PrimaryText(text: 'Exam Center', size: 20),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Top Stats
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconBg: Colors.blue.shade50,
                    iconColor: Colors.blue.shade600,
                    value: '120',
                    label: 'CREDITS',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.star,
                    iconBg: Colors.orange.shade50,
                    iconColor: Colors.orange.shade600,
                    value: '4.8',
                    label: 'RATING',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('All Subjects', selected: true),
                  _filterChip('Mathematics'),
                  _filterChip('Science'),
                  _filterChip('Languages'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const PrimaryText(text: 'Available Now', size: 18),
            const SizedBox(height: 12),

            // Exam Cards
            _examCard(
              level: 'ADVANCED',
              levelColor: Colors.purple,
              duration: '2H',
              title: 'Calculus II Final',
              subtitle: 'University of California • Math Dept',
              credits: '+50 Credits',
              rating: 'High',
              primaryAction: 'Start Exam',
              highlight: true,
            ),
            _examCard(
              level: 'INTERMEDIATE',
              levelColor: Colors.blue,
              duration: '1.5H',
              title: 'Organic Chemistry 101',
              subtitle: 'Science Academy • Chem Dept',
              credits: '+35 Credits',
              rating: 'Normal',
              primaryAction: 'View Details',
            ),
            _examCard(
              level: 'BEGINNER',
              levelColor: Colors.green,
              duration: '45M',
              title: 'Intro to Spanish',
              subtitle: 'Language Center • Spanish Dept',
              credits: '+15 Credits',
              rating: 'Normal',
              primaryAction: 'View Details',
            ),
            _examCard(
              level: 'ADVANCED',
              levelColor: Colors.purple,
              duration: '3H',
              title: 'Quantum Physics A',
              subtitle: 'Tech Institute • Physics Dept',
              credits: '+80 Credits',
              rating: 'High',
              primaryAction: 'View Details',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconBg.withOpacity(0.3),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: GlobalVariables.primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String text, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
          colors: [
            GlobalVariables.selectedColor,
            GlobalVariables.selectedColor.withOpacity(0.8),
          ],
        )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected
              ? GlobalVariables.selectedColor
              : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: selected
            ? [
          BoxShadow(
            color: GlobalVariables.selectedColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _examCard({
    required String level,
    required Color levelColor,
    required String duration,
    required String title,
    required String subtitle,
    required String credits,
    required String rating,
    required String primaryAction,
    bool highlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: highlight
            ? LinearGradient(
          colors: [
            GlobalVariables.selectedColor.withOpacity(0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: highlight ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: highlight
            ? Border.all(
          color: GlobalVariables.selectedColor.withOpacity(0.3),
          width: 2,
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: highlight
                ? GlobalVariables.selectedColor.withOpacity(0.1)
                : Colors.black.withOpacity(0.04),
            blurRadius: highlight ? 16 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      levelColor.withOpacity(0.15),
                      levelColor.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: levelColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.inter(
                    color: levelColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                duration,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GlobalVariables.primaryTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EARN',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    credits,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RATING',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: rating == 'High'
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rating,
                      style: GoogleFonts.inter(
                        color: rating == 'High'
                            ? Colors.green.shade700
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlight
                      ? GlobalVariables.selectedColor
                      : GlobalVariables.greyBackgroundColor,
                  foregroundColor: highlight ? Colors.white : Colors.black87,
                  elevation: highlight ? 2 : 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  primaryAction,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}