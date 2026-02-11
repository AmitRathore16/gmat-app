import 'package:get_me_a_tutor/import_export.dart';

class TutorDiscoveryScreen extends StatefulWidget {
  const TutorDiscoveryScreen({super.key});

  @override
  State<TutorDiscoveryScreen> createState() =>
      _TutorDiscoveryScreenState();
}

class _TutorDiscoveryScreenState extends State<TutorDiscoveryScreen> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalVariables.backgroundColor,
      child: Column(
        children: [
          // Header Section
          Container(
            color: GlobalVariables.surfaceColor,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            GlobalVariables.primaryColor.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(GlobalVariables.smallRadius),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: GlobalVariables.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find a Tutor',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: GlobalVariables.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Discover expert tutors',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: GlobalVariables.secondaryTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Search Bar
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: GlobalVariables.surfaceColor,
                      borderRadius:
                          BorderRadius.circular(GlobalVariables.defaultRadius),
                      border: Border.all(
                        color:
                            GlobalVariables.primaryColor.withOpacity(0.18),
                        width: 1.2,
                      ),
                    ),
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (v) {
                        context.read<TutorSearchProvider>().search(
                          context,
                          query: v,
                        );
                        setState(() {});
                      },
                      cursorColor: GlobalVariables.selectedColor,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: GlobalVariables.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by subject, name, or city...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 12),
                          child: Icon(
                            Icons.search_rounded,
                            color: GlobalVariables.primaryColor,
                            size: 24,
                          ),
                        ),
                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          onPressed: () {
                            searchCtrl.clear();
                            context.read<TutorSearchProvider>().clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        )
                            : Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.tune_rounded,
                            color: Colors.grey.shade400,
                            size: 24,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Consumer<TutorSearchProvider>(
              builder: (context, provider, _) {
                if (!provider.hasSearched) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                GlobalVariables.primaryColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search_rounded,
                            size: 64,
                            color:
                                GlobalVariables.primaryColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Start Your Search',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: GlobalVariables.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Search tutors by subject, name, bio, or city to find the perfect match',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: GlobalVariables.secondaryTextColor,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.isLoading) {
                  return const Loader();
                }

                if (provider.tutors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                GlobalVariables.warningColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_search_rounded,
                            size: 64,
                            color: GlobalVariables.warningColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Tutors Found',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: GlobalVariables.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search terms',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: GlobalVariables.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.tutors.length,
                  itemBuilder: (_, i) {
                    final tutor = provider.tutors[i];
                    return TutorProfileCard(
                      tutor: tutor,
                      onViewProfile: () {
                        Navigator.pushNamed(
                          context,
                          TutorProfileViewScreen.routeName,
                          arguments: tutor.userId,
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}