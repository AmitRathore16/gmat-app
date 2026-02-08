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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
              child: TextField(
                controller: searchCtrl,
                onChanged: (v) {
                  context.read<TutorSearchProvider>().search(
                    context,
                    query: v,
                  );
                  setState(() {}); // 🔑 needed to toggle clear icon
                },
                cursorColor: GlobalVariables.selectedColor,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search tutors by subject, bio...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  prefixIcon: Icon(
                    Icons.search,
                    color: GlobalVariables.selectedColor,
                    size: 24,
                  ),

                  // ✅ CLEAR ICON
                  suffixIcon: searchCtrl.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey.shade500,
                    onPressed: () {
                      searchCtrl.clear();
                      context.read<TutorSearchProvider>().clear();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                  )
                      : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TutorSearchProvider>(
              builder: (context, provider, _) {
                if (!provider.hasSearched) {
                  return const Center(
                    child: Text(
                      'Search tutors by subject, bio, city...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                if (provider.isLoading) {
                  return const Loader();
                }

                if (provider.tutors.isEmpty) {
                  return const Center(
                    child: Text('No tutors found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.tutors.length,
                  itemBuilder: (_, i) {
                    final tutor = provider.tutors[i];
                    return TutorProfileCard(
                      tutor: tutor,
                      onViewProfile: () {
                        Navigator.pushNamed(
                        context,
                        TutorProfileViewScreen.routeName,
                        arguments: tutor.userId, // 👈 pass userId
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
